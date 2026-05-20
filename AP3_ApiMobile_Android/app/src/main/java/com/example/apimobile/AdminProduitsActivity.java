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

import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AdminProduitsActivity extends AdminBaseActivity implements AdminProduitAdapter.OnProduitAdminListener {
    private static final String TAG = "AdminProduits";

    private ProgressBar progressBar;
    private TextView tvEmpty;
    private RecyclerView rvProduits;
    private FloatingActionButton fabAjouterProduit;
    private AdminProduitAdapter adapter;
    private String accessToken = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_produits);

        progressBar = findViewById(R.id.progressAdminProduits);
        tvEmpty = findViewById(R.id.tvAdminProduitsEmpty);
        rvProduits = findViewById(R.id.rvAdminProduits);
        fabAjouterProduit = findViewById(R.id.fabAjouterProduit);

        adapter = new AdminProduitAdapter(this);
        rvProduits.setLayoutManager(new LinearLayoutManager(this));
        rvProduits.setAdapter(adapter);

        fabAjouterProduit.setOnClickListener(v ->
                startActivity(new Intent(this, AdminProduitFormActivity.class)));

        accessToken = requireAdminAccess();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (!accessToken.isEmpty()) {
            chargerProduits();
        }
    }

    private void chargerProduits() {
        progressBar.setVisibility(View.VISIBLE);
        tvEmpty.setVisibility(View.GONE);

        Call<List<Produit>> call = RetrofitClient.getApiService().getProduits("Bearer " + accessToken);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<List<Produit>>() {
            @Override
            public void onResponse(Call<List<Produit>> call, Response<List<Produit>> response) {
                progressBar.setVisibility(View.GONE);

                if (response.isSuccessful() && response.body() != null) {
                    List<Produit> produits = response.body();
                    adapter.setProduits(produits);

                    if (produits.isEmpty()) {
                        tvEmpty.setVisibility(View.VISIBLE);
                        rvProduits.setVisibility(View.GONE);
                    } else {
                        tvEmpty.setVisibility(View.GONE);
                        rvProduits.setVisibility(View.VISIBLE);
                    }
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                Log.e(TAG, "Erreur HTTP " + response.code());
                Toast.makeText(
                        AdminProduitsActivity.this,
                        "Erreur " + response.code() + " lors du chargement.",
                        Toast.LENGTH_SHORT
                ).show();
            }

            @Override
            public void onFailure(Call<List<Produit>> call, Throwable t) {
                progressBar.setVisibility(View.GONE);
                Log.e(TAG, "Echec reseau", t);
                Toast.makeText(
                        AdminProduitsActivity.this,
                        "Erreur reseau : " + t.getMessage(),
                        Toast.LENGTH_SHORT
                ).show();
            }
        });
    }

    @Override
    public void onEdit(Produit produit) {
        Intent intent = new Intent(this, AdminProduitFormActivity.class);
        intent.putExtra(AdminProduitFormActivity.EXTRA_PRODUIT, produit);
        startActivity(intent);
    }

    @Override
    public void onDelete(Produit produit) {
        new AlertDialog.Builder(this)
                .setTitle("Supprimer le produit")
                .setMessage("Confirmer la suppression de \"" + produit.getNom() + "\" ?")
                .setPositiveButton("Supprimer", (dialog, which) -> supprimerProduit(produit))
                .setNegativeButton("Annuler", null)
                .show();
    }

    private void supprimerProduit(Produit produit) {
        Call<Void> call = RetrofitClient.getApiService().deleteProduit(
                "Bearer " + accessToken, produit.getIdProduit());
        Log.d(TAG, "DELETE " + call.request().url());

        call.enqueue(new Callback<Void>() {
            @Override
            public void onResponse(Call<Void> call, Response<Void> response) {
                if (response.isSuccessful()) {
                    Toast.makeText(AdminProduitsActivity.this, "Produit supprime.", Toast.LENGTH_SHORT).show();
                    chargerProduits();
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                Log.e(TAG, "Erreur suppression HTTP " + response.code());
                Toast.makeText(
                        AdminProduitsActivity.this,
                        "Impossible de supprimer le produit.",
                        Toast.LENGTH_SHORT
                ).show();
            }

            @Override
            public void onFailure(Call<Void> call, Throwable t) {
                Log.e(TAG, "Echec reseau suppression", t);
                Toast.makeText(AdminProduitsActivity.this, "Erreur reseau.", Toast.LENGTH_SHORT).show();
            }
        });
    }
}
