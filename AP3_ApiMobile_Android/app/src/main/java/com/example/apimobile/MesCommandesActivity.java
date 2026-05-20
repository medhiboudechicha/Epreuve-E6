package com.example.apimobile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
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
 * MesCommandesActivity — ecran listant l'historique des commandes de l'utilisateur.
 *
 * Charge la liste des commandes depuis l'API au demarrage et a chaque retour sur cet ecran.
 * Un clic sur une commande ouvre son detail dans DetailCommandeActivity.
 */
public class MesCommandesActivity extends AppCompatActivity {
    private static final String TAG = "MesCommandesActivity";

    private TextView tvStatus;       // Affiche le statut ou le nombre de commandes chargees
    private TextView tvEmpty;        // Message affiché si aucune commande n'existe
    private ProgressBar progressBar; // Indicateur de chargement
    private RecyclerView rvCommandes; // Liste des commandes
    private CommandeAdapter commandeAdapter; // Adaptateur qui lie les donnees au RecyclerView
    private String accessToken; // Token JWT de la session

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mes_commandes);

        // Liaison des vues avec le layout XML
        tvStatus = findViewById(R.id.tvMesCommandesStatus);
        tvEmpty = findViewById(R.id.tvMesCommandesEmpty);
        progressBar = findViewById(R.id.progressMesCommandes);
        rvCommandes = findViewById(R.id.rvMesCommandes);

        // Initialisation du RecyclerView : clic sur une commande -> detail
        commandeAdapter = new CommandeAdapter(this::openCommandeDetail);
        rvCommandes.setLayoutManager(new LinearLayoutManager(this));
        rvCommandes.setAdapter(commandeAdapter);
    }

    @Override
    protected void onResume() {
        super.onResume();

        // Lecture du token a chaque reprise (l'utilisateur peut revenir depuis le detail d'une commande)
        accessToken = SessionManager.getAccessToken(this);
        if (accessToken.isEmpty()) {
            redirectToLogin("Session absente. Connecte-toi.");
            return;
        }

        chargerCommandes();
    }

    /**
     * Charge la liste des commandes depuis l'API et met a jour l'interface.
     * Appel asynchrone : ne bloque pas le thread principal.
     */
    private void chargerCommandes() {
        showLoading(true);
        Call<List<Commande>> call = RetrofitClient.getApiService().getCommandes("Bearer " + accessToken);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<List<Commande>>() {
            @Override
            public void onResponse(Call<List<Commande>> call, Response<List<Commande>> response) {
                showLoading(false);

                if (response.isSuccessful() && response.body() != null) {
                    List<Commande> commandes = response.body();
                    commandeAdapter.setCommandes(commandes); // met a jour le RecyclerView

                    if (commandes.isEmpty()) {
                        // L'utilisateur n'a encore passe aucune commande
                        tvStatus.setText("Aucune commande.");
                        tvEmpty.setText("Vous n'avez encore passe aucune commande.");
                        tvEmpty.setVisibility(View.VISIBLE);
                        rvCommandes.setVisibility(View.GONE);
                        return;
                    }

                    // Affichage normal de la liste
                    tvStatus.setText(commandes.size() + " commande(s) chargee(s).");
                    tvEmpty.setVisibility(View.GONE);
                    rvCommandes.setVisibility(View.VISIBLE);
                    return;
                }

                // Erreur HTTP
                String errorBody = ApiErrorUtils.readErrorBody(response, TAG);
                Log.e(TAG, "Erreur HTTP " + response.code() + " sur " + call.request().url());
                Log.e(TAG, "errorBody = " + errorBody);

                if (response.code() == 401) {
                    // Token expire : deconnexion forcee
                    SessionManager.clearSession(MesCommandesActivity.this);
                    redirectToLogin("Session expiree ou token invalide. Reconnecte-toi.");
                    return;
                }

                String apiMessage = ApiErrorUtils.extractApiMessage(errorBody, TAG);
                tvStatus.setText("Impossible de charger les commandes.");
                tvEmpty.setText(apiMessage.isEmpty() ? "Erreur HTTP " + response.code() : apiMessage);
                tvEmpty.setVisibility(View.VISIBLE);
                rvCommandes.setVisibility(View.GONE);
            }

            @Override
            public void onFailure(Call<List<Commande>> call, Throwable t) {
                // Echec reseau (pas de connexion, serveur inaccessible...)
                showLoading(false);

                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                tvStatus.setText("Echec reseau.");
                tvEmpty.setText(message);
                tvEmpty.setVisibility(View.VISIBLE);
                rvCommandes.setVisibility(View.GONE);
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
            }
        });
    }

    /**
     * Affiche ou masque l'indicateur de chargement et met a jour le message de statut.
     */
    private void showLoading(boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);

        if (isLoading) {
            tvStatus.setText("Chargement des commandes...");
            tvEmpty.setVisibility(View.GONE);
            rvCommandes.setVisibility(View.GONE);
        }
    }

    /** Ouvre le detail d'une commande cliquee. Passe l'ID de la commande a l'activite suivante. */
    private void openCommandeDetail(Commande commande) {
        Intent intent = new Intent(this, DetailCommandeActivity.class);
        intent.putExtra(DetailCommandeActivity.EXTRA_COMMANDE_ID, commande.getIdCommande());
        startActivity(intent);
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
