<?php

class Product
{
    private $pdo;

    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    public function all($recherche = '')
    {
        $sql = "
            SELECT p.*, a.nom AS auteur, m.nom AS marque
            FROM dbo.produit p
            LEFT JOIN dbo.produit_livre pl ON pl.id_produit = p.id_produit
            LEFT JOIN dbo.auteur a ON a.id_auteur = pl.id_auteur
            LEFT JOIN dbo.produit_vetement pv ON pv.id_produit = p.id_produit
            LEFT JOIN dbo.marque m ON m.id_marque = pv.id_marque
        ";

        if ($recherche !== '') {
            $sql .= " WHERE p.nom LIKE ? OR p.description LIKE ? OR p.id_produit LIKE ?";
            $requete = $this->pdo->prepare($sql . " ORDER BY p.nom");
            $mot = '%' . $recherche . '%';
            $requete->execute([$mot, $mot, $mot]);
            return $requete->fetchAll();
        }

        return $this->pdo->query($sql . " ORDER BY p.nom")->fetchAll();
    }

    public function find($id)
    {
        $requete = $this->pdo->prepare('SELECT * FROM dbo.produit WHERE id_produit = ?');
        $requete->execute([$id]);
        return $requete->fetch();
    }

    public function create($data)
    {
        $sql = 'INSERT INTO dbo.produit (id_produit, nom, description, prix, stock, image) VALUES (?, ?, ?, ?, ?, ?)';
        $requete = $this->pdo->prepare($sql);
        $requete->execute([
            $data['id_produit'],
            $data['nom'],
            $data['description'],
            $data['prix'],
            $data['stock'],
            $data['image'],
        ]);
    }

    public function update($id, $data)
    {
        $sql = 'UPDATE dbo.produit SET nom = ?, description = ?, prix = ?, stock = ?, image = ? WHERE id_produit = ?';
        $requete = $this->pdo->prepare($sql);
        $requete->execute([
            $data['nom'],
            $data['description'],
            $data['prix'],
            $data['stock'],
            $data['image'],
            $id,
        ]);
    }

    public function delete($id)
    {
        $requete = $this->pdo->prepare('DELETE FROM dbo.produit WHERE id_produit = ?');
        $requete->execute([$id]);
    }
}
