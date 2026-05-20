<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<h1>Ajouter un produit</h1>

<form action="<?= base_url('/produits/store') ?>" method="post" enctype="multipart/form-data" style="max-width:500px;margin-top:20px;">
    <div style="margin-bottom:10px;">
        <label for="nom">Nom</label><br>
        <input type="text" name="nom" id="nom" required
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="description">Description</label><br>
        <textarea name="description" id="description"
                  style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;"></textarea>
    </div>

    <div style="margin-bottom:10px;">
        <label for="prix">Prix (€)</label><br>
        <input type="number" step="0.01" name="prix" id="prix" required
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="stock">Stock</label><br>
        <input type="number" name="stock" id="stock" required
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="image">Image (optionnel)</label><br>
        <input type="file" name="image" id="image"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <button type="submit" class="btn btn-primary">Enregistrer</button>
    <a href="<?= base_url('/produits') ?>" class="btn btn-secondary" style="margin-left:8px;">Annuler</a>
</form>

<?= $this->endSection() ?>
