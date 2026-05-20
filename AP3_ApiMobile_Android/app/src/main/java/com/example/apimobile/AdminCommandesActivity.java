package com.example.apimobile;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AdminCommandesActivity extends AdminBaseActivity implements AdminCommandeAdapter.OnCommandeAdminListener {
    private static final String TAG = "AdminCommandes";

    private ProgressBar progressBar;
    private TextView tvStatus;
    private TextView tvEmpty;
    private RecyclerView rvCommandes;
    private AdminCommandeAdapter adapter;
    private String accessToken = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_commandes);

        progressBar = findViewById(R.id.progressAdminCommandes);
        tvStatus = findViewById(R.id.tvAdminCommandesStatus);
        tvEmpty = findViewById(R.id.tvAdminCommandesEmpty);
        rvCommandes = findViewById(R.id.rvAdminCommandes);

        adapter = new AdminCommandeAdapter(this);
        rvCommandes.setLayoutManager(new LinearLayoutManager(this));
        rvCommandes.setAdapter(adapter);

        accessToken = requireAdminAccess();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (!accessToken.isEmpty()) {
            chargerCommandes();
        }
    }

    private void chargerCommandes() {
        progressBar.setVisibility(View.VISIBLE);
        tvStatus.setText("Chargement des commandes...");
        tvEmpty.setVisibility(View.GONE);

        Call<List<AdminCommande>> call = RetrofitClient.getApiService()
                .getAdminCommandes("Bearer " + accessToken);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<List<AdminCommande>>() {
            @Override
            public void onResponse(Call<List<AdminCommande>> call, Response<List<AdminCommande>> response) {
                progressBar.setVisibility(View.GONE);

                if (response.isSuccessful() && response.body() != null) {
                    List<AdminCommande> commandes = response.body();
                    adapter.setCommandes(commandes);

                    if (commandes.isEmpty()) {
                        tvStatus.setText("Aucune commande.");
                        tvEmpty.setVisibility(View.VISIBLE);
                        rvCommandes.setVisibility(View.GONE);
                    } else {
                        tvStatus.setText(commandes.size() + " commande(s).");
                        tvEmpty.setVisibility(View.GONE);
                        rvCommandes.setVisibility(View.VISIBLE);
                    }
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                Log.e(TAG, "Erreur HTTP " + response.code());
                tvStatus.setText("Erreur " + response.code());
            }

            @Override
            public void onFailure(Call<List<AdminCommande>> call, Throwable t) {
                progressBar.setVisibility(View.GONE);
                Log.e(TAG, "Echec reseau", t);
                tvStatus.setText("Erreur reseau.");
                Toast.makeText(AdminCommandesActivity.this, t.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    public void onDetail(AdminCommande commande) {
        Intent intent = new Intent(this, AdminDetailCommandeActivity.class);
        intent.putExtra(AdminDetailCommandeActivity.EXTRA_COMMANDE_ID, commande.getIdCommande());
        startActivity(intent);
    }

    @Override
    public void onDelete(AdminCommande commande) {
        new AlertDialog.Builder(this)
                .setTitle("Supprimer la commande")
                .setMessage("Supprimer la commande #" + commande.getIdCommande()
                        + " de " + commande.getNomComplet() + " ?")
                .setPositiveButton("Supprimer", (dialog, which) -> supprimerCommande(commande))
                .setNegativeButton("Annuler", null)
                .show();
    }

    private void supprimerCommande(AdminCommande commande) {
        Call<Void> call = RetrofitClient.getApiService()
                .deleteAdminCommande("Bearer " + accessToken, commande.getIdCommande());
        Log.d(TAG, "DELETE " + call.request().url());

        call.enqueue(new Callback<Void>() {
            @Override
            public void onResponse(Call<Void> call, Response<Void> response) {
                if (response.isSuccessful()) {
                    Toast.makeText(AdminCommandesActivity.this, "Commande annulee.", Toast.LENGTH_SHORT).show();
                    chargerCommandes();
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                Log.e(TAG, "Erreur suppression HTTP " + response.code());
                Toast.makeText(
                        AdminCommandesActivity.this,
                        "Impossible de supprimer la commande.",
                        Toast.LENGTH_SHORT
                ).show();
            }

            @Override
            public void onFailure(Call<Void> call, Throwable t) {
                Log.e(TAG, "Echec reseau suppression", t);
                Toast.makeText(AdminCommandesActivity.this, "Erreur reseau.", Toast.LENGTH_SHORT).show();
            }
        });
    }
}
