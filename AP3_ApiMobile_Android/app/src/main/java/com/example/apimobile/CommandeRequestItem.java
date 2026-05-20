package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

public class CommandeRequestItem {
    @SerializedName("id_produit")
    private final String idProduit;

    @SerializedName("quantite")
    private final int quantite;

    public CommandeRequestItem(String idProduit, int quantite) {
        this.idProduit = idProduit;
        this.quantite = quantite;
    }
}
