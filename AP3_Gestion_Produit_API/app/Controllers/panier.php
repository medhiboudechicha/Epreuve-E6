<?php

namespace App\Controllers;

use App\Models\AppartenirModel;
use App\Models\CommandeModel;
use App\Models\PanierItemModel;
use App\Models\ProduitModel;

class Panier extends BaseController
{
    public function index()
    {
        $cart = $this->getCartItems();
        [$total, $totalQuantite] = $this->calculateTotals($cart);

        $data['title']         = 'Panier';
        $data['cart']          = $cart;
        $data['total']         = $total;
        $data['totalQuantite'] = $totalQuantite;

        return view('panier/index', $data);
    }

    public function add($id)
    {
        $productModel = new ProduitModel();
        $produit = $productModel->getOne($id);

        if (! $produit || empty($produit['id_produit'])) {
            return redirect()->back()->with('error', 'Produit introuvable.');
        }

        if ($this->isLoggedIn()) {
            $result = $this->addToDatabaseCart((int) session()->get('user_id'), $produit, 1);

            if (! $result['ok']) {
                return redirect()->back()->with('error', $result['message']);
            }

            return redirect()->back()->with('success', 'Produit ajoute au panier.');
        }

        $cart = session()->get('cart') ?? [];

        if (isset($cart[$id])) {
            $cart[$id]['quantite']++;
        } else {
            $cart[$id] = [
                'id_produit' => $produit['id_produit'],
                'nom'        => $produit['nom'],
                'prix'       => (float) $produit['prix'],
                'image'      => $produit['image'] ?? 'no_image.jpg',
                'quantite'   => 1,
            ];
        }

        session()->set('cart', $cart);

        return redirect()->back()->with('success', 'Produit ajoute au panier.');
    }

    public function remove($id)
    {
        if ($this->isLoggedIn()) {
            $panierModel = new PanierItemModel();
            $panierModel
                ->where('id_utilisateur', (int) session()->get('user_id'))
                ->where('id_produit', $id)
                ->delete();

            return redirect()->to('panier')->with('success', 'Produit retire du panier.');
        }

        $cart = session()->get('cart') ?? [];

        if (isset($cart[$id])) {
            unset($cart[$id]);
            session()->set('cart', $cart);
        }

        return redirect()->to('panier')->with('success', 'Produit retire du panier.');
    }

    public function clear()
    {
        if ($this->isLoggedIn()) {
            $panierModel = new PanierItemModel();
            $panierModel->where('id_utilisateur', (int) session()->get('user_id'))->delete();

            return redirect()->to('panier')->with('success', 'Panier vide.');
        }

        session()->remove('cart');
        return redirect()->to('panier')->with('success', 'Panier vide.');
    }

    public function valider()
    {
        if (! $this->isLoggedIn()) {
            return redirect()->to('login')->with('error', 'Vous devez etre connecte pour valider une commande.');
        }

        $cart = $this->getCartItems();

        if (empty($cart)) {
            return redirect()->to('panier')->with('error', 'Votre panier est vide.');
        }

        $userId = (int) session()->get('user_id');
        $totalQuantite = 0;
        foreach ($cart as $item) {
            $totalQuantite += (int) $item['quantite'];
        }

        $commandeModel   = new CommandeModel();
        $appartenirModel = new AppartenirModel();
        $produitModel    = new ProduitModel();
        $panierModel     = new PanierItemModel();
        $db              = db_connect();

        $db->transStart();

        $commandeModel->insert([
            'date_commande'  => date('Y-m-d H:i:s'),
            'quantite'       => $totalQuantite,
            'id_utilisateur' => $userId,
        ]);

        $idCommande = (int) $commandeModel->getInsertID();

        foreach ($cart as $item) {
            $idProduit = (string) $item['id_produit'];
            $quantite  = (int) $item['quantite'];

            $produit = $produitModel->getOne($idProduit);
            if (! $produit) {
                $db->transRollback();
                return redirect()->to('panier')->with('error', 'Produit introuvable pendant la validation.');
            }

            $stockActuel = (int) ($produit['stock'] ?? 0);
            if ($quantite > $stockActuel) {
                $db->transRollback();
                return redirect()->to('panier')->with('error', 'Stock insuffisant pour ' . $produit['nom'] . '.');
            }

            $appartenirModel->insert([
                'id_produit'  => $idProduit,
                'id_commande' => $idCommande,
                'quantite'    => $quantite,
            ]);

            $produitModel->update($idProduit, [
                'stock' => max(0, $stockActuel - $quantite),
            ]);
        }

        $panierModel->where('id_utilisateur', $userId)->delete();
        session()->remove('cart');

        $db->transComplete();

        if (! $db->transStatus()) {
            return redirect()->to('panier')->with('error', 'Impossible de confirmer la commande.');
        }

        return redirect()->to('mes-commandes')->with('success', 'Commande confirmee.');
    }

    private function isLoggedIn(): bool
    {
        return (bool) session()->get('is_logged');
    }

    private function getCartItems(): array
    {
        if (! $this->isLoggedIn()) {
            return array_values(session()->get('cart') ?? []);
        }

        return $this->getDatabaseCart((int) session()->get('user_id'));
    }

    private function getDatabaseCart(int $userId): array
    {
        $db = db_connect();
        $builder = $db->table('panier_item p');
        $builder->select('p.id_produit, Produit.nom, Produit.prix, Produit.image, p.quantite');
        $builder->join('Produit', 'Produit.id_produit = p.id_produit', 'inner');
        $builder->where('p.id_utilisateur', $userId);
        $builder->orderBy('p.updated_at', 'DESC');

        $rows = $builder->get()->getResultArray();

        foreach ($rows as &$row) {
            $row['prix'] = (float) ($row['prix'] ?? 0);
            $row['quantite'] = (int) ($row['quantite'] ?? 0);
            $row['image'] = $row['image'] ?? 'no_image.jpg';
        }

        return $rows;
    }

    private function calculateTotals(array $cart): array
    {
        $total = 0.0;
        $totalQuantite = 0;

        foreach ($cart as $item) {
            $prix = (float) ($item['prix'] ?? 0);
            $quantite = (int) ($item['quantite'] ?? 0);
            $total += $prix * $quantite;
            $totalQuantite += $quantite;
        }

        return [$total, $totalQuantite];
    }

    private function addToDatabaseCart(int $userId, array $produit, int $quantiteAjout): array
    {
        $panierModel = new PanierItemModel();
        $existingItem = $panierModel
            ->where('id_utilisateur', $userId)
            ->where('id_produit', $produit['id_produit'])
            ->first();

        $nouvelleQuantite = $quantiteAjout;
        if ($existingItem) {
            $nouvelleQuantite += (int) ($existingItem['quantite'] ?? 0);
        }

        $stockDisponible = (int) ($produit['stock'] ?? 0);
        if ($nouvelleQuantite > $stockDisponible) {
            return [
                'ok' => false,
                'message' => 'Stock insuffisant pour ce produit.',
            ];
        }

        if ($existingItem) {
            $panierModel->update($existingItem['id_panier_item'], [
                'quantite' => $nouvelleQuantite,
            ]);
        } else {
            $panierModel->insert([
                'id_utilisateur' => $userId,
                'id_produit'     => $produit['id_produit'],
                'quantite'       => $nouvelleQuantite,
            ]);
        }

        return ['ok' => true, 'message' => 'ok'];
    }
}
