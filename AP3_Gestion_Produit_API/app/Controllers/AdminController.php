<?php

namespace App\Controllers;

use App\Models\UserModel;

class AdminController extends BaseController
{
    public function users()
    {
        // Protection : connecté ?
        if (! session()->get('is_logged')) {
            return redirect()->to('/login')->with('error', 'Vous devez être connecté.');
        }

        // Protection : admin ?
        if (session()->get('user_role') !== 'admin') {
            return redirect()->to('/')->with('error', 'Accès refusé : réservé aux administrateurs.');
        }

        $userModel = new UserModel();
        $data['utilisateurs'] = $userModel->findAll();
        $data['title'] = 'Gestion des utilisateurs';

        return view('admin/users', $data);
    }
}
