<?php
$titre = $titre ?? 'Gestion Produits';
$userSession = $_SESSION['user'] ?? null;
$msg = message();
?>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($titre) ?> - Gestion Produits</title>
    <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
<header class="topbar">
    <a class="logo" href="<?= url('produits') ?>">Gestion Produits</a>

    <?php if ($userSession): ?>
        <nav>
            <a href="<?= url('produits') ?>">Produits</a>
            <a href="<?= url('mon_compte') ?>">Mon compte</a>

            <?php if (in_array($userSession['role'], ['admin', 'superadmin'])): ?>
                <a href="<?= url('produit_form') ?>">Ajouter produit</a>
                <a href="<?= url('utilisateurs') ?>">Utilisateurs</a>
            <?php endif; ?>

            <a href="<?= url('logout') ?>">Déconnexion</a>
        </nav>
        <span class="role"><?= e($userSession['prenom']) ?> - <?= e($userSession['role']) ?></span>
    <?php endif; ?>
</header>

<main class="container">
    <?php if ($msg): ?>
        <div class="message <?= e($msg['type']) ?>"><?= e($msg['texte']) ?></div>
    <?php endif; ?>
