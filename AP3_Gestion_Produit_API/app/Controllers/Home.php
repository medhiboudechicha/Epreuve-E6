<?php

namespace App\Controllers;

use App\Models\ProduitModel;

class Home extends BaseController
{
    public function index()
    {
        $produitModel = new ProduitModel();

        $data['title'] = 'Accueil';
        $data['produits'] = $produitModel->getForHome(10); // par exemple 10 produits

        return view('home/index', $data);
    }
}
