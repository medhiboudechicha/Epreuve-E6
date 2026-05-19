<div class="page-title">
    <div>
        <h1>Mon compte</h1>
        <p>Un utilisateur peut modifier ses informations personnelles.</p>
    </div>
</div>

<form method="post" action="<?= url('mon_compte_save') ?>" class="form-box large">
    <div class="form-row">
        <div>
            <label>Nom</label>
            <input type="text" name="nom" value="<?= e($user['nom']) ?>" required>
        </div>
        <div>
            <label>Prénom</label>
            <input type="text" name="prenom" value="<?= e($user['prenom']) ?>" required>
        </div>
    </div>

    <label>Email</label>
    <input type="email" name="email" value="<?= e($user['email']) ?>" required>

    <label>Nouveau mot de passe</label>
    <input type="password" name="mot_de_passe" placeholder="Laisser vide pour ne pas changer">

    <label>Rôle</label>
    <input type="text" value="<?= e($user['role']) ?>" readonly>

    <div class="actions">
        <button class="btn" type="submit">Enregistrer</button>
        <a class="btn light" href="<?= url('produits') ?>">Retour</a>
    </div>
</form>
