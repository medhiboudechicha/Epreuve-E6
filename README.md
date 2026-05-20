# Epreuve E6

Depot organise pour ranger plusieurs projets.

## Projets

- `gestion-produits-mvc/` : application PHP MVC simple connectee a SQL Server, avec son dossier `bdd/`.
- `AP3_Gestion_Produit_API/` : API REST CodeIgniter 4 connectee a MySQL pour l'application mobile de gestion de produits, panier, commandes et administration.

## Installation rapide

1. Importer `gestion-produits-mvc/bdd/gestion_produits.sql` dans SQL Server Management Studio.
2. Verifier la connexion dans `gestion-produits-mvc/config.php`.
3. Lancer le site avec Laragon ou WAMP :

```text
http://localhost/Epreuve-E6/gestion-produits-mvc/index.php?page=login
```

Le tutoriel complet est dans `gestion-produits-mvc/bdd/README.md`.

## AP3 Gestion Produit API

Le projet API est range dans `AP3_Gestion_Produit_API/`.

- Le script SQL complet est dans `AP3_Gestion_Produit_API/database/gestion_produits.sql`.
- Le document E6 rempli est dans `AP3_Gestion_Produit_API/docs/e6/`.
- Les instructions d'installation sont dans `AP3_Gestion_Produit_API/README.md`.

## Ajouter un autre projet

Creer un nouveau dossier a la racine du depot, par exemple :

```text
autre-projet/
```

Puis ajouter les fichiers du projet dedans.
