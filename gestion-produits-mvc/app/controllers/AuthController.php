<?php

class AuthController extends Controller
{
    public function login()
    {
        if ($this->userConnecte()) {
            redirection('produits');
        }

        $this->view('auth/login', ['titre' => 'Connexion']);
    }

    public function checkLogin()
    {
        $email = trim($_POST['email'] ?? '');
        $motDePasse = $_POST['mot_de_passe'] ?? '';

        $model = new User($this->pdo);
        $user = $model->findByEmail($email);

        if ($user && password_verify($motDePasse, $user['mot_de_passe'])) {
            $_SESSION['user'] = [
                'id_utilisateur' => $user['id_utilisateur'],
                'nom' => $user['nom'],
                'prenom' => $user['prenom'],
                'email' => $user['email'],
                'role' => $user['role'],
            ];

            redirection('produits');
        }

        message('Email ou mot de passe incorrect.', 'erreur');
        redirection('login');
    }

    public function logout()
    {
        session_destroy();
        redirection('login');
    }
}
