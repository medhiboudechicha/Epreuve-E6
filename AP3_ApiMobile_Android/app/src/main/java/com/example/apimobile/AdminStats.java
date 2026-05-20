package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

/**
 * AdminStats — modèle des statistiques globales retournées par GET /api/admin/stats.
 * Affiché sur le tableau de bord de l'admin (AdminDashboardActivity).
 */
public class AdminStats {

    @SerializedName("nb_produits")
    private int nbProduits;

    @SerializedName("nb_commandes")
    private int nbCommandes;

    @SerializedName("nb_utilisateurs")
    private int nbUtilisateurs;

    @SerializedName("chiffre_affaires")
    private double chiffreAffaires;

    public int getNbProduits() {
        return nbProduits;
    }

    public int getNbCommandes() {
        return nbCommandes;
    }

    public int getNbUtilisateurs() {
        return nbUtilisateurs;
    }

    public double getChiffreAffaires() {
        return chiffreAffaires;
    }
}
