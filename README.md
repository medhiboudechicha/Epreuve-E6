# Epreuve E6

Depot organise pour ranger plusieurs projets.

## Projets

- `gestion-produits-mvc/` : application PHP MVC simple connectee a SQL Server, avec son dossier `bdd/`.
- `AP3_Gestion_Produit_API/` : API REST CodeIgniter 4 connectee a MySQL pour l'application mobile de gestion de produits, panier, commandes et administration.
- `AP3_ApiMobile_Android/` : application mobile Android native Java connectee a l'API AP3.

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
- L'export phpMyAdmin et le tutoriel Laragon/WAMP sont dans `AP3_Gestion_Produit_API/bdd/`.
- Le document E6 rempli est dans `AP3_Gestion_Produit_API/docs/e6/`.
- Les instructions d'installation sont dans `AP3_Gestion_Produit_API/README.md`.

## AP3 ApiMobile Android

Le projet mobile est range dans `AP3_ApiMobile_Android/`.

- Les sources Android sont dans `AP3_ApiMobile_Android/app/src/`.
- Le tutoriel d'installation, d'import Android Studio et de configuration de l'API est dans `AP3_ApiMobile_Android/README.md`.
- Les fichiers locaux Android Studio, les builds Gradle et `local.properties` sont exclus du depot.

## Ajouter un autre projet

Creer un nouveau dossier a la racine du depot, par exemple :

```text
autre-projet/
```

Puis ajouter les fichiers du projet dedans.
