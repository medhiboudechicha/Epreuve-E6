# Epreuve E6

Depot organise pour ranger plusieurs projets.

## Projets

- `gestion-produits-mvc/` : application PHP MVC simple connectee a SQL Server.
- `bdd/` : export SQL Server de la base `gestion_produits` et tutoriel d'installation.

## Installation rapide

1. Importer `bdd/gestion_produits.sql` dans SQL Server Management Studio.
2. Verifier la connexion dans `gestion-produits-mvc/config.php`.
3. Lancer le site avec Laragon ou WAMP :

```text
http://localhost/Epreuve-E6/gestion-produits-mvc/index.php?page=login
```

Le tutoriel complet est dans `bdd/README.md`.

## Ajouter un autre projet

Creer un nouveau dossier a la racine du depot, par exemple :

```text
autre-projet/
```

Puis ajouter les fichiers du projet dedans.
