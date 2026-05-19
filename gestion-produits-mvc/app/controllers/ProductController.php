<?php

class ProductController extends Controller
{
    public function index()
    {
        $this->verifierConnexion();

        $recherche = trim($_GET['recherche'] ?? '');
        $model = new Product($this->pdo);

        $this->view('products/index', [
            'titre' => 'Produits',
            'produits' => $model->all($recherche),
            'recherche' => $recherche,
        ]);
    }

    public function form()
    {
        $this->verifierAdmin();

        $model = new Product($this->pdo);
        $id = $_GET['id'] ?? null;

        if ($id) {
            $produit = $model->find($id);
            if (!$produit) {
                message('Produit introuvable.', 'erreur');
                redirection('produits');
            }
        } else {
            $produit = [
                'id_produit' => '',
                'nom' => '',
                'description' => '',
                'prix' => '',
                'stock' => '',
                'image' => 'no_image.jpg',
            ];
        }

        $this->view('products/form', [
            'titre' => $id ? 'Modifier produit' : 'Ajouter produit',
            'produit' => $produit,
            'id' => $id,
        ]);
    }

    public function save()
    {
        $this->verifierAdmin();

        $model = new Product($this->pdo);
        $data = [
            'id_produit' => trim($_POST['id_produit'] ?? ''),
            'nom' => trim($_POST['nom'] ?? ''),
            'description' => trim($_POST['description'] ?? ''),
            'prix' => (float) str_replace(',', '.', $_POST['prix'] ?? 0),
            'stock' => (int) ($_POST['stock'] ?? 0),
            'image' => trim($_POST['image'] ?? '') ?: 'no_image.jpg',
        ];

        try {
            if ($_POST['mode'] === 'modifier') {
                $model->update($data['id_produit'], $data);
                message('Produit modifié.');
            } else {
                $model->create($data);
                message('Produit ajouté.');
            }
        } catch (PDOException $e) {
            message('Erreur SQL : ' . $e->getMessage(), 'erreur');
            redirection('produit_form', ['id' => $data['id_produit']]);
        }

        redirection('produits');
    }

    public function delete()
    {
        $this->verifierAdmin();

        try {
            $model = new Product($this->pdo);
            $model->delete($_POST['id_produit'] ?? '');
            message('Produit supprimé.');
        } catch (PDOException $e) {
            message('Impossible de supprimer : le produit est lié à une autre table.', 'erreur');
        }

        redirection('produits');
    }
}
