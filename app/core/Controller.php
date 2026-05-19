<?php

class Controller
{
    protected $pdo;

    public function __construct()
    {
        $this->pdo = Database::connexion();
    }

    protected function view($view, $data = [])
    {
        extract($data);
        require __DIR__ . '/../views/layout/header.php';
        require __DIR__ . '/../views/' . $view . '.php';
        require __DIR__ . '/../views/layout/footer.php';
    }

    protected function userConnecte()
    {
        return isset($_SESSION['user']);
    }

    protected function estAdmin()
    {
        return $this->userConnecte() && in_array($_SESSION['user']['role'], ['admin', 'superadmin']);
    }

    protected function verifierConnexion()
    {
        if (!$this->userConnecte()) {
            redirection('login');
        }
    }

    protected function verifierAdmin()
    {
        $this->verifierConnexion();

        if (!$this->estAdmin()) {
            redirection('produits');
        }
    }
}
