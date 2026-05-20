package com.example.apimobile;

import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import java.util.HashMap;
import java.util.Map;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AdminProduitFormActivity extends AdminBaseActivity {
    public static final String EXTRA_PRODUIT = "extra_produit_admin";

    private static final String TAG = "AdminProduitForm";

    private TextView tvTitreFormulaire;
    private EditText etNom;
    private EditText etDescription;
    private EditText etPrix;
    private EditText etStock;
    private EditText etImage;
    private Button btnSauvegarder;
    private ProgressBar progressBar;

    private Produit produitEdite;
    private String accessToken = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_produit_form);

        tvTitreFormulaire = findViewById(R.id.tvTitreFormulaire);
        etNom = findViewById(R.id.etNomProduit);
        etDescription = findViewById(R.id.etDescriptionProduit);
        etPrix = findViewById(R.id.etPrixProduit);
        etStock = findViewById(R.id.etStockProduit);
        etImage = findViewById(R.id.etImageProduit);
        btnSauvegarder = findViewById(R.id.btnSauvegarderProduit);
        progressBar = findViewById(R.id.progressFormProduit);

        accessToken = requireAdminAccess();
        if (accessToken.isEmpty()) {
            return;
        }

        produitEdite = lireProduitDepuisIntent();

        if (produitEdite != null) {
            tvTitreFormulaire.setText("Modifier le produit");
            setTitle("Modifier : " + produitEdite.getNom());
            etNom.setText(produitEdite.getNom());
            etDescription.setText(produitEdite.getDescription());
            etPrix.setText(produitEdite.getPrix());
            etStock.setText(produitEdite.getStock());
            etImage.setText(produitEdite.getImage());
        } else {
            tvTitreFormulaire.setText("Nouveau produit");
            setTitle("Ajouter un produit");
        }

        btnSauvegarder.setOnClickListener(v -> sauvegarder());
    }

    private void sauvegarder() {
        String nom = etNom.getText().toString().trim();
        String description = etDescription.getText().toString().trim();
        String prixStr = etPrix.getText().toString().trim();
        String stockStr = etStock.getText().toString().trim();
        String image = etImage.getText().toString().trim();

        if (nom.isEmpty()) {
            etNom.setError("Le nom est obligatoire.");
            etNom.requestFocus();
            return;
        }

        if (prixStr.isEmpty()) {
            etPrix.setError("Le prix est obligatoire.");
            etPrix.requestFocus();
            return;
        }

        if (stockStr.isEmpty()) {
            etStock.setError("Le stock est obligatoire.");
            etStock.requestFocus();
            return;
        }

        Map<String, Object> body = new HashMap<>();
        body.put("nom", nom);
        body.put("description", description);
        body.put("prix", prixStr);
        body.put("stock", stockStr);
        body.put("image", image);

        setLoading(true);

        if (produitEdite == null) {
            body.put("id_produit", "P" + System.currentTimeMillis());
            creerProduit(body);
        } else {
            modifierProduit(produitEdite.getIdProduit(), body);
        }
    }

    private void creerProduit(Map<String, Object> body) {
        Call<Void> call = RetrofitClient.getApiService().createProduit("Bearer " + accessToken, body);
        Log.d(TAG, "POST " + call.request().url());

        call.enqueue(new Callback<Void>() {
            @Override
            public void onResponse(Call<Void> call, Response<Void> response) {
                setLoading(false);

                if (response.isSuccessful()) {
                    Toast.makeText(
                            AdminProduitFormActivity.this,
                            "Produit cree avec succes.",
                            Toast.LENGTH_SHORT
                    ).show();
                    finish();
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                Log.e(TAG, "Erreur creation HTTP " + response.code());
                Toast.makeText(
                        AdminProduitFormActivity.this,
                        "Erreur " + response.code() + " lors de la creation.",
                        Toast.LENGTH_SHORT
                ).show();
            }

            @Override
            public void onFailure(Call<Void> call, Throwable t) {
                setLoading(false);
                Log.e(TAG, "Echec reseau creation", t);
                Toast.makeText(
                        AdminProduitFormActivity.this,
                        "Erreur reseau : " + t.getMessage(),
                        Toast.LENGTH_SHORT
                ).show();
            }
        });
    }

    private void modifierProduit(String idProduit, Map<String, Object> body) {
        Call<Void> call = RetrofitClient.getApiService().updateProduit(
                "Bearer " + accessToken,
                idProduit,
                body
        );
        Log.d(TAG, "PUT " + call.request().url());

        call.enqueue(new Callback<Void>() {
            @Override
            public void onResponse(Call<Void> call, Response<Void> response) {
                setLoading(false);

                if (response.isSuccessful()) {
                    Toast.makeText(AdminProduitFormActivity.this, "Produit mis a jour.", Toast.LENGTH_SHORT).show();
                    finish();
                    return;
                }

                if (handleUnauthorizedResponse(response.code())) {
                    return;
                }

                Log.e(TAG, "Erreur modification HTTP " + response.code());
                Toast.makeText(
                        AdminProduitFormActivity.this,
                        "Erreur " + response.code() + " lors de la modification.",
                        Toast.LENGTH_SHORT
                ).show();
            }

            @Override
            public void onFailure(Call<Void> call, Throwable t) {
                setLoading(false);
                Log.e(TAG, "Echec reseau modification", t);
                Toast.makeText(
                        AdminProduitFormActivity.this,
                        "Erreur reseau : " + t.getMessage(),
                        Toast.LENGTH_SHORT
                ).show();
            }
        });
    }

    private void setLoading(boolean isLoading) {
        progressBar.setVisibility(isLoading ? View.VISIBLE : View.GONE);
        btnSauvegarder.setEnabled(!isLoading);
    }

    private Produit lireProduitDepuisIntent() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return getIntent().getSerializableExtra(EXTRA_PRODUIT, Produit.class);
        }

        Object extra = getIntent().getSerializableExtra(EXTRA_PRODUIT);
        if (extra instanceof Produit) {
            return (Produit) extra;
        }

        return null;
    }
}
