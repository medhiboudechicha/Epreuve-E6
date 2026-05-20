# AP3 ApiMobile Android

Application mobile Android native Java pour le projet AP3 Gestion Produit.

L'application consomme l'API REST CodeIgniter 4 du dossier `AP3_Gestion_Produit_API/`. Elle permet de se connecter, consulter les produits, gerer un panier, passer des commandes et utiliser les ecrans d'administration avec un compte admin.

## Contenu du dossier

- `app/src/main/java/` : code Java de l'application.
- `app/src/main/res/` : layouts, themes, drawables et ressources Android.
- `app/build.gradle.kts` : configuration du module Android, dependances et URL API par defaut.
- `gradle/`, `gradlew`, `gradlew.bat` : wrapper Gradle pour lancer le projet sans installer Gradle manuellement.

Les dossiers generes (`build/`, `.gradle/`, `.idea/`) et le fichier local `local.properties` ne sont pas versionnes.

## Prerequis

1. Installer Android Studio.
2. Installer le SDK Android demande par le projet si Android Studio le propose pendant la synchronisation Gradle.
3. Avoir un emulateur Android configure, ou un telephone Android branche en USB avec le mode developpeur active.
4. Avoir le backend `AP3_Gestion_Produit_API/` installe et une base `gestion_produits` importee.

## Importer le projet dans Android Studio

1. Ouvrir Android Studio.
2. Cliquer sur `File > Open`.
3. Selectionner le dossier `AP3_ApiMobile_Android`.
4. Valider avec `OK` ou `Open`.
5. Attendre la fin du `Gradle Sync`.
6. Si Android Studio demande d'installer un SDK ou des outils Gradle, accepter.
7. Choisir un emulateur ou un telephone dans la liste des appareils.
8. Cliquer sur `Run`.

Ne pas ouvrir directement le dossier `app/`. Il faut ouvrir le dossier racine `AP3_ApiMobile_Android`, sinon Android Studio ne charge pas correctement Gradle.

## Configurer l'API

L'URL de l'API est injectee dans l'application via `BuildConfig.API_BASE_URL`.

URL par defaut dans `app/build.gradle.kts` :

```properties
http://10.0.2.2:8080/AP3_Gestion_Produit_api/public/
```

Cette URL correspond a un emulateur Android qui appelle le serveur local du PC via `10.0.2.2`.

### Cas 1 : Laragon ou WAMP avec Apache

1. Placer ou cloner le backend dans le dossier web local, par exemple :

```text
C:\laragon\www\AP3_Gestion_Produit_api
```

2. Lancer Apache et MySQL dans Laragon ou WAMP.
3. Importer la base avec le guide :

```text
AP3_Gestion_Produit_API/bdd/README.md
```

4. Tester l'API dans le navigateur du PC :

```text
http://localhost:8080/AP3_Gestion_Produit_api/public/api/test
```

5. Depuis un emulateur Android, utiliser :

```properties
api.baseUrl=http://10.0.2.2:8080/AP3_Gestion_Produit_api/public/
```

Si Apache tourne sur le port 80, enlever `:8080` :

```properties
api.baseUrl=http://10.0.2.2/AP3_Gestion_Produit_api/public/
```

### Cas 2 : serveur CodeIgniter avec php spark serve

Depuis le dossier backend :

```powershell
php spark serve --host 0.0.0.0 --port 8080
```

Tester sur le PC :

```text
http://127.0.0.1:8080/api/test
```

Dans Android, utiliser cette URL :

```properties
api.baseUrl=http://10.0.2.2:8080/
```

### Changer l'URL sans modifier le code

Creer ou modifier le fichier `local.properties` a la racine du projet Android :

```properties
api.baseUrl=http://10.0.2.2:8080/AP3_Gestion_Produit_api/public/
```

Le fichier `local.properties` reste local au poste de developpement et ne doit pas etre commit.

Il est aussi possible de passer l'URL en ligne de commande :

```powershell
.\gradlew.bat assembleDebug -PapiBaseUrl=http://10.0.2.2:8080/
```

## Telephone physique

Sur un telephone physique, `10.0.2.2` ne fonctionne pas. Il faut utiliser l'adresse IP locale du PC.

Exemple :

```properties
api.baseUrl=http://192.168.1.25:8080/AP3_Gestion_Produit_api/public/
```

Conditions :

1. Le PC et le telephone doivent etre sur le meme reseau Wi-Fi.
2. Le pare-feu Windows doit autoriser Apache, WAMP/Laragon ou PHP.
3. Le backend doit ecouter sur une adresse accessible depuis le reseau.

## Comptes de test

- Administrateur : `jean.dupont@example.com` / `azerty123`
- Utilisateur : `marie.durand@example.com` / `mdp123`

## Lancer les tests

Depuis `AP3_ApiMobile_Android/` :

```powershell
.\gradlew.bat test
```

Si Gradle ne trouve pas Java, utiliser le JDK integre a Android Studio :

```powershell
$env:JAVA_HOME='C:\Program Files\Android\Android Studio\jbr'
$env:Path="$env:JAVA_HOME\bin;$env:Path"
.\gradlew.bat test
```

Si Gradle ne trouve pas le SDK Android, ouvrir une fois le projet dans Android Studio pour laisser l'IDE creer `local.properties`, ou definir le SDK dans le terminal :

```powershell
$env:ANDROID_HOME="$env:LOCALAPPDATA\Android\Sdk"
$env:ANDROID_SDK_ROOT=$env:ANDROID_HOME
.\gradlew.bat test
```

## Depannage

- Ecran qui charge en boucle : verifier que l'API repond bien depuis le navigateur du PC, puis verifier `api.baseUrl`.
- Erreur `CLEARTEXT communication not permitted` : le projet autorise deja le HTTP avec `android:usesCleartextTraffic="true"`.
- Erreur `Connection refused` sur emulateur : remplacer `localhost` par `10.0.2.2`.
- Erreur sur telephone physique : remplacer `10.0.2.2` par l'adresse IP locale du PC.
- Erreur `SDK location not found` : ouvrir le projet avec Android Studio ou definir `ANDROID_HOME`.
- Erreur `401` ou retour connexion refusee : verifier les identifiants et la valeur `JWT_SECRET` cote API.
- Images absentes : verifier que les images existent dans `AP3_Gestion_Produit_API/public/uploads/`.
