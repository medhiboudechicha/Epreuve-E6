package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

public class LigneCommande {
    @SerializedName("id_produit")
    private String idProduit;

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

    public String getIdProduit() {
        return idProduit == null ? "" : idProduit;
    }

    public String getNom() {
        return nom == null ? "" : nom;
    }

    public String getDescription() {
        return description == null ? "" : description;
    }

    public double getPrix() {
        return prix;
    }

    public String getImage() {
        return image == null ? "" : image;
    }

    public int getQuantite() {
        return quantite;
    }

    public double getSousTotal() {
        return sousTotal;
    }
}
