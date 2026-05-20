package com.example.apimobile;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.List;

/**
 * AdminProduitAdapter — adaptateur RecyclerView pour la liste admin des produits.
 * Chaque item affiche le produit avec deux boutons : Modifier et Supprimer.
 */
public class AdminProduitAdapter extends RecyclerView.Adapter<AdminProduitAdapter.ViewHolder> {

    /** Interface de callbacks pour les actions Modifier et Supprimer. */
    public interface OnProduitAdminListener {
        void onEdit(Produit produit);
        void onDelete(Produit produit);
    }

    private final List<Produit> produits = new ArrayList<>();
    private final OnProduitAdminListener listener;

    public AdminProduitAdapter(OnProduitAdminListener listener) {
        this.listener = listener;
    }

    public void setProduits(List<Produit> nouveauxProduits) {
        produits.clear();
        if (nouveauxProduits != null) {
            produits.addAll(nouveauxProduits);
        }
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_admin_produit, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.bind(produits.get(position), listener);
    }

    @Override
    public int getItemCount() {
        return produits.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private final ImageView ivProduit;
        private final TextView tvNom;
        private final TextView tvPrix;
        private final TextView tvStock;
        private final Button btnModifier;
        private final Button btnSupprimer;

        ViewHolder(@NonNull View itemView) {
            super(itemView);
            ivProduit   = itemView.findViewById(R.id.ivAdminProduitItem);
            tvNom       = itemView.findViewById(R.id.tvAdminNomProduit);
            tvPrix      = itemView.findViewById(R.id.tvAdminPrixProduit);
            tvStock     = itemView.findViewById(R.id.tvAdminStockProduit);
            btnModifier = itemView.findViewById(R.id.btnModifierProduit);
            btnSupprimer = itemView.findViewById(R.id.btnSupprimerProduit);
        }

        void bind(Produit produit, OnProduitAdminListener listener) {
            tvNom.setText(produit.getNom());
            tvPrix.setText(produit.getPrix() + " EUR");
            tvStock.setText("Stock : " + produit.getStock());

            String imageUrl = RetrofitClient.buildUploadsUrl(produit.getImage());
            Glide.with(itemView.getContext())
                    .load(produit.hasImage() ? imageUrl : null)
                    .placeholder(android.R.drawable.ic_menu_gallery)
                    .error(android.R.drawable.ic_menu_gallery)
                    .into(ivProduit);

            btnModifier.setOnClickListener(v -> listener.onEdit(produit));
            btnSupprimer.setOnClickListener(v -> listener.onDelete(produit));
        }
    }
}
