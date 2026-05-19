<?php

session_start();

require __DIR__ . '/app/core/helpers.php';
require __DIR__ . '/app/core/Database.php';
require __DIR__ . '/app/core/Controller.php';

require __DIR__ . '/app/models/Product.php';
require __DIR__ . '/app/models/User.php';

require __DIR__ . '/app/controllers/AuthController.php';
require __DIR__ . '/app/controllers/ProductController.php';
require __DIR__ . '/app/controllers/UserController.php';
require __DIR__ . '/app/controllers/AccountController.php';

$page = $_GET['page'] ?? 'produits';

try {
    switch ($page) {
        case 'login':
            (new AuthController())->login();
            break;

        case 'login_post':
            (new AuthController())->checkLogin();
            break;

        case 'logout':
            (new AuthController())->logout();
            break;

        case 'produits':
            (new ProductController())->index();
            break;

        case 'produit_form':
            (new ProductController())->form();
            break;

        case 'produit_save':
            (new ProductController())->save();
            break;

        case 'produit_delete':
            (new ProductController())->delete();
            break;

        case 'utilisateurs':
            (new UserController())->index();
            break;

        case 'utilisateur_form':
            (new UserController())->form();
            break;

        case 'utilisateur_save':
            (new UserController())->save();
            break;

        case 'utilisateur_delete':
            (new UserController())->delete();
            break;

        case 'mon_compte':
            (new AccountController())->edit();
            break;

        case 'mon_compte_save':
            (new AccountController())->save();
            break;

        default:
            redirection('produits');
    }
} catch (PDOException $e) {
    echo 'Erreur SQL : ' . e($e->getMessage());
}
