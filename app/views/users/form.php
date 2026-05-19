<div class="page-title">
    <div>
        <h1><?= $id ? 'Modifier utilisateur' : 'Ajouter utilisateur' ?></h1>
        <p>Formulaire utilisateur dans une vue MVC.</p>
    </div>
</div>

<form method="post" action="<?= url('utilisateur_save') ?>" class="form-box large">
    <input type="hidden" name="mode" value="<?= $id ? 'modifier' : 'ajouter' ?>">
    <input type="hidden" name="id_utilisateur" value="<?= e($user['id_utilisateur']) ?>">

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

    <label>Mot de passe <?= $id ? '(laisser vide pour ne pas changer)' : '' ?></label>
    <input type="password" name="mot_de_passe" <?= $id ? '' : 'required' ?>>

    <label>Rôle</label>
    <select name="role">
        <option value="utilisateur" <?= $user['role'] === 'utilisateur' ? 'selected' : '' ?>>utilisateur</option>
        <option value="admin" <?= $user['role'] === 'admin' ? 'selected' : '' ?>>admin</option>
        <option value="superadmin" <?= $user['role'] === 'superadmin' ? 'selected' : '' ?>>superadmin</option>
    </select>

    <div class="actions">
        <button class="btn" type="submit">Enregistrer</button>
        <a class="btn light" href="<?= url('utilisateurs') ?>">Annuler</a>
    </div>
</form>
