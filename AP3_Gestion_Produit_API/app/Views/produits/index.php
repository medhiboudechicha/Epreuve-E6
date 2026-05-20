<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<section class="page-header">
    <div class="page-header__titles">
        <h1>Catalogue des produits</h1>
        <p class="page-header__subtitle">Tous les articles disponibles dans la base.</p>
    </div>

    <?php if (session()->get('user_role') === 'admin') : ?>
        <div class="page-header__actions">
            <a href="<?= base_url('produits/create') ?>" class="btn btn-primary">Ajouter un produit</a>
        </div>
    <?php endif; ?>
</section>

<?php if (session()->getFlashdata('success')) : ?>
    <p style="color:green;margin-bottom:10px;">
        <?= esc(session()->getFlashdata('success')) ?>
    </p>
<?php endif; ?>

<?php if (session()->getFlashdata('error')) : ?>
    <p style="color:red;margin-bottom:10px;">
        <?= esc(session()->getFlashdata('error')) ?>
    </p>
<?php endif; ?>

<?php if (empty($produits)) : ?>
    <p>Aucun produit pour le moment.</p>
<?php else : ?>
    <div class="products-list">
        <?php foreach ($produits as $p) : ?>
            <?php $image = !empty($p['image']) ? $p['image'] : 'no_image.jpg'; ?>

            <article class="product-card-vertical">
                <div class="product-card-vertical__image-wrapper">
                    <img src="<?= base_url('uploads/' . $image) ?>"
                         alt="<?= esc($p['nom']) ?>"
                         class="product-card-vertical__image">
                </div>

                <div class="product-card-vertical__body">
                    <div class="product-card-vertical__header">
                        <h2 class="product-card-vertical__title">
                            <?= esc($p['nom']) ?>
                        </h2>
                        <p class="product-card-vertical__price">
                            <?= number_format((float) $p['prix'], 2, ',', ' ') ?> €
                        </p>
                    </div>

                    <p class="product-card-vertical__meta">
                        ID : <?= esc($p['id_produit']) ?> · Stock : <?= esc($p['stock']) ?>
                    </p>

                    <?php if (!empty($p['description'])) : ?>
                        <p class="product-card-vertical__description">
                            <?= esc($p['description']) ?>
                        </p>
                    <?php endif; ?>

                    <div class="product-card-vertical__footer">
                        <div style="display:flex;gap:8px;flex-wrap:wrap;">
                            <a href="<?= base_url('panier/add/' . $p['id_produit']) ?>" class="btn btn-secondary">
                                Ajouter au panier
                            </a>
                            <a href="<?= base_url('produits/detail/' . $p['id_produit']) ?>" class="btn btn-primary">
                                Voir le produit
                            </a>
                        </div>

                        <?php if (session()->get('user_role') === 'admin') : ?>
                            <div class="product-card-vertical__admin-actions">
                                <a href="<?= base_url('produits/edit/' . $p['id_produit']) ?>" class="link">
                                    Modifier
                                </a>
                                <a href="<?= base_url('produits/delete/' . $p['id_produit']) ?>"
                                class="link link--danger"
                                onclick="return confirm('Supprimer ce produit ?');">
                                    Supprimer
                                </a>
                            </div>
                        <?php endif; ?>
                    </div>
                </div>
            </article>
        <?php endforeach; ?>
    </div>
<?php endif; ?>

<?= $this->endSection() ?>
