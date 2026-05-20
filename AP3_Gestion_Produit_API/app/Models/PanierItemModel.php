<?php

namespace App\Models;

use CodeIgniter\Model;

class PanierItemModel extends Model
{
    protected $table      = 'panier_item';
    protected $primaryKey = 'id_panier_item';

    protected $allowedFields = [
        'id_utilisateur',
        'id_produit',
        'quantite',
    ];

    protected $useTimestamps = true;
    protected $createdField = 'created_at';
    protected $updatedField = 'updated_at';
}
