<?php

namespace App\Controllers\Api;

use App\Models\CommandeModel;
use App\Models\PanierItemModel;
use App\Support\JwtSupport;
use CodeIgniter\RESTful\ResourceController;

class CommandesApi extends ResourceController
{
    protected $format = 'json';

    public function index()
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        // L'historique mobile retourne uniquement les commandes du porteur du
        // token. Le total est recalcule depuis les lignes pour rester fiable.
        $db = db_connect();
        $builder = $db->table('commande c');
        $builder->select('c.id_commande, c.date_commande, c.quantite, COALESCE(SUM(a.quantite * CAST(Produit.prix AS DECIMAL(10,2))), 0) AS total_montant');
        $builder->join('appartenir a', 'a.id_commande = c.id_commande', 'left');
        $builder->join('Produit', 'Produit.id_produit = a.id_produit', 'left');
        $builder->where('c.id_utilisateur', $userId);
        $builder->groupBy('c.id_commande, c.date_commande, c.quantite');
        $builder->orderBy('c.date_commande', 'DESC');

        $commandes = $builder->get()->getResultArray();

        foreach ($commandes as &$commande) {
            $commande['id_commande'] = (int) ($commande['id_commande'] ?? 0);
            $commande['quantite'] = (int) ($commande['quantite'] ?? 0);
            $commande['total_montant'] = (float) ($commande['total_montant'] ?? 0);
        }

        return $this->respond($commandes);
    }

    public function show($id = null)
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        $commandeModel = new CommandeModel();
        $commande = $commandeModel
            ->where('id_commande', $id)
            ->where('id_utilisateur', $userId)
            ->first();

        if (! $commande) {
            return $this->failNotFound('Commande introuvable');
        }

        // Meme si un utilisateur connait un id_commande, la requete precedente
        // impose id_utilisateur = userId. Le detail reste donc cloisonne.
        $db = db_connect();
        $builder = $db->table('appartenir');
        $builder->select('Produit.id_produit, Produit.nom, Produit.description, Produit.prix, Produit.image, appartenir.quantite, appartenir.quantite * CAST(Produit.prix AS DECIMAL(10,2)) AS sous_total');
        $builder->join('Produit', 'Produit.id_produit = appartenir.id_produit', 'left');
        $builder->where('appartenir.id_commande', $id);

        $lignes = $builder->get()->getResultArray();

        $totalMontant = 0;
        foreach ($lignes as &$ligne) {
            $ligne['prix'] = (float) ($ligne['prix'] ?? 0);
            $ligne['quantite'] = (int) ($ligne['quantite'] ?? 0);
            $ligne['sous_total'] = (float) ($ligne['sous_total'] ?? 0);
            $totalMontant += (float) ($ligne['sous_total'] ?? 0);
        }

        $commande['id_commande'] = (int) ($commande['id_commande'] ?? 0);
        $commande['quantite'] = (int) ($commande['quantite'] ?? 0);
        $commande['total_montant'] = $totalMontant;
        $commande['lignes'] = $lignes;

        return $this->respond($commande);
    }

    public function create()
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        $rawItems = $this->resolveRawItems($userId);
        if ($rawItems === []) {
            return $this->failValidationErrors('Le panier est vide');
        }

        $normalizedItems = $this->normalizeItems($rawItems);
        if ($normalizedItems['error'] !== null) {
            return $this->failValidationErrors($normalizedItems['error']);
        }

        // Creation de commande, lignes, decrementation de stock et vidage du
        // panier doivent rester atomiques: tout passe ou tout est annule.
        $db = db_connect();
        $db->transBegin();

        // FOR UPDATE verrouille les produits selectionnes pendant la transaction.
        // Cela evite que deux commandes simultanees consomment le meme stock.
        $produitsById = $this->loadProductsForUpdate(array_keys($normalizedItems['items']), $db);

        foreach ($normalizedItems['items'] as $idProduit => $quantite) {
            if (! isset($produitsById[$idProduit])) {
                $db->transRollback();

                return $this->failNotFound('Produit introuvable : ' . $idProduit);
            }

            $stockDisponible = (int) ($produitsById[$idProduit]['stock'] ?? 0);
            if ($stockDisponible < $quantite) {
                $db->transRollback();

                return $this->failValidationErrors('Stock insuffisant pour le produit ' . $produitsById[$idProduit]['nom']);
            }
        }

        $commandeModel = new CommandeModel();
        $inserted = $commandeModel->insert([
            'date_commande' => date('Y-m-d H:i:s'),
            'quantite' => array_sum($normalizedItems['items']),
            'id_utilisateur' => $userId,
        ]);

        if (! $inserted) {
            $db->transRollback();

            return $this->failValidationErrors($commandeModel->errors());
        }

        $idCommande = (int) $commandeModel->getInsertID();

        foreach ($normalizedItems['items'] as $idProduit => $quantite) {
            $db->table('appartenir')->insert([
                'id_produit' => $idProduit,
                'id_commande' => $idCommande,
                'quantite' => $quantite,
            ]);

            // Mise a jour relative plutot qu'une valeur calculee en PHP:
            // la base applique la soustraction sur la version verrouillee.
            $db->table('produit')
                ->set('stock', 'stock - ' . $quantite, false)
                ->where('id_produit', $idProduit)
                ->update();
        }

        $db->table('panier_item')
            ->where('id_utilisateur', $userId)
            ->delete();

        if (! $db->transStatus()) {
            $db->transRollback();

            return $this->failServerError('Impossible de creer la commande');
        }

        $db->transCommit();

        return $this->respondCreated([
            'message' => 'Commande creee',
            'id_commande' => $idCommande,
        ]);
    }

    private function getAuthenticatedUserId(): ?int
    {
        return JwtSupport::getUserId($this->request);
    }

    /**
     * @return list<array<string, mixed>>
     */
    private function resolveRawItems(int $userId): array
    {
        $data = $this->request->getJSON(true) ?? [];

        // L'app peut envoyer explicitement des items, mais le flux normal
        // consiste a valider le panier persiste cote API.
        if (is_array($data) && ! empty($data['items']) && is_array($data['items'])) {
            return $data['items'];
        }

        $panierModel = new PanierItemModel();

        return $panierModel
            ->select('id_produit, quantite')
            ->where('id_utilisateur', $userId)
            ->findAll();
    }

    /**
     * @param list<array<string, mixed>> $rawItems
     * @return array{error: null|string, items: array<string, int>}
     */
    private function normalizeItems(array $rawItems): array
    {
        $normalized = [];

        foreach ($rawItems as $item) {
            $idProduit = trim((string) ($item['id_produit'] ?? ''));
            $quantite = (int) ($item['quantite'] ?? 0);

            if ($idProduit === '' || $quantite < 1) {
                return [
                    'error' => 'Chaque ligne doit contenir id_produit et quantite',
                    'items' => [],
                ];
            }

            // Si le meme produit apparait plusieurs fois, on fusionne les lignes
            // avant de verifier le stock et d'ecrire la commande.
            $normalized[$idProduit] = ($normalized[$idProduit] ?? 0) + $quantite;
        }

        return [
            'error' => null,
            'items' => $normalized,
        ];
    }

    /**
     * @param list<string> $productIds
     * @return array<string, array<string, mixed>>
     */
    private function loadProductsForUpdate(array $productIds, $db): array
    {
        if ($productIds === []) {
            return [];
        }

        // Requete manuelle necessaire: Query Builder CI4 ne fournit pas de
        // methode portable claire pour ajouter FOR UPDATE ici.
        $placeholders = implode(',', array_fill(0, count($productIds), '?'));
        $rows = $db->query(
            'SELECT id_produit, nom, stock
             FROM produit
             WHERE id_produit IN (' . $placeholders . ')
             FOR UPDATE',
            $productIds
        )->getResultArray();

        $produitsById = [];

        foreach ($rows as $row) {
            $produitsById[(string) $row['id_produit']] = $row;
        }

        return $produitsById;
    }
}
