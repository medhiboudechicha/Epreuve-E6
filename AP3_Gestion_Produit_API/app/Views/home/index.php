<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<!-- Hero simple en haut -->
<section class="hero">
    <h1 class="hero__title">Bienvenue sur AP3</h1>
    <p class="hero__subtitle">Gérez vos produits, vos commandes et votre panier en toute simplicité.</p>
    <div class="hero__actions">
        <a href="<?= base_url('produits') ?>" class="btn btn-primary">Voir tous les produits</a>
        <a href="<?= base_url('panier') ?>" class="btn btn-secondary">Voir mon panier</a>
    </div>
</section>

<!-- Carrousel horizontal des produits -->
<section class="products-section">
    <div class="products-header">
        <h2>Articles en vente</h2>
        <div class="products-nav">
            <button type="button" class="carousel-btn" id="products-prev">&lt;</button>
            <button type="button" class="carousel-btn" id="products-next">&gt;</button>
        </div>
    </div>

    <div class="products-carousel">
        <div class="products-track" id="products-track">
            <?php if (!empty($produits)) : ?>
                <?php foreach ($produits as $p) : ?>
                    <?php $image = !empty($p['image']) ? $p['image'] : 'no_image.jpg'; ?>

                    <div class="product-card">
                        <div class="product-card-image">
                            <img src="<?= base_url('uploads/' . $image) ?>" alt="<?= esc($p['nom']) ?>">
                        </div>

                        <div class="product-card-body">
                            <div class="product-card-info">
                                <div class="product-card-text">
                                    <span class="product-card-title"><?= esc($p['nom']) ?></span>
                                    <p class="product-card-id">ID : <?= esc($p['id_produit']) ?></p>
                                </div>
                                <span class="product-card-price">
                                    <?= number_format((float)$p['prix'], 2, ',', ' ') ?> €
                                </span>
                            </div>

                            <a href="<?= base_url('panier/add/' . $p['id_produit']) ?>"
                               class="product-card-button">
                                Ajouter au panier
                            </a>

                            <a href="<?= base_url('produits/detail/' . $p['id_produit']) ?>" class="btn btn-primary">
                                Voir le produit
                            </a>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else : ?>
                <p>Aucun produit disponible pour le moment.</p>
            <?php endif; ?>
        </div>
    </div>
</section>

<script>
    // Navigation gauche / droite du carrousel
    (function () {
        const track = document.getElementById('products-track');
        const btnPrev = document.getElementById('products-prev');
        const btnNext = document.getElementById('products-next');

        if (!track || !btnPrev || !btnNext) {
            return;
        }

        const scrollAmount = 300;

        btnPrev.addEventListener('click', function () {
            track.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
        });

        btnNext.addEventListener('click', function () {
            track.scrollBy({ left: scrollAmount, behavior: 'smooth' });
        });
    })();
</script>

<?= $this->endSection() ?>
