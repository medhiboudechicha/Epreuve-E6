<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<h1>Connexion</h1>

<?php if (session()->getFlashdata('error')) : ?>
    <p style="color:red;"><?= esc(session()->getFlashdata('error')) ?></p>
<?php endif; ?>

<form action="<?= base_url('/login') ?>" method="post" style="max-width:400px;margin-top:20px;">
    <div style="margin-bottom:10px;">
        <label for="email">Email</label><br>
        <input type="email" name="email" id="email" required
               value="<?= esc(old('email')) ?>"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="mot_de_passe">Mot de passe</label><br>
        <input type="password" name="mot_de_passe" id="mot_de_passe" required
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <button type="submit" class="btn btn-primary">Se connecter</button>
</form>

<?= $this->endSection() ?>
