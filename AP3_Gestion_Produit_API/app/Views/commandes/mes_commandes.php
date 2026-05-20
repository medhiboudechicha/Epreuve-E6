<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<h1>Mes commandes</h1>

<?php if (session()->getFlashdata('success')) : ?>
    <p style="color:green;"><?= esc(session()->getFlashdata('success')) ?></p>
<?php endif; ?>

<?php if (session()->getFlashdata('error')) : ?>
    <p style="color:red;"><?= esc(session()->getFlashdata('error')) ?></p>
<?php endif; ?>

<?php if (empty($commandes)) : ?>
    <p>Vous n'avez encore passé aucune commande.</p>
<?php else : ?>
    <table class="table" style="margin-top:20px;width:100%;border-collapse:collapse;">
        <thead>
            <tr>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">ID</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Date</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Quantité totale</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($commandes as $c) : ?>
                <tr>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($c['id_commande']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($c['date_commande']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($c['quantite']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                    <a href="<?= base_url('mes-commandes/detail/' . $c['id_commande']) ?>" class="link">
                        Voir le détail
                    </a>
                    |
                    <a href="<?= base_url('mes-commandes/delete/' . $c['id_commande']) ?>"
                    class="link link--danger"
                    onclick="return confirm('Supprimer cette commande ?');">
                        Supprimer
                    </a>
                </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
<?php endif; ?>

<?= $this->endSection() ?>
