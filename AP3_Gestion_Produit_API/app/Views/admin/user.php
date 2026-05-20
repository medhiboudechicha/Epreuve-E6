<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>

<h1>Gestion des utilisateurs</h1>

<?php if (session()->getFlashdata('error')) : ?>
    <p style="color:red;"><?= esc(session()->getFlashdata('error')) ?></p>
<?php endif; ?>

<?php if (!empty($utilisateurs)) : ?>
    <table class="table" style="margin-top:20px;width:100%;border-collapse:collapse;">
        <thead>
            <tr>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">ID</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Nom</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Prénom</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Email</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Rôle</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($utilisateurs as $u) : ?>
                <tr>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($u['id_utilisateur']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($u['nom']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($u['prenom']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($u['email']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($u['role']) ?></td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php else : ?>
    <p>Aucun utilisateur trouvé.</p>
<?php endif; ?>

<?= $this->endSection() ?>
