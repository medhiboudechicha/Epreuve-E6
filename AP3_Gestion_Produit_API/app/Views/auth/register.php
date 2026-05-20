<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<h1>Inscription</h1>

<?php
$errors = session()->getFlashdata('errors');
?>

<?php if (!empty($errors)) : ?>
    <div style="border:1px solid #f97373;background:#fee2e2;color:#b91c1c;padding:10px;margin:10px 0;border-radius:6px;">
        <ul style="margin:0;padding-left:18px;">
            <?php foreach ($errors as $err) : ?>
                <li><?= esc($err) ?></li>
            <?php endforeach; ?>
        </ul>
    </div>
<?php endif; ?>

<form action="<?= base_url('/register') ?>" method="post" style="max-width:400px;margin-top:20px;">
    <div style="margin-bottom:10px;">
        <label for="nom">Nom</label><br>
        <input type="text" name="nom" id="nom"
               value="<?= esc(old('nom')) ?>"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="prenom">Prénom</label><br>
        <input type="text" name="prenom" id="prenom"
               value="<?= esc(old('prenom')) ?>"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="email">Email</label><br>
        <input type="email" name="email" id="email"
               value="<?= esc(old('email')) ?>"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="mot_de_passe">Mot de passe</label><br>
        <input type="password" name="mot_de_passe" id="mot_de_passe"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="mot_de_passe_confirm">Confirmer le mot de passe</label><br>
        <input type="password" name="mot_de_passe_confirm" id="mot_de_passe_confirm"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <button type="submit" class="btn btn-primary">Créer mon compte</button>
</form>

<?= $this->endSection() ?>
