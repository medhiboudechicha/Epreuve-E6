package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

public class PanierMutationRequest {
    @SerializedName("id_produit")
    private final String idProduit;

    @SerializedName("quantite")
    private final Integer quantite;

    public PanierMutationRequest(String idProduit) {
        this(idProduit, null);
    }

    public PanierMutationRequest(String idProduit, Integer quantite) {
        this.idProduit = idProduit;
        this.quantite = quantite;
    }
}
