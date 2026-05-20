package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

public class CommandeCreationResponse {
    @SerializedName("message")
    private String message;

    @SerializedName("id_commande")
    private int idCommande;

    public String getMessage() {
        return message == null ? "" : message;
    }

    public int getIdCommande() {
        return idCommande;
    }
}
