<div class="page-title">
    <div>
        <h1><?= $id ? 'Modifier produit' : 'Ajouter produit' ?></h1>
        <p>Formulaire produit dans une vue MVC.</p>
    </div>
</div>

<form method="post" action="<?= url('produit_save') ?>" class="form-box large">
    <input type="hidden" name="mode" value="<?= $id ? 'modifier' : 'ajouter' ?>">

    <label>Référence produit</label>
    <input type="text" name="id_produit" value="<?= e($produit['id_produit']) ?>" <?= $id ? 'readonly' : '' ?> required>

    <label>Nom</label>
    <input type="text" name="nom" value="<?= e($produit['nom']) ?>" required>

    <label>Description</label>
    <textarea name="description" rows="5" required><?= e($produit['description']) ?></textarea>

    <div class="form-row">
        <div>
            <label>Prix</label>
            <input type="number" step="0.01" min="0" name="prix" value="<?= e($produit['prix']) ?>" required>
        </div>
        <div>
            <label>Stock</label>
            <input type="number" min="0" name="stock" value="<?= e($produit['stock']) ?>" required>
        </div>
    </div>

    <label>Image</label>
    <input type="text" name="image" value="<?= e($produit['image']) ?>" placeholder="no_image.jpg">

    <div class="actions">
        <button class="btn" type="submit">Enregistrer</button>
        <a class="btn light" href="<?= url('produits') ?>">Annuler</a>
    </div>
</form>
