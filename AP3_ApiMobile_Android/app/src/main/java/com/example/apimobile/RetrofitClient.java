package com.example.apimobile;

import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RetrofitClient {

    // BuildConfig.API_BASE_URL vient de Gradle pour changer d'URL sans modifier
    // le code Java entre emulateur, telephone physique et release.
    private static final String BASE_URL = normalizeBaseUrl(BuildConfig.API_BASE_URL);

    private static Retrofit retrofit;
    private static ApiService apiService;

    public static Retrofit getClient() {
        if (retrofit == null) {
            // Retrofit est un singleton: une seule instance suffit pour toute
            // l'app et evite de recreer les convertisseurs a chaque ecran.
            retrofit = new Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();
        }

        return retrofit;
    }

    public static ApiService getApiService() {
        if (apiService == null) {
            apiService = getClient().create(ApiService.class);
        }

        return apiService;
    }

    public static String getBaseUrl() {
        return BASE_URL;
    }

    public static String buildUploadsUrl(String imageName) {
        if (imageName == null) {
            return "";
        }

        // Les noms d'images viennent de la BDD. On ne construit pas l'URL si la
        // valeur est vide pour laisser l'adapter afficher son placeholder.
        String sanitized = imageName.trim();
        if (sanitized.isEmpty()) {
            return "";
        }

        return BASE_URL + "uploads/" + sanitized;
    }

    private static String normalizeBaseUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            throw new IllegalStateException("API_BASE_URL ne doit pas etre vide");
        }

        // Retrofit exige que baseUrl se termine par "/".
        String trimmed = rawUrl.trim();
        return trimmed.endsWith("/") ? trimmed : trimmed + "/";
    }
}
