# Gestion Produits Shop

Projet PHP MVC simple connecté à SQL Server.

## Prérequis

- Laragon avec PHP 8.3
- Extension PHP `pdo_sqlsrv`
- SQL Server avec la base `gestion_produits`

## Lancer le projet

Depuis Laragon :

```text
http://localhost/gestion-produits-shop/index.php?page=login
```

Ou avec le serveur PHP local :

```powershell
php -S 127.0.0.1:8090 -t C:\laragon\www\gestion-produits-shop
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
