<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<?php
$image = !empty($produit['image']) ? $produit['image'] : 'no_image.jpg';
?>

<section class="product-detail">
    <div class="product-detail__image-wrapper">
        <img src="<?= base_url('uploads/' . $image) ?>"
             alt="<?= esc($produit['nom']) ?>"
             class="product-detail__image">
    </div>

    <div class="product-detail__body">
        <h1 class="product-detail__title"><?= esc($produit['nom']) ?></h1>

        <p class="product-detail__price">
            <?= number_format((float) $produit['prix'], 2, ',', ' ') ?> €
        </p>

        <p class="product-detail__meta">
            ID : <?= esc($produit['id_produit']) ?> · Stock : <?= esc($produit['stock']) ?>
        </p>

        <?php if (!empty($produit['description'])) : ?>
            <p class="product-detail__description">
                <?= esc($produit['description']) ?>
            </p>
        <?php else : ?>
            <p class="product-detail__description product-detail__description--muted">
                Aucun descriptif détaillé n'est disponible pour ce produit.
            </p>
        <?php endif; ?>

        <div class="product-detail__actions">
            <a href="<?= base_url('panier/add/' . $produit['id_produit']) ?>" class="btn btn-primary">
                Ajouter au panier
            </a>

            <a href="<?= base_url('produits') ?>" class="btn btn-secondary">
                Retour au catalogue
            </a>

            <?php if (session()->get('user_role') === 'admin') : ?>
                <a href="<?= base_url('produits/edit/' . $produit['id_produit']) ?>" class="btn btn-secondary">
                    Modifier le produit
                </a>
            <?php endif; ?>
        </div>
    </div>
</section>

<?= $this->endSection() ?>
