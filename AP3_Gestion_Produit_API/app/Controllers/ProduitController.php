<?php

namespace App\Controllers;

use App\Models\ProduitModel;

class ProduitController extends BaseController
{
    // Liste publique des produits
    public function index()
    {
        $model = new ProduitModel();
        $data['produits'] = $model->getAll();
        $data['title'] = 'Produits';

        return view('produits/index', $data);
    }

    // Vérifie si l'utilisateur est admin
    private function requireAdmin()
    {
        if (! session()->get('is_logged')) {
            return redirect()->to('/login')->with('error', 'Vous devez être connecté.');
        }

        if (session()->get('user_role') !== 'admin') {
            return redirect()->to('/')->with('error', 'Accès refusé : réservé aux administrateurs.');
        }

        return null;
    }

    // Formulaire d'ajout
    public function create()
    {
        if ($redirect = $this->requireAdmin()) {
            return $redirect;
        }

        $data['title'] = 'Ajouter un produit';
        return view('produits/create', $data);
    }

    // Enregistrement d'un nouveau produit
    public function store()
    {
        if ($redirect = $this->requireAdmin()) {
            return $redirect;
        }

        helper(['form']);

        $model = new ProduitModel();

        $file = $this->request->getFile('image');
        $imageName = 'no_image.jpg';

        if ($file && $file->isValid() && !$file->hasMoved()) {
            $imageName = $file->getRandomName();
            $file->move('uploads', $imageName);
        }

        $data = [
            'id_produit'  => uniqid('P'),
            'nom'         => $this->request->getPost('nom'),
            'description' => $this->request->getPost('description'),
            'prix'        => $this->request->getPost('prix'),
            'stock'       => $this->request->getPost('stock'),
            'image'       => $imageName,
        ];

        $model->insert($data);

        return redirect()->to('/produits')->with('success', 'Produit ajouté.');
    }

    // Formulaire d'édition
    public function edit($id)
    {
        if ($redirect = $this->requireAdmin()) {
            return $redirect;
        }

        $model = new ProduitModel();
        $produit = $model->getOne($id);

        if (! $produit) {
            return redirect()->to('/produits')->with('error', 'Produit introuvable.');
        }

        $data['produit'] = $produit;
        $data['title'] = 'Modifier un produit';

        return view('produits/edit', $data);
    }

    // Mise à jour d'un produit
    public function update($id)
    {
        if ($redirect = $this->requireAdmin()) {
            return $redirect;
        }

        helper(['form']);

        $model = new ProduitModel();
        $produit = $model->getOne($id);

        if (! $produit) {
            return redirect()->to('/produits')->with('error', 'Produit introuvable.');
        }

        $file = $this->request->getFile('image');
        $imageName = $produit['image'] ?? 'no_image.png';

        if ($file && $file->isValid() && !$file->hasMoved()) {
            if (!empty($produit['image']) && $produit['image'] !== 'no_image.jpg' && file_exists('uploads/' . $produit['image'])) {
                unlink('uploads/' . $produit['image']);
            }

            $imageName = $file->getRandomName();
            $file->move('uploads', $imageName);
        }

        $data = [
            'nom'         => $this->request->getPost('nom'),
            'description' => $this->request->getPost('description'),
            'prix'        => $this->request->getPost('prix'),
            'stock'       => $this->request->getPost('stock'),
            'image'       => $imageName,
        ];

        $model->update($id, $data);

        return redirect()->to('/produits')->with('success', 'Produit mis à jour.');
    }

    // Suppression d'un produit
    public function delete($id)
    {
        if ($redirect = $this->requireAdmin()) {
            return $redirect;
        }

        $model = new ProduitModel();
        $produit = $model->getOne($id);

        if ($produit) {
            if (!empty($produit['image']) && $produit['image'] !== 'no_image.jpg' && file_exists('uploads/' . $produit['image'])) {
                unlink('uploads/' . $produit['image']);
            }

            $model->delete($id);
        }

        return redirect()->to('/produits')->with('success', 'Produit supprimé.');
    }
    
    // Affichage du détail d'un produit
    public function show($id)
    {
        $model = new ProduitModel();
        $produit = $model->getOne($id);

        if (! $produit) {
            return redirect()->to('produits')->with('error', 'Produit introuvable.');
        }

        $data['title']   = 'Détail du produit';
        $data['produit'] = $produit;

        return view('produits/show', $data);
    }

}
