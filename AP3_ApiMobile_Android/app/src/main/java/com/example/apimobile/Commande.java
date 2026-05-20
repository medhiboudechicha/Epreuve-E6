package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class Commande {
    @SerializedName("id_commande")
    private int idCommande;

    @SerializedName("date_commande")
    private String dateCommande;

    @SerializedName("quantite")
    private int quantite;

    @SerializedName("id_utilisateur")
    private String idUtilisateur;

    @SerializedName("total_montant")
    private double totalMontant;

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

    public String getIdUtilisateur() {
        return idUtilisateur == null ? "" : idUtilisateur;
    }

    public double getTotalMontant() {
        return totalMontant;
    }

    public List<LigneCommande> getLignes() {
        return lignes == null ? new ArrayList<>() : lignes;
    }
}
