<section class="login-page">
    <form method="post" action="<?= url('login_post') ?>" class="form-box">
        <h1>Connexion</h1>

        <label>Email</label>
        <input type="email" name="email" required>

        <label>Mot de passe</label>
        <input type="password" name="mot_de_passe" required>

        <button class="btn" type="submit">Se connecter</button>

        <div class="demo-box">
            <strong>Comptes de test</strong>
            <span>Admin : admin@demo.fr / admin123</span>
            <span>Utilisateur : user@demo.fr / user123</span>
        </div>
    </form>
</section>
