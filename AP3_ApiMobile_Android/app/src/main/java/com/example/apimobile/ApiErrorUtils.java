package com.example.apimobile;

import android.util.Log;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import retrofit2.Response;

public final class ApiErrorUtils {
    private ApiErrorUtils() {
    }

    public static String readErrorBody(Response<?> response, String tag) {
        try {
            if (response.errorBody() == null) {
                return "";
            }

            // errorBody() est un flux consommable une seule fois. Les Activities
            // doivent stocker cette chaine si elles veulent la reutiliser.
            return response.errorBody().string();
        } catch (Exception e) {
            logError(tag, "Impossible de lire errorBody", e);
            return "";
        }
    }

    public static String extractApiMessage(String errorBody, String tag) {
        if (errorBody == null || errorBody.trim().isEmpty()) {
            return "";
        }

        try {
            JsonObject jsonObject = JsonParser.parseString(errorBody).getAsJsonObject();

            // Format d'erreur courant de CodeIgniter RESTful: {"messages":{"error":"..."}}.
            if (jsonObject.has("messages") && jsonObject.get("messages").isJsonObject()) {
                JsonObject messages = jsonObject.getAsJsonObject("messages");
                if (messages.has("error") && !messages.get("error").isJsonNull()) {
                    return messages.get("error").getAsString();
                }
            }

            if (jsonObject.has("message") && !jsonObject.get("message").isJsonNull()) {
                return jsonObject.get("message").getAsString();
            }
        } catch (Exception e) {
            logError(tag, "Impossible d'extraire le message API", e);
        }

        // Si le corps n'est pas du JSON reconnu, on affiche la reponse brute.
        return errorBody;
    }

    private static void logError(String tag, String message, Exception exception) {
        try {
            Log.e(tag, message, exception);
        } catch (RuntimeException ignored) {
            // Permet l'execution des tests JVM sans runtime Android complet.
        }
    }
}
