<?php

namespace App\Models;

use CodeIgniter\Model;

class AppartenirModel extends Model
{
    protected $table      = 'appartenir';   // nom EXACT dans ta base
    protected $primaryKey = 'id_produit';   // CI a besoin d’une PK (même si en BDD c’est composite)

    protected $allowedFields = [
        'id_produit',
        'id_commande',
        'quantite',
    ];

    protected $useAutoIncrement = false;
}
