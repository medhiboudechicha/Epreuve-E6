# Base de donnees `gestion_produits`

Ce dossier contient la base de donnees MySQL du projet AP3 Gestion Produit API.

Fichiers principaux :

```text
bdd/gestion_produits.sql
bdd/mcd_ap3_gestion_produits_api.loo
bdd/MCD.md
```

Le fichier vient d'un export phpMyAdmin. Il contient les tables, les donnees de test, les procedures stockees et les triggers necessaires au projet.

Le fichier `.loo` contient le MCD du projet et s'ouvre avec Looping. Le fichier `MCD.md` resume le modele de donnees, les entites, les associations et les cardinalites principales.

Attention : le fichier `.loo` ne s'importe pas dans phpMyAdmin. Il sert a consulter ou modifier le modele conceptuel de donnees. Pour creer la base MySQL, utiliser uniquement `gestion_produits.sql`.

## MCD Looping

Pour ouvrir le MCD :

1. Installer Looping.
2. Ouvrir Looping.
3. Cliquer sur `Fichier > Ouvrir`.
4. Selectionner :

```text
AP3_Gestion_Produit_API/bdd/mcd_ap3_gestion_produits_api.loo
```

5. Verifier les entites principales : `Utilisateur`, `Produit`, `Commande`, `Panier_item`, `Genre`, `Auteur`, `Marque`, `Fournisseur`.
6. Consulter `MCD.md` pour lire les explications sans ouvrir Looping.

## Contenu de la base

La base s'appelle `gestion_produits`.

Elle contient 16 tables :

```text
appartenir
auteur
classer
commande
consulter
fournir
fournisseur
genre
historique
marque
migrations
panier_item
produit
produit_livre
produit_vetement
utilisateur
```

Elle contient aussi :

- 8 procedures stockees.
- 22 triggers.
- Des comptes utilisateurs de test.
- Des produits de test pour le catalogue.
- Des commandes et lignes de commande.

## Comptes de test

Comptes utiles pour tester l'application :

```text
Administrateur
Email : jean.dupont@example.com
Mot de passe : azerty123

Utilisateur
Email : marie.durand@example.com
Mot de passe : mdp123
```

Les mots de passe sont stockes sous forme de hash dans la table `utilisateur`.

## Import avec Laragon et phpMyAdmin

1. Ouvrir Laragon.
2. Cliquer sur `Start All`.
3. Verifier que Apache et MySQL sont demarres.
4. Ouvrir phpMyAdmin :

```text
http://localhost/phpmyadmin
```

5. Se connecter avec :

```text
Utilisateur : root
Mot de passe : laisser vide
```

6. Cliquer sur `Nouvelle base de donnees`.
7. Creer une base nommee exactement :

```text
gestion_produits
```

8. Choisir l'interclassement :

```text
utf8mb4_general_ci
```

9. Cliquer sur la base `gestion_produits` dans le menu de gauche.
10. Aller dans l'onglet `Importer`.
11. Selectionner le fichier :

```text
AP3_Gestion_Produit_API/bdd/gestion_produits.sql
```

12. Laisser le format sur `SQL`.
13. Cliquer sur `Importer`.

Apres import, phpMyAdmin doit afficher les tables de la base.

## Configuration du projet avec Laragon

Dans le projet CodeIgniter, creer un fichier `.env` a partir de `.env.example`, puis verifier ces valeurs :

```text
CI_ENVIRONMENT = development

app_baseURL = 'http://localhost:8080/'

database.default.hostname = localhost
database.default.database = gestion_produits
database.default.username = root
database.default.password =
database.default.DBDriver = MySQLi
database.default.DBPrefix =
database.default.port = 3306

JWT_SECRET = 'votre_cle_locale'
```

Pour lancer le serveur CodeIgniter :

```text
php spark serve --host 127.0.0.1 --port 8080
```

Test rapide :

```text
http://127.0.0.1:8080/api/test
```

## Import avec WAMP et phpMyAdmin

1. Ouvrir WampServer.
2. Attendre que l'icone WAMP soit verte.
3. Ouvrir phpMyAdmin depuis le menu WAMP ou depuis :

```text
http://localhost/phpmyadmin
```

4. Se connecter avec :

```text
Utilisateur : root
Mot de passe : laisser vide
```

Selon l'installation WAMP, un mot de passe peut avoir ete defini. Dans ce cas, utiliser le mot de passe configure localement.

5. Cliquer sur `Nouvelle base de donnees`.
6. Creer une base nommee :

```text
gestion_produits
```

7. Choisir l'interclassement :

```text
utf8mb4_general_ci
```

8. Cliquer sur la base `gestion_produits`.
9. Aller dans `Importer`.
10. Selectionner :

```text
AP3_Gestion_Produit_API/bdd/gestion_produits.sql
```

11. Cliquer sur `Importer`.

## Configuration du projet avec WAMP

La configuration est presque identique a Laragon :

```text
database.default.hostname = localhost
database.default.database = gestion_produits
database.default.username = root
database.default.password =
database.default.DBDriver = MySQLi
database.default.port = 3306
```

Si WAMP utilise un autre port MySQL, par exemple `3308`, modifier la ligne :

```text
database.default.port = 3308
```

Pour connaitre le port MySQL dans WAMP :

1. Cliquer sur l'icone WAMP.
2. Aller dans `MySQL`.
3. Regarder la configuration du service ou le fichier `my.ini`.

## Import en ligne de commande

Si phpMyAdmin refuse l'import a cause d'une limite de taille ou de temps, utiliser MySQL en ligne de commande.

Avec Laragon :

```text
C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysql.exe -u root -e "CREATE DATABASE IF NOT EXISTS gestion_produits CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysql.exe -u root gestion_produits < AP3_Gestion_Produit_API\bdd\gestion_produits.sql
```

Avec WAMP, le chemin de `mysql.exe` depend de la version installee. Exemple :

```text
C:\wamp64\bin\mysql\mysql8.0.31\bin\mysql.exe -u root -e "CREATE DATABASE IF NOT EXISTS gestion_produits CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
C:\wamp64\bin\mysql\mysql8.0.31\bin\mysql.exe -u root gestion_produits < AP3_Gestion_Produit_API\bdd\gestion_produits.sql
```

Adapter `mysql8.0.31` selon le dossier present dans `C:\wamp64\bin\mysql`.

## Verification apres import

Dans phpMyAdmin, verifier :

1. La base `gestion_produits` existe.
2. Les 16 tables sont presentes.
3. La table `produit` contient des articles.
4. La table `utilisateur` contient les comptes de test.
5. La table `migrations` contient les migrations CodeIgniter.
6. Les procedures stockees sont visibles dans l'onglet `Routines`.
7. Les triggers sont visibles dans la structure des tables concernees.

Requete de verification rapide :

```sql
SELECT COUNT(*) AS total_produits FROM produit;
SELECT COUNT(*) AS total_utilisateurs FROM utilisateur;
SELECT COUNT(*) AS total_commandes FROM commande;
```

## Problemes frequents

### Erreur `No database selected`

La base n'a pas ete selectionnee avant l'import.

Solution :

1. Creer la base `gestion_produits`.
2. Cliquer dessus dans phpMyAdmin.
3. Relancer l'import.

### Erreur `Table already exists`

La base contient deja des tables.

Solution simple en local :

1. Supprimer la base `gestion_produits`.
2. Recreer la base.
3. Refaire l'import.

### Erreur de port MySQL

Le projet n'arrive pas a se connecter a la base.

Solution :

1. Verifier le port MySQL de Laragon ou WAMP.
2. Mettre le meme port dans `.env`.
3. Redemarrer le serveur CodeIgniter.

### Erreur liee aux routines ou triggers

Le fichier contient des procedures stockees et des triggers.

Si phpMyAdmin affiche une erreur de privilege avec `DEFINER`, verifier que l'import est fait avec l'utilisateur `root`. En environnement local Laragon/WAMP, c'est normalement le cas.

### Caracteres accentues mal affiches

Verifier que la base et les tables utilisent `utf8mb4`.

Lors de la creation de la base, choisir :

```text
utf8mb4_general_ci
```

## Lien avec l'application Android

L'application mobile ne se connecte pas directement a MySQL. Elle communique avec l'API CodeIgniter.

Flux utilise :

```text
Application Android -> API REST CodeIgniter -> Base MySQL gestion_produits
```

Depuis l'emulateur Android, l'URL API par defaut est :

```text
http://10.0.2.2:8080/AP3_Gestion_Produit_api/public/
```

Depuis le navigateur du PC, l'URL de test peut etre :

```text
http://localhost:8080/api/test
```

ou, selon la configuration Apache/Laragon :

```text
http://localhost/AP3_Gestion_Produit_api/public/api/test
```
