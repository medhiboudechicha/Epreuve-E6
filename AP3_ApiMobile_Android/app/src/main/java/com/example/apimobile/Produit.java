package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class Produit implements Serializable {
    private static final long serialVersionUID = 1L;

    @SerializedName("id_produit")
    private String idProduit;

    @SerializedName("nom")
    private String nom;

    @SerializedName("description")
    private String description;

    @SerializedName("prix")
    private String prix;

    @SerializedName("stock")
    private String stock;

    @SerializedName("image")
    private String image;

    public String getIdProduit() {
        return idProduit == null ? "" : idProduit;
    }

    public String getNom() {
        return nom == null ? "" : nom;
    }

    public String getDescription() {
        return description == null ? "" : description;
    }

    public String getPrix() {
        return prix == null ? "" : prix;
    }

    public String getStock() {
        return stock == null ? "" : stock;
    }

    public String getImage() {
        return image == null ? "" : image;
    }

    public boolean hasImage() {
        return !getImage().isEmpty();
    }
}
