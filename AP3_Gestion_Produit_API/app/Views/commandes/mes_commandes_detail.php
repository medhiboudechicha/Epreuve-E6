<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<h1>Detail de la commande n°<?= esc($commande['id_commande']) ?></h1>

<p style="margin-top:8px;">
    Passee le : <strong><?= esc($commande['date_commande']) ?></strong><br>
    Quantite totale : <strong><?= esc($commande['quantite']) ?></strong>
</p>

<?php if (empty($lignes)) : ?>
    <p style="margin-top:16px;">Aucun produit pour cette commande.</p>
<?php else : ?>
    <table class="table" style="margin-top:20px;width:100%;border-collapse:collapse;">
        <thead>
            <tr>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Produit</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Quantite</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Prix</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Sous-total</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Image</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($lignes as $l) : ?>
                <tr>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($l['nom']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($l['quantite'] ?? 1) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                        <?= number_format((float) $l['prix'], 2, ',', ' ') ?> EUR
                    </td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                        <?= number_format((float) $l['prix'] * (int) ($l['quantite'] ?? 1), 2, ',', ' ') ?> EUR
                    </td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                        <?php $image = !empty($l['image']) ? $l['image'] : 'no_image.jpg'; ?>
                        <img src="<?= base_url('uploads/' . $image) ?>" alt=""
                             style="width:50px;height:50px;object-fit:cover;border-radius:6px;border:1px solid #e2e8f0;">
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3" style="padding:8px;text-align:right;font-weight:bold;">Total :</td>
                <td style="padding:8px;font-weight:bold;">
                    <?= number_format((float) $total, 2, ',', ' ') ?> EUR
                </td>
                <td></td>
            </tr>
        </tfoot>
    </table>
<?php endif; ?>

<p style="margin-top:16px;">
    <a href="<?= base_url('mes-commandes') ?>" class="btn btn-secondary">Retour a mes commandes</a>
</p>

<?= $this->endSection() ?>
