# MCD - Gestion produits

Le fichier Looping du MCD est :

```text
gestion-produits-mvc/bdd/mcd_gestion_produits.loo
```

Il est a ouvrir avec l'application Looping.

Le MCD est base sur la base SQL Server `gestion_produits`.
Les tables techniques `migrations` et `sysdiagrams` ne sont pas retenues dans le MCD, car elles ne representent pas le metier de l'application.

Note : le fichier Looping `.loo` reprend le MCD principal de la base. La table SQL `panier_item`, ajoutee pour le panier, est documentee ci-dessous dans l'association `ajouter_au_panier`.

## Entites

### Utilisateur

- id_utilisateur
- nom
- prenom
- email
- mot_de_passe
- role

### Produit

- id_produit
- nom
- description
- prix
- stock
- image

### Commande

- id_commande
- date_commande
- quantite

### Auteur

- id_auteur
- nom
- description

### Genre

- id_genre
- nom

### Fournisseur

- id_fournisseur
- nom
- adresse
- email
- telephone

### Marque

- id_marque
- nom

### Produit livre

- nb_pages

Cette entite est une specialisation de `Produit`.

### Produit vetement

- taille
- couleur
- matiere

Cette entite est une specialisation de `Produit`.

### Historique

- id_historique
- date_action
- action

## Associations et cardinalites

| Association | Entite 1 | Cardinalite | Entite 2 | Cardinalite | Attributs |
| --- | --- | --- | --- | --- | --- |
| passer | Utilisateur | 0,N | Commande | 1,1 | Aucun |
| appartenir | Commande | 0,N | Produit | 0,N | quantite |
| consulter | Utilisateur | 0,N | Produit | 0,N | Aucun |
| fournir | Fournisseur | 0,N | Produit | 0,N | Aucun |
| avoir_auteur | Auteur | 0,N | Produit livre | 0,1 | Aucun |
| classer | Genre | 0,N | Produit livre | 0,N | Aucun |
| posseder_marque | Marque | 0,N | Produit vetement | 0,1 | Aucun |
| ajouter_au_panier | Utilisateur | 0,N | Produit | 0,N | quantite, created_at, updated_at |

## Schema visuel

```mermaid
erDiagram
    UTILISATEUR {
        int id_utilisateur PK
        string nom
        string prenom
        string email
        string mot_de_passe
        string role
    }

    PRODUIT {
        string id_produit PK
        string nom
        string description
        decimal prix
        int stock
        string image
    }

    COMMANDE {
        int id_commande PK
        datetime date_commande
        int quantite
    }

    APPARTENIR {
        int quantite
    }

    PANIER_ITEM {
        int id_panier_item PK
        int quantite
        datetime created_at
        datetime updated_at
    }

    AUTEUR {
        int id_auteur PK
        string nom
        string description
    }

    GENRE {
        int id_genre PK
        string nom
    }

    FOURNISSEUR {
        int id_fournisseur PK
        string nom
        string adresse
        string email
        string telephone
    }

    MARQUE {
        int id_marque PK
        string nom
    }

    PRODUIT_LIVRE {
        string id_produit PK
        int nb_pages
    }

    PRODUIT_VETEMENT {
        string id_produit PK
        string taille
        string couleur
        string matiere
    }

    HISTORIQUE {
        int id_historique PK
        datetime date_action
        string action
    }

    UTILISATEUR ||--o{ COMMANDE : passer
    COMMANDE ||--o{ APPARTENIR : contenir
    PRODUIT ||--o{ APPARTENIR : commander
    UTILISATEUR ||--o{ PANIER_ITEM : ajouter
    PRODUIT ||--o{ PANIER_ITEM : concerner
    UTILISATEUR }o--o{ PRODUIT : consulter
    FOURNISSEUR }o--o{ PRODUIT : fournir
    PRODUIT ||--o| PRODUIT_LIVRE : specialiser
    PRODUIT ||--o| PRODUIT_VETEMENT : specialiser
    AUTEUR ||--o{ PRODUIT_LIVRE : ecrire
    GENRE }o--o{ PRODUIT_LIVRE : classer
    MARQUE ||--o{ PRODUIT_VETEMENT : posseder
```
