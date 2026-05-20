<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<h1>Panier</h1>

<?php if (session()->getFlashdata('success')) : ?>
    <p style="color:green;"><?= esc(session()->getFlashdata('success')) ?></p>
<?php endif; ?>

<?php if (session()->getFlashdata('error')) : ?>
    <p style="color:red;"><?= esc(session()->getFlashdata('error')) ?></p>
<?php endif; ?>

<?php if (!empty($cart)) : ?>
    <table class="table" style="margin-top:20px;width:100%;border-collapse:collapse;">
        <thead>
            <tr>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Image</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Produit</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Prix</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Quantité</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Sous-total</th>
                <th style="border-bottom:1px solid #e2e8f0;padding:8px;">Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($cart as $item) : ?>
                <tr>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                        <?php $image = !empty($item['image']) ? $item['image'] : 'no_image.jpg'; ?>
                        <img src="<?= base_url('uploads/' . $image) ?>" alt=""
                             style="width:60px;height:60px;object-fit:cover;border-radius:6px;border:1px solid #e2e8f0;">
                    </td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($item['nom']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                        <?= number_format($item['prix'], 2, ',', ' ') ?> €
                    </td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;"><?= esc($item['quantite']) ?></td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                        <?= number_format($item['prix'] * $item['quantite'], 2, ',', ' ') ?> €
                    </td>
                    <td style="border-bottom:1px solid #e2e8f0;padding:8px;">
                        <a href="<?= base_url('panier/remove/' . $item['id_produit']) ?>" class="link link--danger">
                            Retirer
                        </a>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="4" style="padding:8px;text-align:right;font-weight:bold;">Total :</td>
                <td style="padding:8px;font-weight:bold;">
                    <?= number_format($total, 2, ',', ' ') ?> €
                </td>
                <td></td>
            </tr>
        </tfoot>
    </table>

    <div style="margin-top:16px;display:flex;gap:8px;flex-wrap:wrap;">
        <a href="<?= base_url('panier/clear') ?>" class="btn btn-secondary"
           onclick="return confirm('Vider le panier ?');">
            Vider le panier
        </a>

        <form action="<?= base_url('panier/valider') ?>" method="post">
            <button type="submit" class="btn btn-primary">
                Valider la commande
            </button>
        </form>
    </div>

<?php else : ?>
    <p style="margin-top:20px;">Votre panier est vide.</p>
<?php endif; ?>

<?= $this->endSection() ?>
