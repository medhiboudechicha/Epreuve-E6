package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

public class PanierItem {
    @SerializedName("id_produit")
    private String produitId;

    @SerializedName("nom")
    private String nom;

    @SerializedName("description")
    private String description;

    @SerializedName("prix")
    private double prix;

    @SerializedName("image")
    private String image;

    @SerializedName("quantite")
    private int quantite;

    @SerializedName("sous_total")
    private double sousTotal;

    public String getProduitId() {
        return produitId == null ? "" : produitId;
    }

    public String getNom() {
        return nom == null ? "" : nom;
    }

    public String getDescription() {
        return description == null ? "" : description;
    }

    public double getPrixUnitaire() {
        return prix;
    }

    public String getImage() {
        return image == null ? "" : image;
    }

    public int getQuantite() {
        return Math.max(quantite, 0);
    }

    public String getPanierKey() {
        if (!getProduitId().isEmpty()) {
            return getProduitId();
        }

        return getNom();
    }

    public double getSousTotal() {
        if (sousTotal > 0d) {
            return sousTotal;
        }

        return getPrixUnitaire() * getQuantite();
    }
}
