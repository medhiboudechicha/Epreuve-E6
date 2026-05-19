# Gestion Produits MVC

Projet PHP MVC simple connecte a SQL Server.

## Prerequis

- Laragon avec PHP 8.3
- Extension PHP `pdo_sqlsrv`
- SQL Server avec la base `gestion_produits`

Le script de base de donnees et le tutoriel d'installation sont dans `../bdd/`.

## Lancer le projet

Depuis Laragon :

```text
http://localhost/Epreuve-E6/gestion-produits-mvc/index.php?page=login
```

Ou avec le serveur PHP local :

```powershell
php -S 127.0.0.1:8090 -t C:\laragon\www\Epreuve-E6\gestion-produits-mvc
```

Puis ouvrir :

```text
http://127.0.0.1:8090/index.php?page=login
```

## Comptes de test

- Admin : `admin@demo.fr` / `admin123`
- Utilisateur : `user@demo.fr` / `user123`

## Structure MVC

```text
app/
  controllers/
  core/
  models/
  views/
assets/
uploads/
config.php
index.php
```

## Routes principales

- `index.php?page=login`
- `index.php?page=produits`
- `index.php?page=produit_form`
- `index.php?page=utilisateurs`
- `index.php?page=mon_compte`
