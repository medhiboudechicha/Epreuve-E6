package com.example.apimobile;

import android.content.Context;
import android.content.SharedPreferences;

public final class SessionManager {

    // Ce fichier de preferences est exclu des backups Android dans res/xml.
    // Il contient le token JWT et le role courant.
    private static final String PREFS_NAME = "auth_prefs";
    private static final String KEY_ACCESS_TOKEN = "access_token";
    private static final String KEY_ROLE = "user_role";

    private SessionManager() {
    }

    public static void saveAccessToken(Context context, String accessToken) {
        SharedPreferences preferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        preferences.edit().putString(KEY_ACCESS_TOKEN, accessToken).apply();
    }

    public static String getAccessToken(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return preferences.getString(KEY_ACCESS_TOKEN, "");
    }

    public static boolean hasAccessToken(Context context) {
        return !getAccessToken(context).isEmpty();
    }

    public static void saveRole(Context context, String role) {
        SharedPreferences preferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        preferences.edit().putString(KEY_ROLE, role).apply();
    }

    public static String getRole(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return preferences.getString(KEY_ROLE, "");
    }

    public static boolean isPrivilegedRole(String role) {
        // L'app accepte superadmin comme l'API. Les vrais droits restent
        // verifies cote serveur a chaque endpoint admin.
        return "admin".equals(role) || "superadmin".equals(role);
    }

    public static boolean isAdmin(Context context) {
        return isPrivilegedRole(getRole(context));
    }

    public static void clearSession(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        // Nettoyage centralise pour eviter qu'un ancien role admin survive apres
        // une deconnexion ou un token expire.
        preferences.edit()
                .remove(KEY_ACCESS_TOKEN)
                .remove(KEY_ROLE)
                .apply();
    }
}
