<div class="page-title">
    <div>
        <h1>Utilisateurs</h1>
        <p>CRUD simple sur la table utilisateur.</p>
    </div>
    <a class="btn" href="<?= url('utilisateur_form') ?>">Ajouter un utilisateur</a>
</div>

<div class="table-box">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Email</th>
                <th>Rôle</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($utilisateurs as $user): ?>
                <tr>
                    <td><?= e($user['id_utilisateur']) ?></td>
                    <td><?= e($user['nom']) ?></td>
                    <td><?= e($user['prenom']) ?></td>
                    <td><?= e($user['email']) ?></td>
                    <td><?= e($user['role']) ?></td>
                    <td class="table-actions">
                        <a class="btn light" href="<?= url('utilisateur_form', ['id' => $user['id_utilisateur']]) ?>">Modifier</a>

                        <?php if ((int) $user['id_utilisateur'] !== (int) $_SESSION['user']['id_utilisateur']): ?>
                            <form method="post" action="<?= url('utilisateur_delete') ?>" onsubmit="return confirm('Supprimer cet utilisateur ?');">
                                <input type="hidden" name="id_utilisateur" value="<?= e($user['id_utilisateur']) ?>">
                                <button class="btn danger" type="submit">Supprimer</button>
                            </form>
                        <?php endif; ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>
