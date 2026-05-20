<?= $this->extend('layouts/main') ?>
<?= $this->section('content') ?>

<h1>Modifier un produit</h1>

<form action="<?= base_url('/produits/update/' . $produit['id_produit']) ?>" method="post" enctype="multipart/form-data" style="max-width:500px;margin-top:20px;">
    <div style="margin-bottom:10px;">
        <label for="nom">Nom</label><br>
        <input type="text" name="nom" id="nom" required
               value="<?= esc($produit['nom']) ?>"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="description">Description</label><br>
        <textarea name="description" id="description"
                  style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;"><?= esc($produit['description']) ?></textarea>
    </div>

    <div style="margin-bottom:10px;">
        <label for="prix">Prix (€)</label><br>
        <input type="number" step="0.01" name="prix" id="prix" required
               value="<?= esc($produit['prix']) ?>"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label for="stock">Stock</label><br>
        <input type="number" name="stock" id="stock" required
               value="<?= esc($produit['stock']) ?>"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <div style="margin-bottom:10px;">
        <label>Image actuelle</label><br>
        <?php
            $image = !empty($produit['image']) ? $produit['image'] : 'no_image.png';
        ?>
        <img src="<?= base_url('uploads/' . $image) ?>" alt="" style="width:120px;border-radius:8px;border:1px solid #e2e8f0;margin-bottom:8px;"><br>

        <label for="image">Changer l'image (optionnel)</label><br>
        <input type="file" name="image" id="image"
               style="width:100%;padding:8px;border:1px solid #ccc;border-radius:4px;">
    </div>

    <button type="submit" class="btn btn-primary">Mettre à jour</button>
    <a href="<?= base_url('/produits') ?>" class="btn btn-secondary" style="margin-left:8px;">Annuler</a>
</form>

<?= $this->endSection() ?>
