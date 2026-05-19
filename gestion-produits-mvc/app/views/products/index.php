<div class="page-title">
    <div>
        <h1>Produits</h1>
        <p>Liste simple des produits de la base SQL Server.</p>
    </div>

    <?php if (isset($_SESSION['user']) && in_array($_SESSION['user']['role'], ['admin', 'superadmin'])): ?>
        <a class="btn" href="<?= url('produit_form') ?>">Ajouter un produit</a>
    <?php endif; ?>
</div>

<form class="search-box" method="get" action="index.php">
    <input type="hidden" name="page" value="produits">
    <input type="search" name="recherche" value="<?= e($recherche) ?>" placeholder="Rechercher un produit">
    <button class="btn secondary" type="submit">Rechercher</button>
    <a class="btn light" href="<?= url('produits') ?>">Reset</a>
</form>

<div class="cards">
    <?php foreach ($produits as $produit): ?>
        <article class="card">
            <img src="<?= e(image_produit($produit['image'])) ?>" alt="">

            <div class="card-body">
                <span class="ref"><?= e($produit['id_produit']) ?></span>
                <h2><?= e($produit['nom']) ?></h2>
                <p><?= e($produit['description']) ?></p>

                <div class="infos">
                    <span><?= prix($produit['prix']) ?></span>
                    <span>Stock : <?= e($produit['stock']) ?></span>
                </div>

                <?php if ($produit['auteur'] || $produit['marque']): ?>
                    <p class="small">
                        <?= $produit['auteur'] ? 'Auteur : ' . e($produit['auteur']) : '' ?>
                        <?= $produit['marque'] ? 'Marque : ' . e($produit['marque']) : '' ?>
                    </p>
                <?php endif; ?>

                <?php if (isset($_SESSION['user']) && in_array($_SESSION['user']['role'], ['admin', 'superadmin'])): ?>
                    <div class="actions">
                        <a class="btn light" href="<?= url('produit_form', ['id' => $produit['id_produit']]) ?>">Modifier</a>

                        <form method="post" action="<?= url('produit_delete') ?>" onsubmit="return confirm('Supprimer ce produit ?');">
                            <input type="hidden" name="id_produit" value="<?= e($produit['id_produit']) ?>">
                            <button class="btn danger" type="submit">Supprimer</button>
                        </form>
                    </div>
                <?php endif; ?>
            </div>
        </article>
    <?php endforeach; ?>
</div>
