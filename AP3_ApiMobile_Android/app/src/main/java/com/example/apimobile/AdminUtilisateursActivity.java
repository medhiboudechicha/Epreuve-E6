package com.example.apimobile;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AdminUtilisateursActivity extends AdminBaseActivity {
    private static final String TAG = "AdminUtilisateurs";

    private ProgressBar progressBar;
    private TextView tvStatus;
    private TextView tvEmpty;
    private RecyclerView rvUtilisateurs;
    private AdminUtilisateurAdapter adapter;
    private String accessToken = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_utilisateurs);

        progressBar = findViewById(R.id.progressAdminUtilisateurs);
        tvStatus = findViewById(R.id.tvAdminUtilisateursStatus);
        tvEmpty = findViewById(R.id.tvAdminUtilisateursEmpty);
        rvUtilisateurs = findViewById(R.id.rvAdminUtilisateurs);

        adapter = new AdminUtilisateurAdapter();
        rvUtilisateurs.setLayoutManager(new LinearLayoutManager(this));
        rvUtilisateurs.setAdapter(adapter);

        accessToken = requireAdminAccess();
        if (accessToken.isEmpty()) {
            return;
        }

        chargerUtilisateurs();
    }

    private void chargerUtilisateurs() {
        progressBar.setVisibility(View.VISIBLE);
        tvStatus.setText("Chargement...");

        Call<List<Utilisateur>> call = RetrofitClient.getApiService()
                .getAdminUtilisateurs("Bearer " + accessToken);
        Log.d(TAG, "GET " + call.request().url());

        call.enqueue(new Callback<List<Utilisateur>>() {
            @Override
            public void onResponse(Call<List<Utilisateur>> call, Response<List<Utilisateur>> response) {
                progressBar.setVisibility(View.GONE);

                if (response.isSuccessful() && response.body() != null) {
                    List<Utilisateur> users = response.body();
                    adapter.setUtilisateurs(users);

                    if (users.isEmpty()) {
                        tvStatus.setText("Aucun utilisateur.");
                        tvEmpty.setVisibility(View.VISIBLE);
                        rvUtilisateurs.setVisibility(View.GONE);
                    } else {
                        tvStatus.setText(users.size() + " utilisateur(s).");
                        tvEmpty.setVisibility(View.GONE);
                        rvUtilisateurs.setVisibility(View.VISIBLE);
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
            public void onFailure(Call<List<Utilisateur>> call, Throwable t) {
                progressBar.setVisibility(View.GONE);
                Log.e(TAG, "Echec reseau", t);
                tvStatus.setText("Erreur reseau.");
                Toast.makeText(AdminUtilisateursActivity.this, t.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });
    }
}
