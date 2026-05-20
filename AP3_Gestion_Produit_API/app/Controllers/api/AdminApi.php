<?php

namespace App\Controllers\Api;

use App\Support\JwtSupport;
use CodeIgniter\RESTful\ResourceController;

class AdminApi extends ResourceController
{
    protected $format = 'json';

    public function index()
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        // Vue admin globale: contrairement a CommandesApi, on ne filtre pas sur
        // l'utilisateur courant afin de voir toutes les commandes.
        $db = db_connect();
        $builder = $db->table('commande c');
        $builder->select('
            c.id_commande,
            c.date_commande,
            c.quantite,
            u.id_utilisateur,
            u.nom,
            u.prenom,
            u.email,
            COALESCE(SUM(a.quantite * CAST(p.prix AS DECIMAL(10,2))), 0) AS total_montant
        ');
        $builder->join('utilisateur u', 'u.id_utilisateur = c.id_utilisateur', 'left');
        $builder->join('appartenir a', 'a.id_commande = c.id_commande', 'left');
        $builder->join('Produit p', 'p.id_produit = a.id_produit', 'left');
        $builder->groupBy('c.id_commande, c.date_commande, c.quantite, u.id_utilisateur, u.nom, u.prenom, u.email');
        $builder->orderBy('c.date_commande', 'DESC');

        $commandes = $builder->get()->getResultArray();

        foreach ($commandes as &$commande) {
            $commande['id_commande'] = (int) ($commande['id_commande'] ?? 0);
            $commande['quantite'] = (int) ($commande['quantite'] ?? 0);
            $commande['id_utilisateur'] = (int) ($commande['id_utilisateur'] ?? 0);
            $commande['total_montant'] = (float) ($commande['total_montant'] ?? 0);
        }

        return $this->respond($commandes);
    }

    public function showCommande($id = null)
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        $db = db_connect();
        $commande = $db->table('commande c')
            ->select('c.id_commande, c.date_commande, c.quantite, u.nom, u.prenom, u.email')
            ->join('utilisateur u', 'u.id_utilisateur = c.id_utilisateur', 'left')
            ->where('c.id_commande', $id)
            ->get()
            ->getRowArray();

        if (! $commande) {
            return $this->failNotFound('Commande introuvable');
        }

        $lignes = $db->table('appartenir')
            ->select('Produit.id_produit, Produit.nom, Produit.description, Produit.prix, Produit.image, appartenir.quantite, appartenir.quantite * CAST(Produit.prix AS DECIMAL(10,2)) AS sous_total')
            ->join('Produit', 'Produit.id_produit = appartenir.id_produit', 'left')
            ->where('appartenir.id_commande', $id)
            ->get()
            ->getResultArray();

        $totalMontant = 0;
        foreach ($lignes as &$ligne) {
            $ligne['prix'] = (float) ($ligne['prix'] ?? 0);
            $ligne['quantite'] = (int) ($ligne['quantite'] ?? 0);
            $ligne['sous_total'] = (float) ($ligne['sous_total'] ?? 0);
            $totalMontant += $ligne['sous_total'];
        }

        $commande['id_commande'] = (int) ($commande['id_commande'] ?? 0);
        $commande['quantite'] = (int) ($commande['quantite'] ?? 0);
        $commande['total_montant'] = $totalMontant;
        $commande['lignes'] = $lignes;

        return $this->respond($commande);
    }

    public function deleteCommande($id = null)
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        $db = db_connect();
        $commande = $db->table('commande')
            ->where('id_commande', $id)
            ->get()
            ->getRowArray();

        if (! $commande) {
            return $this->failNotFound('Commande introuvable');
        }

        // Ici "supprimer" correspond a une annulation metier: les stocks des
        // lignes doivent etre remis avant de supprimer la commande.
        $db->transBegin();

        $lignes = $db->table('appartenir')
            ->select('id_produit, quantite')
            ->where('id_commande', $id)
            ->get()
            ->getResultArray();

        foreach ($lignes as $ligne) {
            $quantite = (int) ($ligne['quantite'] ?? 0);
            if ($quantite < 1) {
                continue;
            }

            // La remise en stock reste dans la meme transaction que la suppression
            // des lignes, sinon le catalogue pourrait diverger en cas d'erreur.
            $db->table('produit')
                ->set('stock', 'stock + ' . $quantite, false)
                ->where('id_produit', (string) $ligne['id_produit'])
                ->update();
        }

        $db->table('appartenir')->where('id_commande', $id)->delete();
        $db->table('commande')->where('id_commande', $id)->delete();

        if (! $db->transStatus()) {
            $db->transRollback();

            return $this->failServerError('Erreur lors de la suppression');
        }

        $db->transCommit();

        return $this->respondDeleted([
            'message' => 'Commande annulee et stock restaure',
        ]);
    }

    public function utilisateurs()
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        $db = db_connect();
        $users = $db->table('utilisateur')
            ->select('id_utilisateur, nom, prenom, email, role')
            ->orderBy('id_utilisateur', 'ASC')
            ->get()
            ->getResultArray();

        foreach ($users as &$user) {
            $user['id_utilisateur'] = (int) ($user['id_utilisateur'] ?? 0);
        }

        return $this->respond($users);
    }

    public function stats()
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        // Ces compteurs alimentent le tableau de bord Android admin.
        // Le chiffre d'affaires est calcule sur les lignes restantes.
        $db = db_connect();
        $nbProduits = (int) $db->table('Produit')->countAll();
        $nbCommandes = (int) $db->table('commande')->countAll();
        $nbUtilisateurs = (int) $db->table('utilisateur')->countAll();

        $result = $db->table('appartenir a')
            ->select('COALESCE(SUM(a.quantite * CAST(p.prix AS DECIMAL(10,2))), 0) AS ca')
            ->join('Produit p', 'p.id_produit = a.id_produit', 'left')
            ->get()
            ->getRowArray();

        $totalCA = (float) ($result['ca'] ?? 0);

        return $this->respond([
            'nb_produits' => $nbProduits,
            'nb_commandes' => $nbCommandes,
            'nb_utilisateurs' => $nbUtilisateurs,
            'chiffre_affaires' => $totalCA,
        ]);
    }

    private function isAdmin(): bool
    {
        // Centralise la logique admin/superadmin pour eviter les divergences
        // entre les endpoints admin.
        return JwtSupport::isAdminRequest($this->request);
    }
}
