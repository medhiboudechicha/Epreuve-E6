package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class PanierResponse {
    @SerializedName("message")
    private String message;

    @SerializedName("items")
    private List<PanierItem> items;

    @SerializedName("total_montant")
    private double totalMontant;

    @SerializedName("total_quantite")
    private int totalQuantite;

    public String getMessage() {
        return message == null ? "" : message;
    }

    public List<PanierItem> getItems() {
        return items == null ? new ArrayList<>() : items;
    }

    public double getTotalMontant() {
        return totalMontant;
    }

    public int getTotalQuantite() {
        return totalQuantite;
    }
}
