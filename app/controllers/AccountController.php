<?php

class AccountController extends Controller
{
    public function edit()
    {
        $this->verifierConnexion();

        $model = new User($this->pdo);
        $user = $model->find($_SESSION['user']['id_utilisateur']);

        $this->view('account/edit', [
            'titre' => 'Mon compte',
            'user' => $user,
        ]);
    }

    public function save()
    {
        $this->verifierConnexion();

        $data = [
            'nom' => trim($_POST['nom'] ?? ''),
            'prenom' => trim($_POST['prenom'] ?? ''),
            'email' => trim($_POST['email'] ?? ''),
            'mot_de_passe' => $_POST['mot_de_passe'] ?? '',
        ];

        $model = new User($this->pdo);
        $model->updateAccount($_SESSION['user']['id_utilisateur'], $data);

        $_SESSION['user']['nom'] = $data['nom'];
        $_SESSION['user']['prenom'] = $data['prenom'];
        $_SESSION['user']['email'] = $data['email'];

        message('Compte modifié.');
        redirection('mon_compte');
    }
}
