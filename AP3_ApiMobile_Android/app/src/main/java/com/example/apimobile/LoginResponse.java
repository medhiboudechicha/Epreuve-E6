package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

public class LoginResponse {
    @SerializedName("access_token")
    private String accessToken;

    public String getAccessToken() {
        return accessToken;
    }

    public boolean hasAccessToken() {
        return accessToken != null && !accessToken.trim().isEmpty();
    }
}
