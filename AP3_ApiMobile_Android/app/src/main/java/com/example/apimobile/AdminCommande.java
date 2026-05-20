package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * AdminCommande — modèle d'une commande vue côté admin.
 * Contient les mêmes champs que Commande + les informations du client (nom, prénom, email).
 * Utilisé pour les appels à GET /api/admin/commandes et GET /api/admin/commandes/:id.
 */
public class AdminCommande {

    @SerializedName("id_commande")
    private int idCommande;

    @SerializedName("date_commande")
    private String dateCommande;

    @SerializedName("quantite")
    private int quantite;

    @SerializedName("total_montant")
    private double totalMontant;

    // Informations du client associé à la commande
    @SerializedName("id_utilisateur")
    private int idUtilisateur;

    @SerializedName("nom")
    private String nom;

    @SerializedName("prenom")
    private String prenom;

    @SerializedName("email")
    private String email;

    // Lignes de la commande (présentes uniquement dans le détail)
    @SerializedName("lignes")
    private List<LigneCommande> lignes;

    public int getIdCommande() {
        return idCommande;
    }

    public String getDateCommande() {
        return dateCommande == null ? "" : dateCommande;
    }

    public int getQuantite() {
        return quantite;
    }

    public double getTotalMontant() {
        return totalMontant;
    }

    public int getIdUtilisateur() {
        return idUtilisateur;
    }

    public String getNom() {
        return nom == null ? "" : nom;
    }

    public String getPrenom() {
        return prenom == null ? "" : prenom;
    }

    public String getEmail() {
        return email == null ? "" : email;
    }

    /** Retourne le nom complet du client (prénom + nom). */
    public String getNomComplet() {
        return (getPrenom() + " " + getNom()).trim();
    }

    public List<LigneCommande> getLignes() {
        return lignes == null ? new ArrayList<>() : lignes;
    }
}
