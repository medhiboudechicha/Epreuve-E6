<?php

namespace App\Models;

use CodeIgniter\Model;

class UserModel extends Model
{
    protected $table      = 'utilisateur';
    protected $primaryKey = 'id_utilisateur';

    protected $allowedFields = [
        'nom',
        'prenom',
        'email',
        'mot_de_passe',
        'role'
    ];

    public function getByEmail(string $email)
    {
        return $this->where('email', $email)->first();
    }
}
