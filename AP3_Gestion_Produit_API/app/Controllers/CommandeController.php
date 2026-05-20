<?php

namespace App\Controllers;

use App\Models\AppartenirModel;
use App\Models\CommandeModel;
use App\Models\UserModel;
use App\Support\JwtSupport;

class CommandeController extends BaseController
{
    public function mesCommandes()
    {
        if (! session()->get('is_logged')) {
            return redirect()->to('login')->with('error', 'Vous devez etre connecte.');
        }

        $userId = session()->get('user_id');

        $commandeModel = new CommandeModel();
        $commandes = $commandeModel
            ->where('id_utilisateur', $userId)
            ->orderBy('date_commande', 'DESC')
            ->findAll();

        $data['title'] = 'Mes commandes';
        $data['commandes'] = $commandes;

        return view('commandes/mes_commandes', $data);
    }

    public function mesCommandesDetail($id)
    {
        if (! session()->get('is_logged')) {
            return redirect()->to('login')->with('error', 'Vous devez etre connecte.');
        }

        $userId = session()->get('user_id');
        $commandeModel = new CommandeModel();

        $commande = $commandeModel
            ->where('id_commande', $id)
            ->where('id_utilisateur', $userId)
            ->first();

        if (! $commande) {
            return redirect()->to('mes-commandes')->with('error', 'Commande introuvable.');
        }

        $db = \Config\Database::connect();
        $builder = $db->table('appartenir');
        $builder->select('appartenir.*, Produit.nom, Produit.prix, Produit.image');
        $builder->join('Produit', 'Produit.id_produit = appartenir.id_produit', 'left');
        $builder->where('id_commande', $id);

        $lignes = $builder->get()->getResultArray();

        $total = 0;
        foreach ($lignes as $ligne) {
            $total += (float) $ligne['prix'] * (int) ($ligne['quantite'] ?? 1);
        }

        $data['title'] = 'Detail de la commande';
        $data['commande'] = $commande;
        $data['lignes'] = $lignes;
        $data['total'] = $total;

        return view('commandes/mes_commandes_detail', $data);
    }

    public function deleteUser($id)
    {
        if (! session()->get('is_logged')) {
            return redirect()->to('login')->with('error', 'Vous devez etre connecte.');
        }

        $userId = session()->get('user_id');
        $commandeModel = new CommandeModel();
        $appModel = new AppartenirModel();

        $commande = $commandeModel
            ->where('id_commande', $id)
            ->where('id_utilisateur', $userId)
            ->first();

        if (! $commande) {
            return redirect()->to('mes-commandes')->with('error', 'Commande introuvable.');
        }

        $db = \Config\Database::connect();
        $db->transStart();
        $appModel->where('id_commande', $id)->delete();
        $commandeModel->delete($id);
        $db->transComplete();

        return redirect()->to('mes-commandes')->with('success', 'Commande supprimee.');
    }

    public function adminIndex()
    {
        if (! $this->hasPrivilegedSession()) {
            return redirect()->to('/')->with('error', 'Acces reserve aux administrateurs.');
        }

        $commandeModel = new CommandeModel();
        $userModel = new UserModel();

        $commandes = $commandeModel
            ->orderBy('date_commande', 'DESC')
            ->findAll();

        foreach ($commandes as &$commande) {
            $user = $userModel->find($commande['id_utilisateur']);
            $commande['nom_utilisateur'] = $user ? ($user['prenom'] . ' ' . $user['nom']) : 'Utilisateur supprime';
        }

        $data['title'] = 'Toutes les commandes';
        $data['commandes'] = $commandes;

        return view('commandes/admin_index', $data);
    }

    public function adminDetail($id)
    {
        if (! $this->hasPrivilegedSession()) {
            return redirect()->to('/')->with('error', 'Acces reserve aux administrateurs.');
        }

        $commandeModel = new CommandeModel();
        $userModel = new UserModel();

        $commande = $commandeModel->find($id);
        if (! $commande) {
            return redirect()->to('admin/commandes')->with('error', 'Commande introuvable.');
        }

        $user = $userModel->find($commande['id_utilisateur']);
        $commande['nom_utilisateur'] = $user ? ($user['prenom'] . ' ' . $user['nom']) : 'Utilisateur supprime';

        $db = \Config\Database::connect();
        $builder = $db->table('appartenir');
        $builder->select('appartenir.*, Produit.nom, Produit.prix, Produit.image');
        $builder->join('Produit', 'Produit.id_produit = appartenir.id_produit', 'left');
        $builder->where('id_commande', $id);

        $lignes = $builder->get()->getResultArray();

        $total = 0;
        foreach ($lignes as $ligne) {
            $total += (float) $ligne['prix'] * (int) ($ligne['quantite'] ?? 1);
        }

        $data['title'] = 'Detail de la commande';
        $data['commande'] = $commande;
        $data['lignes'] = $lignes;
        $data['total'] = $total;

        return view('commandes/admin_detail', $data);
    }

    public function deleteAdmin($id)
    {
        if (! $this->hasPrivilegedSession()) {
            return redirect()->to('/')->with('error', 'Acces reserve aux administrateurs.');
        }

        $commandeModel = new CommandeModel();
        $appModel = new AppartenirModel();

        $commande = $commandeModel->find($id);
        if (! $commande) {
            return redirect()->to('admin/commandes')->with('error', 'Commande introuvable.');
        }

        $db = \Config\Database::connect();
        $db->transStart();

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

            $db->table('produit')
                ->set('stock', 'stock + ' . $quantite, false)
                ->where('id_produit', (string) $ligne['id_produit'])
                ->update();
        }

        $appModel->where('id_commande', $id)->delete();
        $commandeModel->delete($id);

        $db->transComplete();

        return redirect()->to('admin/commandes')->with('success', 'Commande annulee et stock restaure.');
    }

    private function hasPrivilegedSession(): bool
    {
        if (! session()->get('is_logged')) {
            return false;
        }

        return JwtSupport::isPrivilegedRole((string) session()->get('user_role'));
    }
}
