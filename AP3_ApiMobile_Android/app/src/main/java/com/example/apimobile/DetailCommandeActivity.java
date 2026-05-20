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

import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DetailCommandeActivity extends AppCompatActivity {
    public static final String EXTRA_COMMANDE_ID = "extra_commande_id";

    private static final String TAG = "DetailCommandeActivity";

    private TextView tvTitre;
    private TextView tvDate;
    private TextView tvQuantite;
    private TextView tvTotal;
    private TextView tvEmpty;
    private ProgressBar progressBar;
    private RecyclerView rvLignes;
    private LigneCommandeAdapter ligneCommandeAdapter;
    private String accessToken;
    private int commandeId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail_commande);

        tvTitre = findViewById(R.id.tvDetailCommandeTitre);
        tvDate = findViewById(R.id.tvDetailCommandeDate);
        tvQuantite = findViewById(R.id.tvDetailCommandeQuantite);
        tvTotal = findViewById(R.id.tvDetailCommandeTotal);
        tvEmpty = findViewById(R.id.tvDetailCommandeEmpty);
        progressBar = findViewById(R.id.progressDetailCommande);
        rvLignes = findViewById(R.id.rvDetailCommandeLignes);

        ligneCommandeAdapter = new LigneCommandeAdapter();
        rvLignes.setLayoutManager(new LinearLayoutManager(this));
        rvLignes.setAdapter(ligneCommandeAdapter);

        commandeId = getIntent().getIntExtra(EXTRA_COMMANDE_ID, 0);
        if (commandeId <= 0) {
            Toast.makeText(this, "Commande invalide.", Toast.LENGTH_LONG).show();
            finish();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        accessToken = SessionManager.getAccessToken(this);
        if (accessToken.isEmpty()) {
            redirectToLogin("Session absente. Connecte-toi.");
            return;
        }

        chargerCommande();
    }

    private void chargerCommande() {
        showLoading(true);
        Call<Commande> call = RetrofitClient.getApiService().getCommandeDetail("Bearer " + accessToken, commandeId);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<Commande>() {
            @Override
            public void onResponse(Call<Commande> call, Response<Commande> response) {
                showLoading(false);

                if (response.isSuccessful() && response.body() != null) {
                    bindCommande(response.body());
                    return;
                }

                String errorBody = ApiErrorUtils.readErrorBody(response, TAG);
                Log.e(TAG, "Erreur HTTP " + response.code() + " sur " + call.request().url());
                Log.e(TAG, "errorBody = " + errorBody);

                if (response.code() == 401) {
                    SessionManager.clearSession(DetailCommandeActivity.this);
                    redirectToLogin("Session expiree ou token invalide. Reconnecte-toi.");
                    return;
                }

                String apiMessage = ApiErrorUtils.extractApiMessage(errorBody, TAG);
                tvEmpty.setText(apiMessage.isEmpty() ? "Impossible de charger le detail de la commande." : apiMessage);
                tvEmpty.setVisibility(View.VISIBLE);
                rvLignes.setVisibility(View.GONE);
            }

            @Override
            public void onFailure(Call<Commande> call, Throwable t) {
                showLoading(false);

                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                tvEmpty.setText(message);
                tvEmpty.setVisibility(View.VISIBLE);
                rvLignes.setVisibility(View.GONE);
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
            }
        });
    }

    private void bindCommande(Commande commande) {
        tvTitre.setText("Commande #" + commande.getIdCommande());
        tvDate.setText("Date : " + commande.getDateCommande());
        tvQuantite.setText("Articles : " + commande.getQuantite());
        tvTotal.setText("Total : " + String.format(Locale.US, "%.2f", commande.getTotalMontant()) + " EUR");

        if (commande.getLignes().isEmpty()) {
            tvEmpty.setText("Aucune ligne de commande.");
            tvEmpty.setVisibility(View.VISIBLE);
            rvLignes.setVisibility(View.GONE);
            return;
        }

        ligneCommandeAdapter.setLignes(commande.getLignes());
        tvEmpty.setVisibility(View.GONE);
        rvLignes.setVisibility(View.VISIBLE);
    }

    private void showLoading(boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);

        if (isLoading) {
            tvEmpty.setVisibility(View.GONE);
            rvLignes.setVisibility(View.GONE);
        }
    }

    private void redirectToLogin(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();

        Intent intent = new Intent(this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }
}
