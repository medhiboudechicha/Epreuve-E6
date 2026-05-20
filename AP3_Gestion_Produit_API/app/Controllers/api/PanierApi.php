<?php

namespace App\Controllers\Api;

use App\Models\PanierItemModel;
use App\Models\ProduitModel;
use App\Support\JwtSupport;
use CodeIgniter\RESTful\ResourceController;

class PanierApi extends ResourceController
{
    protected $format = 'json';

    public function index()
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        return $this->respond($this->buildCartResponse($userId));
    }

    public function add()
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        // Quantite par defaut a 1 pour simplifier l'appel depuis la fiche produit.
        $data = $this->request->getJSON(true) ?? [];
        $idProduit = trim((string) ($data['id_produit'] ?? ''));
        $quantiteAjout = max(1, (int) ($data['quantite'] ?? 1));

        if ($idProduit === '') {
            return $this->failValidationErrors('id_produit requis');
        }

        $produitModel = new ProduitModel();
        $produit = $produitModel->find($idProduit);
        if (! $produit) {
            return $this->failNotFound('Produit introuvable');
        }

        $panierModel = new PanierItemModel();
        $panierItem = $panierModel
            ->where('id_utilisateur', $userId)
            ->where('id_produit', $idProduit)
            ->first();

        $nouvelleQuantite = $quantiteAjout;
        if ($panierItem) {
            $nouvelleQuantite += (int) ($panierItem['quantite'] ?? 0);
        }

        // Le panier ne reserve pas le stock. Cette verification sert a eviter
        // les paniers manifestement impossibles; la commande reverifie ensuite.
        $stockDisponible = (int) ($produit['stock'] ?? 0);
        if ($nouvelleQuantite > $stockDisponible) {
            return $this->failValidationErrors('Stock insuffisant pour ce produit');
        }

        if ($panierItem) {
            $panierModel->update($panierItem['id_panier_item'], [
                'quantite' => $nouvelleQuantite,
            ]);
        } else {
            $panierModel->insert([
                'id_utilisateur' => $userId,
                'id_produit'     => $idProduit,
                'quantite'       => $nouvelleQuantite,
            ]);
        }

        return $this->respond(array_merge([
            'message' => 'Produit ajoute au panier',
        ], $this->buildCartResponse($userId)));
    }

    public function update($id = null)
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        $data = $this->request->getJSON(true) ?? [];
        $idProduit = trim((string) ($data['id_produit'] ?? ''));
        $quantite = (int) ($data['quantite'] ?? 0);

        if ($idProduit === '' || $quantite < 1) {
            return $this->failValidationErrors('id_produit et quantite >= 1 requis');
        }

        $produitModel = new ProduitModel();
        $produit = $produitModel->find($idProduit);
        if (! $produit) {
            return $this->failNotFound('Produit introuvable');
        }

        $stockDisponible = (int) ($produit['stock'] ?? 0);
        if ($quantite > $stockDisponible) {
            return $this->failValidationErrors('Stock insuffisant pour ce produit');
        }

        $panierModel = new PanierItemModel();
        $panierItem = $panierModel
            ->where('id_utilisateur', $userId)
            ->where('id_produit', $idProduit)
            ->first();

        if (! $panierItem) {
            return $this->failNotFound('Article absent du panier');
        }

        $panierModel->update($panierItem['id_panier_item'], [
            'quantite' => $quantite,
        ]);

        return $this->respond(array_merge([
            'message' => 'Panier mis a jour',
        ], $this->buildCartResponse($userId)));
    }

    public function remove()
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        $data = $this->request->getJSON(true) ?? [];
        $idProduit = trim((string) ($data['id_produit'] ?? ''));

        if ($idProduit === '') {
            return $this->failValidationErrors('id_produit requis');
        }

        // Suppression idempotente: supprimer un article deja absent ne casse pas
        // le flux mobile, on renvoie simplement l'etat courant du panier.
        $panierModel = new PanierItemModel();
        $panierModel
            ->where('id_utilisateur', $userId)
            ->where('id_produit', $idProduit)
            ->delete();

        return $this->respond(array_merge([
            'message' => 'Article supprime du panier',
        ], $this->buildCartResponse($userId)));
    }

    public function clear()
    {
        $userId = $this->getAuthenticatedUserId();
        if ($userId === null) {
            return $this->failUnauthorized('Token invalide');
        }

        $panierModel = new PanierItemModel();
        $panierModel->where('id_utilisateur', $userId)->delete();

        return $this->respond([
            'message' => 'Panier vide',
            'items' => [],
            'total_montant' => 0.0,
            'total_quantite' => 0,
        ]);
    }

    private function buildCartResponse(int $userId): array
    {
        // Toutes les mutations renvoient le panier complet pour que l'app puisse
        // rafraichir l'UI sans refaire un second appel GET.
        $db = db_connect();
        $builder = $db->table('panier_item p');
        $builder->select('p.id_produit, Produit.nom, Produit.description, Produit.prix, Produit.image, p.quantite, p.quantite * CAST(Produit.prix AS DECIMAL(10,2)) AS sous_total');
        $builder->join('Produit', 'Produit.id_produit = p.id_produit', 'inner');
        $builder->where('p.id_utilisateur', $userId);
        $builder->orderBy('p.updated_at', 'DESC');

        $items = $builder->get()->getResultArray();
        $totalMontant = 0.0;
        $totalQuantite = 0;

        foreach ($items as &$item) {
            $item['prix'] = (float) ($item['prix'] ?? 0);
            $item['quantite'] = (int) ($item['quantite'] ?? 0);
            $item['sous_total'] = (float) ($item['sous_total'] ?? 0);
            $totalMontant += $item['sous_total'];
            $totalQuantite += $item['quantite'];
        }

        return [
            'items' => $items,
            'total_montant' => $totalMontant,
            'total_quantite' => $totalQuantite,
        ];
    }

    private function getAuthenticatedUserId(): ?int
    {
        return JwtSupport::getUserId($this->request);
    }
}
