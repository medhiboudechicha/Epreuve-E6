<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');
// connexion / inscription et déconnexion
$routes->get('/login', 'Auth::login');
$routes->post('/login', 'Auth::doLogin');
$routes->get('/logout', 'Auth::logout');
$routes->get('/register', 'Auth::register');
$routes->post('/register', 'Auth::doRegister');
$routes->get('/admin/utilisateurs', 'AdminController::users');
// Gestion des produits (public)
$routes->get('/produits', 'ProduitController::index');
// Gestion des produits (admin)
$routes->get('/produits/create', 'ProduitController::create');
$routes->post('/produits/store', 'ProduitController::store');
$routes->get('/produits/edit/(:any)', 'ProduitController::edit/$1');
$routes->post('/produits/update/(:any)', 'ProduitController::update/$1');
$routes->get('/produits/delete/(:any)', 'ProduitController::delete/$1');
// Panier 
$routes->get('/panier', 'Panier::index');
$routes->get('/panier/add/(:any)', 'Panier::add/$1');
$routes->get('/panier/remove/(:any)', 'Panier::remove/$1');
$routes->get('/panier/clear', 'Panier::clear');
$routes->post('panier/valider', 'Panier::valider');

// Détail d'un produit
$routes->get('produits/detail/(:any)', 'ProduitController::show/$1');

// Commandes utilisateur
$routes->get('mes-commandes', 'CommandeController::mesCommandes');
$routes->get('mes-commandes/detail/(:num)', 'CommandeController::mesCommandesDetail/$1');

// Commandes admin
$routes->get('admin/commandes', 'CommandeController::adminIndex');
$routes->get('admin/commandes/detail/(:num)', 'CommandeController::adminDetail/$1');

// Suppression de commande (utilisateur)
$routes->get('mes-commandes/delete/(:num)', 'CommandeController::deleteUser/$1');

// Suppression de commande (admin)
$routes->get('admin/commandes/delete/(:num)', 'CommandeController::deleteAdmin/$1');

$routes->group('api', static function ($routes) {
    $routes->get('test', 'Api\AuthApi::test');
    $routes->post('login', 'Api\AuthApi::login');
});

$routes->group('api', ['filter' => 'jwt'], function ($routes) {
    $routes->get('panier', 'Api\PanierApi::index');
    $routes->post('panier/add', 'Api\PanierApi::add');
    $routes->post('panier/update', 'Api\PanierApi::update');
    $routes->post('panier/remove', 'Api\PanierApi::remove');
    $routes->post('panier/clear', 'Api\PanierApi::clear');
    $routes->get('commandes', 'Api\CommandesApi::index');
    $routes->get('commandes/(:num)', 'Api\CommandesApi::show/$1');
    $routes->post('commandes', 'Api\CommandesApi::create');
    $routes->resource('produits', [
        'controller' => 'Api\ProduitsApi'
    ]);

    // Routes admin (vérification du rôle gérée dans le contrôleur)
    $routes->get('admin/stats', 'Api\AdminApi::stats');
    $routes->get('admin/commandes', 'Api\AdminApi::index');
    $routes->get('admin/commandes/(:num)', 'Api\AdminApi::showCommande/$1');
    $routes->delete('admin/commandes/(:num)', 'Api\AdminApi::deleteCommande/$1');
    $routes->get('admin/utilisateurs', 'Api\AdminApi::utilisateurs');
});
