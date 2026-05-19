# Base de donnees du projet

Ce dossier contient l'export SQL Server de la base utilisee par le site :

```text
gestion-produits-mvc/bdd/gestion_produits.sql
```

Attention : ce script supprime puis recree la base `gestion_produits`.

## 1. Importer la base avec SSMS

1. Ouvrir SQL Server Management Studio.
2. Se connecter au serveur SQL Server local.
   - Exemple Laragon/WAMP courant : `.\SQLEXPRESS`
   - Exemple du poste de developpement : `MEDHI\SQLEXPRESS03`
3. Cliquer sur `Nouvelle requete`.
4. Aller dans `Requete` puis activer `Mode SQLCMD`.
5. Ouvrir le fichier `gestion-produits-mvc/bdd/gestion_produits.sql`.
6. Cliquer sur `Executer`.
7. Verifier que la base `gestion_produits` apparait dans `Bases de donnees`.

Si la base n'apparait pas tout de suite, faire clic droit sur `Bases de donnees`, puis `Actualiser`.

## 2. Importer avec une commande

Depuis un terminal ouvert a la racine du depot :

```powershell
sqlcmd -S .\SQLEXPRESS -E -C -i gestion-produits-mvc\bdd\gestion_produits.sql
```

Adapter `.\SQLEXPRESS` si le nom du serveur SQL Server est different.

## 3. Configurer la connexion du site

Ouvrir le fichier :

```text
gestion-produits-mvc/config.php
```

Verifier la ligne de connexion :

```php
'dsn' => 'sqlsrv:Server=.\SQLEXPRESS;Database=gestion_produits;TrustServerCertificate=1',
```

Si le serveur SQL Server porte un autre nom, remplacer `.\SQLEXPRESS` par ce nom.

Pour une connexion Windows, laisser :

```php
'user' => null,
'password' => null,
```

Pour une connexion SQL Server avec identifiant et mot de passe, remplir ces deux valeurs.

## 4. Lancer avec Laragon

1. Copier le depot dans :

```text
C:\laragon\www\Epreuve-E6
```

2. Lancer Laragon.
3. Demarrer les services.
4. Ouvrir dans le navigateur :

```text
http://localhost/Epreuve-E6/gestion-produits-mvc/index.php?page=login
```

## 5. Lancer avec WAMP

1. Copier le depot dans :

```text
C:\wamp64\www\Epreuve-E6
```

2. Lancer WAMP.
3. Verifier que l'icone WAMP est verte.
4. Ouvrir dans le navigateur :

```text
http://localhost/Epreuve-E6/gestion-produits-mvc/index.php?page=login
```

## 6. Comptes de test

Compte administrateur :

```text
Email : admin@demo.fr
Mot de passe : admin123
```

Compte utilisateur :

```text
Email : user@demo.fr
Mot de passe : user123
```

## Problemes frequents

Erreur `could not find driver` :
installer ou activer les extensions PHP `sqlsrv` et `pdo_sqlsrv`, puis redemarrer Laragon ou WAMP.

Erreur de connexion SQL Server :
verifier le nom du serveur dans SSMS, puis reporter le meme nom dans `gestion-produits-mvc/config.php`.

Page introuvable :
verifier que le depot est bien place dans le dossier `www` de Laragon ou WAMP.
