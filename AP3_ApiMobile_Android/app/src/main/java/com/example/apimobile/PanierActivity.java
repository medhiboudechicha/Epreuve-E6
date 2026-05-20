package com.example.apimobile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * PanierActivity — ecran du panier de l'utilisateur.
 *
 * Affiche la liste des articles dans le panier avec leur quantite et prix.
 * L'utilisateur peut incrementer/decrementer les quantites ou supprimer un article.
 * Il peut aussi valider le panier pour creer une commande.
 * Le panier est rechargee depuis l'API a chaque fois que l'ecran redevient visible (onResume).
 */
public class PanierActivity extends AppCompatActivity {
    private static final String TAG = "PanierActivity";

    private TextView tvPanierVide;   // Message affiche quand le panier est vide
    private TextView tvPanierTotal;  // Affiche le total et le nombre d'articles
    private RecyclerView rvPanier;   // Liste des articles du panier
    private Button btnValiderPanier; // Bouton pour passer la commande

    private PanierAdapter panierAdapter;          // Adaptateur du RecyclerView
    private String accessToken;                   // Token JWT de la session
    private List<PanierItem> currentItems = new ArrayList<>(); // Articles actuellement dans le panier

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_panier);

        // Liaison des vues avec le layout XML
        tvPanierVide = findViewById(R.id.tvPanierVide);
        tvPanierTotal = findViewById(R.id.tvPanierTotal);
        rvPanier = findViewById(R.id.rvPanier);
        btnValiderPanier = findViewById(R.id.btnValiderPanier);

        // Initialisation de l'adaptateur avec les callbacks d'action sur les articles
        panierAdapter = new PanierAdapter(new PanierAdapter.OnPanierActionListener() {
            @Override
            public void onIncrement(PanierItem item) {
                // Augmente la quantite de 1 via l'API
                updatePanierItem(item, item.getQuantite() + 1);
            }

            @Override
            public void onDecrement(PanierItem item) {
                if (item.getQuantite() <= 1) {
                    // Si la quantite tombe a 0, on supprime l'article du panier
                    removePanierItem(item);
                    return;
                }

                // Diminue la quantite de 1 via l'API
                updatePanierItem(item, item.getQuantite() - 1);
            }

            @Override
            public void onRemove(PanierItem item) {
                // Suppression directe de l'article du panier
                removePanierItem(item);
            }
        });

        rvPanier.setLayoutManager(new LinearLayoutManager(this));
        rvPanier.setAdapter(panierAdapter);
        btnValiderPanier.setOnClickListener(v -> validerPanier());
    }

    @Override
    protected void onResume() {
        super.onResume();

        // Lecture du token a chaque reprise de l'activite (cas de retour depuis une autre activite)
        accessToken = SessionManager.getAccessToken(this);
        if (accessToken.isEmpty()) {
            redirectToLogin("Session absente. Connecte-toi.");
            return;
        }

        // Rechargement du panier depuis l'API
        chargerPanier();
    }

    /**
     * Charge le contenu du panier depuis l'API et met a jour l'interface.
     */
    private void chargerPanier() {
        btnValiderPanier.setEnabled(false); // desactive pendant le chargement
        Call<PanierResponse> call = RetrofitClient.getApiService().getPanier("Bearer " + accessToken);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<PanierResponse>() {
            @Override
            public void onResponse(Call<PanierResponse> call, Response<PanierResponse> response) {
                btnValiderPanier.setEnabled(true);

                if (response.isSuccessful() && response.body() != null) {
                    bindPanier(response.body()); // met a jour l'interface avec les donnees reçues
                    return;
                }

                handlePanierError(response, call);
            }

            @Override
            public void onFailure(Call<PanierResponse> call, Throwable t) {
                btnValiderPanier.setEnabled(true);
                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
                Toast.makeText(PanierActivity.this, message, Toast.LENGTH_LONG).show();
            }
        });
    }

    /**
     * Met a jour la quantite d'un article dans le panier via l'API.
     *
     * @param item     l'article a modifier
     * @param quantite la nouvelle quantite souhaitee
     */
    private void updatePanierItem(PanierItem item, int quantite) {
        Call<PanierResponse> call = RetrofitClient.getApiService().updatePanier(
                "Bearer " + accessToken,
                new PanierMutationRequest(item.getProduitId(), quantite)
        );
        Log.d(TAG, "POST " + call.request().url());

        call.enqueue(new Callback<PanierResponse>() {
            @Override
            public void onResponse(Call<PanierResponse> call, Response<PanierResponse> response) {
                if (response.isSuccessful() && response.body() != null) {
                    bindPanier(response.body()); // rafraichit l'affichage avec le panier mis a jour
                    return;
                }

                handlePanierError(response, call);
            }

            @Override
            public void onFailure(Call<PanierResponse> call, Throwable t) {
                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
                Toast.makeText(PanierActivity.this, message, Toast.LENGTH_LONG).show();
            }
        });
    }

    /**
     * Supprime un article du panier via l'API.
     *
     * @param item l'article a supprimer
     */
    private void removePanierItem(PanierItem item) {
        Call<PanierResponse> call = RetrofitClient.getApiService().removeFromPanier(
                "Bearer " + accessToken,
                new PanierMutationRequest(item.getProduitId()) // pas besoin de quantite pour la suppression
        );
        Log.d(TAG, "POST " + call.request().url());

        call.enqueue(new Callback<PanierResponse>() {
            @Override
            public void onResponse(Call<PanierResponse> call, Response<PanierResponse> response) {
                if (response.isSuccessful() && response.body() != null) {
                    bindPanier(response.body()); // rafraichit l'affichage
                    return;
                }

                handlePanierError(response, call);
            }

            @Override
            public void onFailure(Call<PanierResponse> call, Throwable t) {
                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
                Toast.makeText(PanierActivity.this, message, Toast.LENGTH_LONG).show();
            }
        });
    }

    /**
     * Met a jour toute l'interface a partir de la reponse de l'API.
     * Affiche ou masque la liste selon que le panier est vide ou non.
     * Calcule le total (depuis la reponse API si disponible, sinon calcul local).
     *
     * @param panierResponse reponse complete du panier retournee par l'API
     */
    private void bindPanier(PanierResponse panierResponse) {
        currentItems = panierResponse.getItems();
        panierAdapter.setItems(currentItems); // mise a jour du RecyclerView

        if (currentItems.isEmpty()) {
            // Panier vide : on affiche le message et on masque la liste
            tvPanierVide.setText("Votre panier est vide.");
            tvPanierVide.setVisibility(View.VISIBLE);
            rvPanier.setVisibility(View.GONE);
            btnValiderPanier.setEnabled(false);
        } else {
            // Panier non vide : on affiche la liste
            tvPanierVide.setVisibility(View.GONE);
            rvPanier.setVisibility(View.VISIBLE);
            btnValiderPanier.setEnabled(true);
        }

        // Priorite aux valeurs de l'API ; fallback sur le calcul local si absentes
        double total = panierResponse.getTotalMontant() > 0d
                ? panierResponse.getTotalMontant()
                : PanierManager.getTotal(currentItems);
        int nombreArticles = panierResponse.getTotalQuantite() > 0
                ? panierResponse.getTotalQuantite()
                : PanierManager.getNombreArticles(currentItems);
        tvPanierTotal.setText("Total : " + formatPrice(total) + " EUR (" + nombreArticles + " article(s))");
    }

    /**
     * Valide le panier en creant une commande via l'API.
     * En cas de succes, redirige vers le detail de la commande creee.
     */
    private void validerPanier() {
        if (currentItems.isEmpty()) {
            Toast.makeText(this, "Le panier est vide.", Toast.LENGTH_SHORT).show();
            return;
        }

        // Conversion des articles du panier en lignes de commande
        List<CommandeRequestItem> items = PanierManager.toCommandeRequestItems(currentItems);
        if (items.isEmpty()) {
            // Cas theorique : articles present mais tous invalides
            Toast.makeText(this, "Le panier est invalide.", Toast.LENGTH_LONG).show();
            return;
        }

        btnValiderPanier.setEnabled(false); // evite un double envoi
        CommandeRequest request = new CommandeRequest(items);
        Call<CommandeCreationResponse> call = RetrofitClient.getApiService().createCommande("Bearer " + accessToken, request);
        Log.d(TAG, "POST " + call.request().url());

        call.enqueue(new Callback<CommandeCreationResponse>() {
            @Override
            public void onResponse(Call<CommandeCreationResponse> call, Response<CommandeCreationResponse> response) {
                btnValiderPanier.setEnabled(true);

                if (response.isSuccessful()) {
                    // Commande creee avec succes : on vide l'affichage local du panier
                    CommandeCreationResponse body = response.body();
                    currentItems = new ArrayList<>();
                    panierAdapter.setItems(currentItems);
                    tvPanierVide.setText("Votre panier est vide.");
                    tvPanierVide.setVisibility(View.VISIBLE);
                    rvPanier.setVisibility(View.GONE);
                    tvPanierTotal.setText("Total : 0.00 EUR (0 article(s))");

                    int idCommande = body != null ? body.getIdCommande() : 0;
                    String message = body != null && !body.getMessage().isEmpty()
                            ? body.getMessage()
                            : "Commande creee avec succes.";

                    Toast.makeText(PanierActivity.this, message, Toast.LENGTH_LONG).show();

                    // Si l'API retourne un ID de commande, on ouvre directement son detail
                    if (idCommande > 0) {
                        Intent intent = new Intent(PanierActivity.this, DetailCommandeActivity.class);
                        intent.putExtra(DetailCommandeActivity.EXTRA_COMMANDE_ID, idCommande);
                        startActivity(intent);
                        finish();
                    }
                    return;
                }

                // Erreur lors de la creation de la commande
                String errorBody = ApiErrorUtils.readErrorBody(response, TAG);
                Log.e(TAG, "Erreur HTTP " + response.code() + " sur " + call.request().url());
                Log.e(TAG, "errorBody = " + errorBody);

                if (response.code() == 401) {
                    // Token expire : deconnexion forcee
                    SessionManager.clearSession(PanierActivity.this);
                    redirectToLogin("Session expiree ou token invalide. Reconnecte-toi.");
                    return;
                }

                String apiMessage = ApiErrorUtils.extractApiMessage(errorBody, TAG);
                Toast.makeText(
                        PanierActivity.this,
                        apiMessage.isEmpty() ? "Impossible de creer la commande." : apiMessage,
                        Toast.LENGTH_LONG
                ).show();
            }

            @Override
            public void onFailure(Call<CommandeCreationResponse> call, Throwable t) {
                btnValiderPanier.setEnabled(true);
                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
                Toast.makeText(PanierActivity.this, message, Toast.LENGTH_LONG).show();
            }
        });
    }

    /**
     * Gere les erreurs HTTP lors d'un appel panier (chargement, update, suppression).
     * Redirige vers le login en cas de 401, affiche un toast sinon.
     */
    private void handlePanierError(Response<PanierResponse> response, Call<PanierResponse> call) {
        String errorBody = ApiErrorUtils.readErrorBody(response, TAG);
        Log.e(TAG, "Erreur HTTP " + response.code() + " sur " + call.request().url());
        Log.e(TAG, "errorBody = " + errorBody);

        if (response.code() == 401) {
            SessionManager.clearSession(PanierActivity.this);
            redirectToLogin("Session expiree ou token invalide. Reconnecte-toi.");
            return;
        }

        String apiMessage = ApiErrorUtils.extractApiMessage(errorBody, TAG);
        Toast.makeText(
                PanierActivity.this,
                apiMessage.isEmpty() ? "Impossible de charger le panier." : apiMessage,
                Toast.LENGTH_LONG
        ).show();
    }

    /**
     * Formate un prix en deux decimales avec le point comme separateur (format US).
     * Ex: 12.5 -> "12.50"
     */
    private String formatPrice(double value) {
        return String.format(Locale.US, "%.2f", value);
    }

    /** Redirige vers l'ecran de connexion en effacant la pile d'activites. */
    private void redirectToLogin(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();

        Intent intent = new Intent(this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }
}
