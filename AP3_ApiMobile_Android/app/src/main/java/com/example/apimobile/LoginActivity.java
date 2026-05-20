package com.example.apimobile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import org.json.JSONObject;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * LoginActivity — ecran de connexion de l'application.
 *
 * L'utilisateur saisit son email et son mot de passe.
 * En cas de succes, le token JWT est sauvegarde via SessionManager
 * et l'utilisateur est redirige vers MainActivity.
 */
public class LoginActivity extends AppCompatActivity {
    private static final String TAG = "LoginActivity";

    private EditText etEmail;    // Champ de saisie de l'email
    private EditText etPassword; // Champ de saisie du mot de passe
    private Button btnLogin;     // Bouton de connexion
    private TextView tvResultat; // Affiche le resultat de la tentative de connexion

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        // Liaison des vues avec les elements du layout XML
        etEmail = findViewById(R.id.etEmail);
        etPassword = findViewById(R.id.etPassword);
        btnLogin = findViewById(R.id.btnLogin);
        tvResultat = findViewById(R.id.tvResultat);

        // Le clic sur le bouton declenche la tentative de connexion
        btnLogin.setOnClickListener(v -> faireConnexion());
    }

    /**
     * Tente de connecter l'utilisateur via l'API.
     * Valide d'abord les champs, puis envoie la requete POST /api/login.
     */
    private void faireConnexion() {
        String email = etEmail.getText().toString().trim();
        String password = etPassword.getText().toString().trim();

        // Validation locale : les deux champs sont obligatoires
        if (email.isEmpty() || password.isEmpty()) {
            tvResultat.setText("Veuillez remplir tous les champs.");
            return;
        }

        setLoading(true); // desactive le bouton et affiche "Connexion en cours..."

        // Construction de la requete et appel API
        LoginRequest request = new LoginRequest(email, password);
        ApiService apiService = RetrofitClient.getApiService();
        Call<LoginResponse> call = apiService.login(request);

        Log.d(TAG, "POST " + call.request().url());

        call.enqueue(new Callback<LoginResponse>() {
            @Override
            public void onResponse(Call<LoginResponse> call, Response<LoginResponse> response) {
                setLoading(false);

                // Connexion reussie : on stocke le token, on extrait le role, puis on redirige
                if (response.isSuccessful() && response.body() != null && response.body().hasAccessToken()) {
                    String token = response.body().getAccessToken();
                    SessionManager.saveAccessToken(LoginActivity.this, token);

                    // Decodage du payload JWT (partie centrale, base64) pour recuperer le role
                    String role = extractRoleFromJwt(token);
                    SessionManager.saveRole(LoginActivity.this, role);

                    tvResultat.setText("Connexion reussie.");
                    Log.d(TAG, "Connexion reussie, token stocke. Role: " + role);

                    // Redirection selon le role : admin -> tableau de bord admin, sinon -> catalogue
                    Class<?> destination = SessionManager.isPrivilegedRole(role)
                            ? AdminDashboardActivity.class
                            : MainActivity.class;
                    Intent intent = new Intent(LoginActivity.this, destination);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    startActivity(intent);
                    finish();
                    return;
                }

                // Reponse 2xx mais sans token : probleme cote API
                if (response.isSuccessful()) {
                    tvResultat.setText("Reponse API invalide : access_token manquant.");
                    Log.e(TAG, "Reponse 2xx sans access_token sur " + call.request().url());
                    return;
                }

                // Reponse HTTP en erreur (401, 404, 500...)
                String errorBody = readErrorBody(response);
                tvResultat.setText(buildHttpErrorMessage(response.code(), errorBody));
                Log.e(TAG, "Erreur HTTP " + response.code() + " sur " + call.request().url());
                Log.e(TAG, "errorBody = " + errorBody);
            }

            @Override
            public void onFailure(Call<LoginResponse> call, Throwable t) {
                // Echec reseau (pas d'internet, serveur inaccessible, timeout...)
                setLoading(false);

                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                tvResultat.setText("Echec de connexion reseau : " + message);
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
            }
        });
    }

    /**
     * Active ou desactive l'etat de chargement de l'interface.
     * @param isLoading true pendant l'appel API, false quand la reponse est recue
     */
    private void setLoading(boolean isLoading) {
        btnLogin.setEnabled(!isLoading); // evite un double envoi si l'utilisateur reclique

        if (isLoading) {
            tvResultat.setText("Connexion en cours...");
        }
    }

    /**
     * Lit le corps de la reponse d'erreur HTTP.
     * Retourne "" si le corps est absent ou si une exception survient.
     */
    private String readErrorBody(Response<?> response) {
        try {
            if (response.errorBody() == null) {
                return "";
            }

            return response.errorBody().string();
        } catch (Exception e) {
            Log.e(TAG, "Impossible de lire errorBody", e);
            return "";
        }
    }

    /**
     * Construit un message d'erreur lisible en fonction du code HTTP et du corps de l'erreur.
     *
     * @param httpCode code HTTP de la reponse (ex: 401, 404, 500)
     * @param errorBody corps JSON de l'erreur retourne par l'API
     * @return message a afficher a l'utilisateur
     */
    private String buildHttpErrorMessage(int httpCode, String errorBody) {
        String apiMessage = extractApiMessage(errorBody); // tente d'extraire le champ "message" du JSON

        if (httpCode == 401) {
            // Mauvais identifiants
            return apiMessage.isEmpty() ? "Identifiants incorrects." : apiMessage;
        }

        if (httpCode == 404) {
            // Route inexistante : probablement une mauvaise URL de base
            return "Route API introuvable. Verifie l'URL " + RetrofitClient.getBaseUrl() + "api/login";
        }

        if (httpCode >= 500) {
            // Erreur serveur : verifier que Laragon et CI4 sont bien lances
            return apiMessage.isEmpty() ? "Erreur serveur. Verifie CodeIgniter et Laragon." : apiMessage;
        }

        if (!apiMessage.isEmpty()) {
            return apiMessage;
        }

        return "Erreur HTTP " + httpCode;
    }

    /**
     * Extrait le champ "role" du payload d'un token JWT.
     * Un JWT est compose de 3 parties separees par des points : header.payload.signature.
     * Le payload est encode en base64 URL-safe et contient les claims dont le role.
     *
     * @param token le token JWT complet
     * @return "admin", "utilisateur", ou "" si le decodage echoue
     */
    private String extractRoleFromJwt(String token) {
        try {
            // Le payload est la 2e partie du token (index 1 apres split sur ".")
            String[] parts = token.split("\\.");
            if (parts.length < 2) {
                return "";
            }

            // Decodage base64 URL-safe (JWT utilise base64url, pas base64 standard)
            byte[] decodedBytes = Base64.decode(parts[1], Base64.URL_SAFE | Base64.NO_PADDING);
            String payloadJson = new String(decodedBytes, "UTF-8");

            JSONObject payload = new JSONObject(payloadJson);
            return payload.optString("role", "");
        } catch (Exception e) {
            Log.e(TAG, "Impossible de decoder le role depuis le JWT", e);
            return "";
        }
    }

    /**
     * Tente d'extraire le champ "message" ou "messages.error" du JSON de l'erreur API.
     * Retourne le corps brut si le JSON est invalide, ou "" si le corps est vide.
     *
     * @param errorBody corps de l'erreur HTTP sous forme de chaine JSON
     * @return message extrait ou "" si impossible
     */
    private String extractApiMessage(String errorBody) {
        if (errorBody == null || errorBody.trim().isEmpty()) {
            return "";
        }

        try {
            JSONObject jsonObject = new JSONObject(errorBody);

            // Format CI4 avec cle "messages" -> { "error": "..." }
            if (jsonObject.has("messages")) {
                JSONObject messages = jsonObject.getJSONObject("messages");

                if (messages.has("error")) {
                    return messages.getString("error");
                }
            }

            // Format generique avec cle "message"
            if (jsonObject.has("message")) {
                return jsonObject.getString("message");
            }
        } catch (Exception e) {
            Log.e(TAG, "Impossible d'extraire le message API", e);
        }

        // Retour du corps brut si aucun champ connu n'a ete trouve
        return errorBody;
    }
}
