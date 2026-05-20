<?php

namespace App\Controllers;

use App\Models\PanierItemModel;
use App\Models\ProduitModel;
use App\Models\UserModel;
use App\Support\PasswordSupport;

class Auth extends BaseController
{
    public function login()
    {
        $data['title'] = 'Connexion';
        return view('auth/login', $data);
    }

    public function doLogin()
    {
        helper(['form']);

        $email    = $this->request->getPost('email');
        $password = $this->request->getPost('mot_de_passe');

        $userModel = new UserModel();
        $user = $userModel->getByEmail($email);

        if (! $user) {
            return redirect()->back()
                ->with('error', 'Identifiants incorrects.')
                ->withInput();
        }

        $storedPassword = (string) ($user['mot_de_passe'] ?? '');
        $passwordOk = PasswordSupport::verify($password, $storedPassword);

        if (! $passwordOk) {
            return redirect()->back()
                ->with('error', 'Identifiants incorrects.')
                ->withInput();
        }

        if (PasswordSupport::needsUpgrade($storedPassword)) {
            $userModel->update($user['id_utilisateur'], [
                'mot_de_passe' => PasswordSupport::hash($password),
            ]);
        }

        $sessionData = [
            'user_id'     => $user['id_utilisateur'],
            'user_nom'    => $user['nom'],
            'user_prenom' => $user['prenom'],
            'user_role'   => $user['role'],
            'is_logged'   => true,
        ];

        session()->set($sessionData);
        $this->mergeSessionCartIntoDatabase((int) $user['id_utilisateur']);

        return redirect()->to('/');
    }

    public function logout()
    {
        session()->destroy();
        return redirect()->to('/');
    }

    public function register()
    {
        $data['title'] = 'Inscription';
        return view('auth/register', $data);
    }

    public function doRegister()
    {
        helper(['form']);

        $rules = [
            'nom'                   => 'required',
            'prenom'                => 'required',
            'email'                 => 'required|valid_email|is_unique[Utilisateur.email]',
            'mot_de_passe'          => 'required|min_length[6]',
            'mot_de_passe_confirm'  => 'required|matches[mot_de_passe]',
        ];

        if (! $this->validate($rules)) {
            return redirect()->back()
                ->with('errors', $this->validator->getErrors())
                ->withInput();
        }

        $userModel = new UserModel();

        $data = [
            'nom'          => $this->request->getPost('nom'),
            'prenom'       => $this->request->getPost('prenom'),
            'email'        => $this->request->getPost('email'),
            'mot_de_passe' => password_hash($this->request->getPost('mot_de_passe'), PASSWORD_DEFAULT),
            'role'         => 'utilisateur',
        ];

        $userModel->insert($data);

        $newUserId = $userModel->getInsertID();
        $user      = $userModel->find($newUserId);

        $sessionData = [
            'user_id'     => $user['id_utilisateur'],
            'user_nom'    => $user['nom'],
            'user_prenom' => $user['prenom'],
            'user_role'   => $user['role'],
            'is_logged'   => true,
        ];
        session()->set($sessionData);
        $this->mergeSessionCartIntoDatabase((int) $user['id_utilisateur']);

        return redirect()->to('/');
    }

    private function mergeSessionCartIntoDatabase(int $userId): void
    {
        $sessionCart = session()->get('cart') ?? [];
        if (empty($sessionCart)) {
            return;
        }

        $panierModel = new PanierItemModel();
        $produitModel = new ProduitModel();

        foreach ($sessionCart as $item) {
            $idProduit = trim((string) ($item['id_produit'] ?? ''));
            $quantite = max(1, (int) ($item['quantite'] ?? 1));

            if ($idProduit === '') {
                continue;
            }

            $produit = $produitModel->getOne($idProduit);
            if (! $produit) {
                continue;
            }

            $existingItem = $panierModel
                ->where('id_utilisateur', $userId)
                ->where('id_produit', $idProduit)
                ->first();

            $nouvelleQuantite = $quantite;
            if ($existingItem) {
                $nouvelleQuantite += (int) ($existingItem['quantite'] ?? 0);
            }

            $stockDisponible = (int) ($produit['stock'] ?? 0);
            $nouvelleQuantite = min($nouvelleQuantite, $stockDisponible);

            if ($nouvelleQuantite < 1) {
                continue;
            }

            if ($existingItem) {
                $panierModel->update($existingItem['id_panier_item'], [
                    'quantite' => $nouvelleQuantite,
                ]);
            } else {
                $panierModel->insert([
                    'id_utilisateur' => $userId,
                    'id_produit'     => $idProduit,
                    'quantite'       => $nouvelleQuantite,
                ]);
            }
        }

        session()->remove('cart');
    }
}
