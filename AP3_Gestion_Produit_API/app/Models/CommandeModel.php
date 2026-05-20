<?php

namespace App\Models;

use CodeIgniter\Model;

class CommandeModel extends Model
{
    protected $table      = 'commande';
    protected $primaryKey = 'id_commande';

    protected $allowedFields = [
        'date_commande',
        'quantite',
        'id_utilisateur',
    ];
}
