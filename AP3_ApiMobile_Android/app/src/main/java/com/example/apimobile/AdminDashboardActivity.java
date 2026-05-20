package com.example.apimobile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AdminDashboardActivity extends AdminBaseActivity {
    private static final String TAG = "AdminDashboard";

    private TextView tvStatProduits;
    private TextView tvStatCommandes;
    private TextView tvStatUtilisateurs;
    private TextView tvStatCA;
    private Button btnGererProduits;
    private Button btnGererCommandes;
    private Button btnGererUtilisateurs;
    private Button btnLogout;

    private String accessToken = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_dashboard);

        tvStatProduits = findViewById(R.id.tvStatProduits);
        tvStatCommandes = findViewById(R.id.tvStatCommandes);
        tvStatUtilisateurs = findViewById(R.id.tvStatUtilisateurs);
        tvStatCA = findViewById(R.id.tvStatCA);
        btnGererProduits = findViewById(R.id.btnGererProduits);
        btnGererCommandes = findViewById(R.id.btnGererCommandes);
        btnGererUtilisateurs = findViewById(R.id.btnGererUtilisateurs);
        btnLogout = findViewById(R.id.btnAdminLogout);

        btnGererProduits.setOnClickListener(v ->
                startActivity(new Intent(this, AdminProduitsActivity.class)));
        btnGererCommandes.setOnClickListener(v ->
                startActivity(new Intent(this, AdminCommandesActivity.class)));
        btnGererUtilisateurs.setOnClickListener(v ->
                startActivity(new Intent(this, AdminUtilisateursActivity.class)));
        btnLogout.setOnClickListener(v -> logout());

        accessToken = requireAdminAccess();
        if (accessToken.isEmpty()) {
            return;
        }

        chargerStats();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (!accessToken.isEmpty()) {
            chargerStats();
        }
    }

    private void chargerStats() {
        Call<AdminStats> call = RetrofitClient.getApiService().getAdminStats("Bearer " + accessToken);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<AdminStats>() {
            @Override
            public void onResponse(Call<AdminStats> call, Response<AdminStats> response) {
                if (response.isSuccessful() && response.body() != null) {
                    AdminStats stats = response.body();
                    tvStatProduits.setText(String.valueOf(stats.getNbProduits()));
                    tvStatCommandes.setText(String.valueOf(stats.getNbCommandes()));
                    tvStatUtilisateurs.setText(String.valueOf(stats.getNbUtilisateurs()));
                    tvStatCA.setText(String.format(Locale.US, "%.2f EUR", stats.getChiffreAffaires()));
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                Log.e(TAG, "Erreur HTTP " + response.code() + " sur stats");
                Toast.makeText(
                        AdminDashboardActivity.this,
                        "Impossible de charger les statistiques.",
                        Toast.LENGTH_SHORT
                ).show();
            }

            @Override
            public void onFailure(Call<AdminStats> call, Throwable t) {
                Log.e(TAG, "Echec reseau stats", t);
                Toast.makeText(
                        AdminDashboardActivity.this,
                        "Erreur reseau : " + t.getMessage(),
                        Toast.LENGTH_SHORT
                ).show();
            }
        });
    }

    private void logout() {
        redirectToLogin("Deconnexion reussie.");
    }
}
