# AP3 Gestion Produit API

Projet CodeIgniter 4 utilise pour l'epreuve E6 BTS SIO SLAM.

Cette realisation correspond a une API REST PHP/MySQL consommee par une application mobile Android. Elle permet de gerer un catalogue de produits, un panier, des commandes et une partie administrateur.

## Contenu du dossier

- `app/` : code CodeIgniter 4, controleurs web, controleurs API, modeles, filtres JWT et migrations.
- `public/` : point d'entree web et images du catalogue dans `public/uploads/`.
- `database/gestion_produits.sql` : export MySQL complet de la base locale avec donnees, routines et triggers.
- `docs/` : scripts SQL complementaires, sources des images, et document E6 rempli dans `docs/e6/`.
- `tests/` : tests PHPUnit du projet API.
- `writable/` : structure minimale requise par CodeIgniter, sans logs ni caches locaux.

## Installation rapide

1. Installer les dependances PHP :

```text
composer install
```

2. Importer la base :

```text
database/gestion_produits.sql
```

3. Creer un fichier `.env` a partir de `.env.example`, puis adapter les valeurs locales :

```text
database.default.hostname = localhost
database.default.database = gestion_produits
database.default.username = root
database.default.password =
JWT_SECRET = votre_cle_locale
```

4. Lancer le serveur local :

```text
php spark serve --host 127.0.0.1 --port 8080
```

5. Tester l'API :

```text
http://127.0.0.1:8080/api/test
```

## Comptes de test

- Administrateur : `jean.dupont@example.com` / `azerty123`
- Utilisateur : `marie.durand@example.com` / `mdp123`

## Routes API principales

- `POST /api/login`
- `GET /api/produits`
- `GET /api/panier`
- `POST /api/panier/add`
- `POST /api/commandes`
- `GET /api/commandes`
- `GET /api/admin/stats`
- `GET /api/admin/commandes`
- `GET /api/admin/utilisateurs`

## Document E6

Le document rempli est range ici :

```text
docs/e6/Annexe_VII_1_B_AP3_Gestion_Produits_API_Mobile_remplie.docx
```

Le numero candidat reste a completer manuellement dans le document avant depot final.
