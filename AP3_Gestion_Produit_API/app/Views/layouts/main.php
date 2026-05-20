<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><?= esc($title ?? 'Accueil') ?> - AP3</title>
    <link rel="stylesheet" href="<?= base_url('assets/css/main.css') ?>">
</head>
<body>

<?php
$cartCount = 0;

if (session()->get('is_logged') && session()->get('user_id')) {
    $panierModel = new \App\Models\PanierItemModel();
    $result = $panierModel
        ->selectSum('quantite')
        ->where('id_utilisateur', (int) session()->get('user_id'))
        ->first();

    $cartCount = (int) ($result['quantite'] ?? 0);
} else {
    $cart = session()->get('cart') ?? [];
    foreach ($cart as $item) {
        $cartCount += (int) ($item['quantite'] ?? 0);
    }
}
?>

<header class="modern-nav">
    <div class="container">
        <nav class="nav-inner">
            <div class="nav-left">
                <a href="<?= base_url('/') ?>" class="nav-logo">AP3</a>
                <a href="<?= base_url('/') ?>">Accueil</a>
                <a href="<?= base_url('produits') ?>">Produits</a>
            </div>

            <div class="nav-center">
                <a href="<?= base_url('panier') ?>">
                    Panier (<?= $cartCount ?>)
                </a>
                <?php if (session()->get('is_logged')) : ?>
                    <a href="<?= base_url('mes-commandes') ?>">Mes commandes</a>
                <?php endif; ?>

                <?php if (session()->get('user_role') === 'admin') : ?>
                    <a href="<?= base_url('admin/commandes') ?>">Commandes (admin)</a>
                <?php endif; ?>
            </div>

            <div class="nav-right">
                <?php if (session()->get('is_logged')) : ?>
                    <span class="nav-user">
                        <?= esc(session()->get('user_prenom')) ?> <?= esc(session()->get('user_nom')) ?>
                    </span>
                    <a href="<?= base_url('logout') ?>" class="logout-btn">Deconnexion</a>
                <?php else : ?>
                    <a href="<?= base_url('login') ?>">Connexion</a>
                    <a href="<?= base_url('register') ?>" class="register-btn">Inscription</a>
                <?php endif; ?>
            </div>
        </nav>
    </div>
</header>

<main class="container">
    <?= $this->renderSection('content') ?>
</main>

<footer>
    &copy; <?= date('Y') ?> - AP3
</footer>

</body>
</html>
