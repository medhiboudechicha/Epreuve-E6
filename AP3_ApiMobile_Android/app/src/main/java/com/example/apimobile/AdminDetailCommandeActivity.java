package com.example.apimobile;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AdminDetailCommandeActivity extends AdminBaseActivity {
    public static final String EXTRA_COMMANDE_ID = "extra_admin_commande_id";

    private static final String TAG = "AdminDetailCommande";

    private ProgressBar progressBar;
    private TextView tvClient;
    private TextView tvDate;
    private TextView tvTotal;
    private RecyclerView rvLignes;
    private LigneCommandeAdapter ligneAdapter;
    private String accessToken = "";
    private int commandeId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_detail_commande);

        progressBar = findViewById(R.id.progressAdminDetailCommande);
        tvClient = findViewById(R.id.tvAdminCommandeClient);
        tvDate = findViewById(R.id.tvAdminCommandeDate);
        tvTotal = findViewById(R.id.tvAdminCommandeTotal);
        rvLignes = findViewById(R.id.rvAdminCommandeLignes);

        ligneAdapter = new LigneCommandeAdapter();
        rvLignes.setLayoutManager(new LinearLayoutManager(this));
        rvLignes.setAdapter(ligneAdapter);

        accessToken = requireAdminAccess();
        if (accessToken.isEmpty()) {
            return;
        }

        commandeId = getIntent().getIntExtra(EXTRA_COMMANDE_ID, -1);
        if (commandeId == -1) {
            finish();
            return;
        }

        chargerDetail();
    }

    private void chargerDetail() {
        progressBar.setVisibility(View.VISIBLE);

        Call<AdminCommande> call = RetrofitClient.getApiService()
                .getAdminCommandeDetail("Bearer " + accessToken, commandeId);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<AdminCommande>() {
            @Override
            public void onResponse(Call<AdminCommande> call, Response<AdminCommande> response) {
                progressBar.setVisibility(View.GONE);

                if (response.isSuccessful() && response.body() != null) {
                    AdminCommande commande = response.body();
                    setTitle("Commande #" + commande.getIdCommande());

                    tvClient.setText("Client : " + commande.getNomComplet()
                            + " (" + commande.getEmail() + ")");
                    tvDate.setText("Date : " + commande.getDateCommande());
                    tvTotal.setText(String.format(
                            Locale.US,
                            "Total : %.2f EUR (%d article(s))",
                            commande.getTotalMontant(),
                            commande.getQuantite()
                    ));

                    ligneAdapter.setLignes(commande.getLignes());
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                if (response.code() == 404) {
                    Toast.makeText(AdminDetailCommandeActivity.this, "Commande introuvable.", Toast.LENGTH_SHORT).show();
                    finish();
                    return;
                }

                Log.e(TAG, "Erreur HTTP " + response.code());
                Toast.makeText(AdminDetailCommandeActivity.this, "Erreur " + response.code(), Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onFailure(Call<AdminCommande> call, Throwable t) {
                progressBar.setVisibility(View.GONE);
                Log.e(TAG, "Echec reseau", t);
                Toast.makeText(
                        AdminDetailCommandeActivity.this,
                        "Erreur reseau : " + t.getMessage(),
                        Toast.LENGTH_SHORT
                ).show();
            }
        });
    }
}
