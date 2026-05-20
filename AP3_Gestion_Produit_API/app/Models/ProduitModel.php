<?php

namespace App\Models;

use CodeIgniter\Model;

class ProduitModel extends Model
{
    protected $table      = 'Produit';
    protected $primaryKey = 'id_produit';

    protected $allowedFields = [
        'id_produit',
        'nom',
        'description',
        'prix',
        'stock',
        'image'
    ];

    public function getAll()
    {
        return $this->where('id_produit !=', '')->findAll();
    }

    public function getOne($id)
    {
        return $this->where('id_produit', $id)->first();
    }

    public function getForHome($limit = 10)
    {
        return $this->where('id_produit !=', '')
                    ->orderBy('id_produit', 'DESC')
                    ->limit($limit)
                    ->findAll();
    }
}
