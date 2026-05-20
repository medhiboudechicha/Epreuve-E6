package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class CommandeRequest {
    @SerializedName("items")
    private final List<CommandeRequestItem> items;

    public CommandeRequest(List<CommandeRequestItem> items) {
        this.items = items;
    }
}
