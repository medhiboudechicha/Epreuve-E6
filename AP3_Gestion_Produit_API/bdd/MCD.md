# MCD AP3 Gestion Produit API

Ce fichier documente le modele conceptuel de donnees du projet AP3 Gestion Produit API.

Le MCD source est disponible dans le fichier Looping :

```text
AP3_Gestion_Produit_API/bdd/mcd_ap3_gestion_produits_api.loo
```

Le fichier `.loo` s'ouvre avec Looping. Il ne doit pas etre importe dans phpMyAdmin. Pour creer la base MySQL, utiliser le fichier `gestion_produits.sql`.

## Role du MCD

Le modele represente les donnees necessaires au fonctionnement de l'API CodeIgniter 4 et de l'application Android :

- gestion des utilisateurs et des roles ;
- authentification puis appels API avec un compte utilisateur ou administrateur ;
- catalogue de produits ;
- specialisation des produits en livres ou vetements ;
- panier utilisateur ;
- commandes et lignes de commande ;
- fournisseurs, genres, auteurs et marques ;
- historique des actions importantes.

## Entites principales

### Utilisateur

Stocke les comptes pouvant se connecter a l'application.

Champs principaux :

- `id_utilisateur`
- `nom`
- `prenom`
- `email`
- `mot_de_passe`
- `role`

Roles utilises par l'application :

- `utilisateur`
- `admin`
- `superadmin`

### Produit

Stocke les informations communes a tous les produits du catalogue.

Champs principaux :

- `id_produit`
- `nom`
- `description`
- `prix`
- `stock`
- `image`

### Produit_livre

Specialisation d'un produit de type livre.

Champs principaux :

- `id_produit`
- `nb_pages`
- `id_auteur`

### Produit_vetement

Specialisation d'un produit de type vetement.

Champs principaux :

- `id_produit`
- `taille`
- `couleur`
- `matiere`
- `id_marque`

### Commande

Stocke une commande passee par un utilisateur.

Champs principaux :

- `id_commande`
- `date_commande`
- `quantite`
- `id_utilisateur`

### Panier_item

Stocke le panier courant d'un utilisateur.

Champs principaux :

- `id_panier_item`
- `id_utilisateur`
- `id_produit`
- `quantite`
- `created_at`
- `updated_at`

Une contrainte unique evite qu'un meme utilisateur ait deux lignes de panier pour le meme produit.

### Auteur

Stocke les auteurs lies aux produits de type livre.

Champs principaux :

- `id_auteur`
- `nom`
- `description`

### Genre

Stocke les genres pouvant etre associes aux livres.

Champs principaux :

- `id_genre`
- `nom`

### Marque

Stocke les marques pouvant etre associees aux vetements.

Champs principaux :

- `id_marque`
- `nom`

### Fournisseur

Stocke les fournisseurs associes aux produits.

Champs principaux :

- `id_fournisseur`
- `nom`
- `adresse`
- `email`
- `telephone`

### Historique

Stocke des traces d'actions effectuees sur les donnees.

Champs principaux :

- `id_historique`
- `date_action`
- `action`

## Associations principales

- Un `Utilisateur` peut passer plusieurs `Commandes`.
- Une `Commande` appartient a un seul `Utilisateur`.
- Une `Commande` contient plusieurs `Produits` via l'association `appartenir`.
- Un `Produit` peut apparaitre dans plusieurs `Commandes`.
- L'association `appartenir` porte la quantite commandee.
- Un `Utilisateur` peut consulter plusieurs `Produits` via l'association `consulter`.
- Un `Utilisateur` possede plusieurs lignes de panier via `panier_item`.
- Un `Produit` peut etre present dans plusieurs paniers via `panier_item`.
- Un `Produit` peut etre specialise en `Produit_livre`.
- Un `Produit` peut etre specialise en `Produit_vetement`.
- Un `Produit_livre` peut avoir un `Auteur`.
- Un `Auteur` peut etre lie a plusieurs livres.
- Un `Produit_livre` peut etre classe dans plusieurs `Genres` via `classer`.
- Un `Genre` peut contenir plusieurs livres.
- Un `Produit_vetement` peut avoir une `Marque`.
- Une `Marque` peut etre liee a plusieurs vetements.
- Un `Produit` peut etre fourni par plusieurs `Fournisseurs` via `fournir`.
- Un `Fournisseur` peut fournir plusieurs produits.

## Correspondance avec l'application

Le mobile Android ne se connecte pas directement a cette base. Le flux est :

```text
Application Android -> API CodeIgniter 4 -> Base MySQL gestion_produits
```

Les routes API utilisent ce modele pour :

- connecter un utilisateur ;
- afficher les produits ;
- ajouter, modifier ou supprimer des produits en admin ;
- gerer le panier ;
- creer une commande ;
- afficher les commandes ;
- afficher les statistiques administrateur.

## Fichiers lies

- `gestion_produits.sql` : script SQL a importer dans phpMyAdmin.
- `mcd_ap3_gestion_produits_api.loo` : MCD ouvrable avec Looping.
- `README.md` : tutoriel d'import MySQL avec Laragon/WAMP et explications d'utilisation.
