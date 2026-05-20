package com.example.apimobile;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.bumptech.glide.Glide;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * DetailProduitActivity — ecran de detail d'un produit.
 *
 * Recoit un objet Produit via l'intent (EXTRA_PRODUIT), affiche ses informations
 * (nom, prix, description, image) et permet de l'ajouter au panier via l'API.
 * L'image est chargee de maniere asynchrone avec la librairie Glide.
 */
public class DetailProduitActivity extends AppCompatActivity {

    // Cle de l'extra intent pour passer l'objet Produit depuis MainActivity
    public static final String EXTRA_PRODUIT = "extra_produit";

    private static final String TAG = "DetailProduitActivity";

    private ImageView ivProduit;     // Image du produit (chargee par Glide)
    private TextView tvNom;          // Nom du produit
    private TextView tvPrix;         // Prix du produit
    private TextView tvDescription;  // Description du produit
    private TextView tvImageStatus;  // Message affiché si aucune image n'est disponible
    private Button btnAjouterPanier; // Bouton pour ajouter le produit au panier

    private Produit produit;     // Produit recu via l'intent
    private String accessToken;  // Token JWT de la session

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail_produit);

        // Liaison des vues avec le layout XML
        ivProduit = findViewById(R.id.ivProduitDetail);
        tvNom = findViewById(R.id.tvNomDetail);
        tvPrix = findViewById(R.id.tvPrixDetail);
        tvDescription = findViewById(R.id.tvDescriptionDetail);
        tvImageStatus = findViewById(R.id.tvImageStatusDetail);
        btnAjouterPanier = findViewById(R.id.btnAjouterPanierDetail);

        // Lecture du produit passe via l'intent (gestion de compatibilite Android 13+)
        produit = readProduitFromIntent();
        if (produit == null) {
            // Produit invalide ou absent : on ferme l'activite immediatement
            finish();
            return;
        }

        btnAjouterPanier.setOnClickListener(v -> ajouterAuPanier());

        // Remplissage des champs texte
        setTitle(produit.getNom()); // titre de la barre de navigation
        tvNom.setText(produit.getNom());
        tvPrix.setText("Prix : " + produit.getPrix() + " EUR");
        tvDescription.setText(TextUtils.isEmpty(produit.getDescription()) ? "Aucune description." : produit.getDescription());

        // Chargement de l'image si disponible
        if (!produit.hasImage()) {
            // Pas d'image : on masque l'ImageView et affiche un message a la place
            ivProduit.setVisibility(View.GONE);
            tvImageStatus.setVisibility(View.VISIBLE);
            tvImageStatus.setText("Aucune image disponible.");
            return;
        }

        // Construction de l'URL complete de l'image (base_url + dossier uploads + nom du fichier)
        String imageUrl = RetrofitClient.buildUploadsUrl(produit.getImage());
        ivProduit.setVisibility(View.VISIBLE);
        tvImageStatus.setVisibility(View.GONE);

        // Chargement asynchrone de l'image avec Glide
        // placeholder : image affichee pendant le chargement
        // error : image affichee si le chargement echoue
        Glide.with(this)
                .load(imageUrl)
                .placeholder(android.R.drawable.ic_menu_gallery)
                .error(android.R.drawable.ic_dialog_alert)
                .into(ivProduit);
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Rafraichissement du token a chaque reprise (en cas de retour depuis une autre activite)
        accessToken = SessionManager.getAccessToken(this);
    }

    /**
     * Lit l'objet Produit depuis l'intent de facon compatible avec toutes les versions Android.
     * Depuis Android 13 (TIRAMISU), la methode getSerializableExtra a change de signature.
     *
     * @return le Produit recu, ou null si absent ou invalide
     */
    private Produit readProduitFromIntent() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // API 33+ : nouvelle methode avec le type en parametre
            return getIntent().getSerializableExtra(EXTRA_PRODUIT, Produit.class);
        }

        // API < 33 : ancienne methode avec cast manuel
        Object extra = getIntent().getSerializableExtra(EXTRA_PRODUIT);
        if (extra instanceof Produit) {
            return (Produit) extra;
        }

        return null;
    }

    /**
     * Ajoute le produit au panier via l'API (quantite 1).
     * Valide d'abord la presence du token et de l'ID produit.
     */
    private void ajouterAuPanier() {
        if (accessToken == null || accessToken.isEmpty()) {
            redirectToLogin("Session absente. Connecte-toi.");
            return;
        }

        if (produit == null || produit.getIdProduit().isEmpty()) {
            // Ne devrait pas arriver : le produit a ete valide dans onCreate
            Toast.makeText(this, "Produit invalide : identifiant manquant.", Toast.LENGTH_LONG).show();
            Log.e(TAG, "Ajout panier refuse: id_produit vide");
            return;
        }

        btnAjouterPanier.setEnabled(false); // evite un double clic pendant l'appel API

        // Appel API POST /api/panier/add avec le produit et une quantite de 1
        Call<PanierResponse> call = RetrofitClient.getApiService().addToPanier(
                "Bearer " + accessToken,
                new PanierMutationRequest(produit.getIdProduit(), 1)
        );
        Log.d(TAG, "POST " + call.request().url());

        call.enqueue(new Callback<PanierResponse>() {
            @Override
            public void onResponse(Call<PanierResponse> call, Response<PanierResponse> response) {
                btnAjouterPanier.setEnabled(true);

                if (response.isSuccessful() && response.body() != null) {
                    // Succes : affiche le message retourne par l'API ou un message par defaut
                    String message = response.body().getMessage().isEmpty()
                            ? "Produit ajoute au panier."
                            : response.body().getMessage();
                    Toast.makeText(DetailProduitActivity.this, message, Toast.LENGTH_SHORT).show();
                    return;
                }

                // Erreur HTTP
                String errorBody = ApiErrorUtils.readErrorBody(response, TAG);
                Log.e(TAG, "Erreur HTTP " + response.code() + " sur " + call.request().url());
                Log.e(TAG, "errorBody = " + errorBody);

                if (response.code() == 401) {
                    // Token expire : deconnexion forcee
                    SessionManager.clearSession(DetailProduitActivity.this);
                    redirectToLogin("Session expiree ou token invalide. Reconnecte-toi.");
                    return;
                }

                String apiMessage = ApiErrorUtils.extractApiMessage(errorBody, TAG);
                Toast.makeText(
                        DetailProduitActivity.this,
                        apiMessage.isEmpty() ? "Impossible d'ajouter le produit au panier." : apiMessage,
                        Toast.LENGTH_LONG
                ).show();
            }

            @Override
            public void onFailure(Call<PanierResponse> call, Throwable t) {
                btnAjouterPanier.setEnabled(true);
                String message = t.getMessage() != null ? t.getMessage() : "Erreur reseau inconnue";
                Log.e(TAG, "Echec reseau vers " + call.request().url(), t);
                Toast.makeText(DetailProduitActivity.this, message, Toast.LENGTH_LONG).show();
            }
        });
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
