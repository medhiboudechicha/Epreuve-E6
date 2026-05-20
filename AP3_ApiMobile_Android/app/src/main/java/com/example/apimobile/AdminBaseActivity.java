package com.example.apimobile;

import android.content.Intent;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public abstract class AdminBaseActivity extends AppCompatActivity {

    protected String requireAdminAccess() {
        String accessToken = SessionManager.getAccessToken(this);

        // Les ecrans admin ne doivent jamais lancer un appel API sans token ni
        // role privilegie local. L'API revalide ensuite le droit cote serveur.
        if (accessToken.isEmpty() || !SessionManager.isAdmin(this)) {
            redirectToLogin("Acces reserve aux administrateurs.");
            return "";
        }

        return accessToken;
    }

    protected boolean handleUnauthorizedResponse(int httpCode) {
        // 401 = token absent/expire, 403 = token valide mais role insuffisant.
        // Dans les deux cas, on sort de la zone admin.
        if (httpCode == 401 || httpCode == 403) {
            redirectToLogin("Session expiree ou acces refuse.");
            return true;
        }

        return false;
    }

    protected void redirectToLogin(String message) {
        // FLAG_ACTIVITY_CLEAR_TASK evite de revenir sur un ecran admin via le
        // bouton retour apres expiration de session.
        SessionManager.clearSession(this);
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();

        Intent intent = new Intent(this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }
}
