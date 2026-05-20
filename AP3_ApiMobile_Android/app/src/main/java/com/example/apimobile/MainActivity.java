package com.example.apimobile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * MainActivity — ecran principal de l'application.
 *
 * Affiche la liste des produits recuperes depuis l'API.
 * Si l'utilisateur n'est pas connecte (pas de token), il est redirige vers LoginActivity.
 * Depuis cet ecran, l'utilisateur peut acceder au panier, a ses commandes ou se deconnecter.
 */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";

    // Vues de l'interface
    private TextView tvStatus;       // Affiche le statut du chargement ou des erreurs
    private TextView tvEmpty;        // Affiche un message quand la liste est vide
    private ProgressBar progressBar; // Indicateur de chargement
    private Button btnMesCommandes;  // Bouton vers la liste des commandes
    private Button btnPanier;        // Bouton vers le panier
    private Button btnLogout;        // Bouton de deconnexion
    private RecyclerView rvProduits; // Liste des produits

    private ProduitAdapter produitAdapter; // Adaptateur qui lie les donnees produits au RecyclerView
    private String accessToken;            // Token JWT de l'utilisateur connecte

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Recuperation des vues depuis le layout XML
        tvStatus = findViewById(R.id.tvStatus);
        tvEmpty = findViewById(R.id.tvEmpty);
        progressBar = findViewById(R.id.progressBar);
        btnMesCommandes = findViewById(R.id.btnMesCommandes);
        btnPanier = findViewById(R.id.btnPanier);
        btnLogout = findViewById(R.id.btnLogout);
        rvProduits = findViewById(R.id.rvProduits);

        // Initialisation du RecyclerView avec un adaptateur vertical
        produitAdapter = new ProduitAdapter(this::openProduitDetail); // clic sur un produit -> detail
        rvProduits.setLayoutManager(new LinearLayoutManager(this));
        rvProduits.setAdapter(produitAdapter);

        // Association des boutons a leurs actions
        btnMesCommandes.setOnClickListener(v -> openMesCommandes());
        btnPanier.setOnClickListener(v -> openPanier());
        btnLogout.setOnClickListener(v -> logout());

        // Lecture du token JWT stocke localement
        accessToken = SessionManager.getAccessToken(this);

        // Si aucun token n'est present, l'utilisateur doit se reconnecter
        if (accessToken.isEmpty()) {
            redirectToLogin("Aucun token trouve. Connecte-toi.");
            return;
        }

        // On affiche seulement les 20 premiers caracteres du token dans les logs (securite)
        Log.d(TAG, "Token recupere depuis SharedPreferences: " + accessToken.substring(0, Math.min(20, accessToken.length())) + "...");
        tvStatus.setText("Token charge. Chargement des produits...");

        // Lancement du chargement des produits via l'API
        chargerProduits();
    }

    /**
     * Charge la liste des produits depuis l'API et met a jour l'interface.
     * L'appel est asynchrone (enqueue) : il ne bloque pas le thread principal.
     */
    private void chargerProduits() {
        showLoading(true);

        // Construction de la requete GET /api/produits avec le token dans le header Authorization
        Call<List<Produit>> call = RetrofitClient.getApiService().getProduits("Bearer " + accessToken);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<List<Produit>>() {
            @Override
            public void onResponse(Call<List<Produit>> call, Response<List<Produit>> response) {
                showLoading(false);

                if (response.isSuccessful() && response.body() != null) {
                    List<Produit> produits = response.body();
                    produitAdapter.setProduits(produits); // met a jour le RecyclerView

                    if (produits.isEmpty()) {
                        // L'API a repondu mais sans aucun produit
                        tvStatus.setText("Aucun produit recupere.");
                        tvEmpty.setVisibility(View.VISIBLE);
                        rvProduits.setVisibility(View.GONE);
                        return;
                    }

                    // Affichage normal de la liste
                    tvStatus.setText(produits.size() + " produit(s) charges.");
                    tvEmpty.setVisibility(View.GONE);
                    rvProduits.setVisibility(View.VISIBLE);
                    return;
                }

                // Reponse HTTP en erreur (4xx, 5xx)
                String errorBody = readErrorBody(response);
                Log.e(TAG, "Erreur HTTP " + response.code() + " sur " + call.request().url());
                Log.e(TAG, "errorBody = " + errorBody);

                if (response.code() == 401) {
                    // Token expire ou invalide : deconnexion forcee
                    logout("Session expiree ou token invalide. Reconnecte-toi.");
                    return;
                }

                tvStatus.setText("Erreur API produits : HTTP " + response.code());
                tvEmpty.setText(errorBody.isEmpty() ? "Impossible de charger les produits." : errorBody);
                tvEmpty.setVisibility(View.VISIBLE);
                rvProduits.setVisibility(View.GONE);
            }

            @Override
            public void onFailure(Call<List<Produit>> call, Throwable t) {
                // Echec reseau : pas de connexion, timeout, etc.
                showLoading(false);

                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                tvStatus.setText("Echec reseau lors du chargement des produits.");
                tvEmpty.setText(message);
                tvEmpty.setVisibility(View.VISIBLE);
                rvProduits.setVisibility(View.GONE);
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
            }
        });
    }

    /**
     * Affiche ou masque l'indicateur de chargement.
     * Desactive aussi les boutons pendant le chargement pour eviter les doubles appels.
     */
    private void showLoading(boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);
        btnMesCommandes.setEnabled(!isLoading);
        btnPanier.setEnabled(!isLoading);
        btnLogout.setEnabled(!isLoading);
        if (isLoading) {
            rvProduits.setVisibility(View.GONE);
            tvEmpty.setVisibility(View.GONE);
        }
    }

    /** Deconnexion avec message par defaut. */
    private void logout() {
        logout("Deconnexion reussie.");
    }

    /**
     * Efface la session locale et redirige vers l'ecran de connexion.
     * @param message message a afficher a l'utilisateur (Toast)
     */
    private void logout(String message) {
        SessionManager.clearSession(this); // supprime le token JWT en local
        redirectToLogin(message);
    }

    /** Ouvre le detail d'un produit clique dans la liste. */
    private void openProduitDetail(Produit produit) {
        Intent intent = new Intent(this, DetailProduitActivity.class);
        intent.putExtra(DetailProduitActivity.EXTRA_PRODUIT, produit); // passage du produit via l'intent
        startActivity(intent);
    }

    /** Ouvre l'ecran du panier. */
    private void openPanier() {
        Intent intent = new Intent(this, PanierActivity.class);
        startActivity(intent);
    }

    /** Ouvre l'ecran de la liste des commandes. */
    private void openMesCommandes() {
        Intent intent = new Intent(this, MesCommandesActivity.class);
        startActivity(intent);
    }

    /**
     * Lit le corps de la reponse d'erreur HTTP (utile pour afficher le message de l'API).
     * Retourne "" si le corps est absent ou illisible.
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
     * Redirige vers LoginActivity en effacant la pile d'activites.
     * L'utilisateur ne peut pas revenir en arriere avec le bouton Retour.
     */
    private void redirectToLogin(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();

        Intent intent = new Intent(this, LoginActivity.class);
        // FLAG_ACTIVITY_NEW_TASK | FLAG_ACTIVITY_CLEAR_TASK : vide la pile d'activites
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }
}
