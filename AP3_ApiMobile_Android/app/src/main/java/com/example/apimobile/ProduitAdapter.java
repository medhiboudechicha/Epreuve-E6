package com.example.apimobile;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.List;

public class ProduitAdapter extends RecyclerView.Adapter<ProduitAdapter.ProduitViewHolder> {
    public interface OnProduitClickListener {
        void onProduitClick(Produit produit);
    }

    private final List<Produit> produits = new ArrayList<>();
    private final OnProduitClickListener onProduitClickListener;

    public ProduitAdapter(OnProduitClickListener onProduitClickListener) {
        this.onProduitClickListener = onProduitClickListener;
    }

    public void setProduits(List<Produit> nouveauxProduits) {
        produits.clear();

        if (nouveauxProduits != null) {
            for (Produit produit : nouveauxProduits) {
                if (produit != null && !TextUtils.isEmpty(produit.getIdProduit())) {
                    produits.add(produit);
                }
            }
        }

        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ProduitViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_produit, parent, false);
        return new ProduitViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ProduitViewHolder holder, int position) {
        holder.bind(produits.get(position), onProduitClickListener);
    }

    @Override
    public int getItemCount() {
        return produits.size();
    }

    static class ProduitViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvNom;
        private final TextView tvId;
        private final TextView tvDescription;
        private final TextView tvPrix;
        private final TextView tvStock;
        private final ImageView ivProduit;

        ProduitViewHolder(@NonNull View itemView) {
            super(itemView);
            ivProduit = itemView.findViewById(R.id.ivProduitItem);
            tvNom = itemView.findViewById(R.id.tvNomProduit);
            tvId = itemView.findViewById(R.id.tvIdProduit);
            tvDescription = itemView.findViewById(R.id.tvDescriptionProduit);
            tvPrix = itemView.findViewById(R.id.tvPrixProduit);
            tvStock = itemView.findViewById(R.id.tvStockProduit);
        }

        void bind(Produit produit, OnProduitClickListener onProduitClickListener) {
            tvNom.setText(produit.getNom());

            if (TextUtils.isEmpty(produit.getIdProduit())) {
                tvId.setText("ID indisponible");
            } else {
                tvId.setText("ID : " + produit.getIdProduit());
            }

            if (TextUtils.isEmpty(produit.getDescription())) {
                tvDescription.setText("Aucune description.");
            } else {
                tvDescription.setText(produit.getDescription());
            }

            tvPrix.setText(produit.getPrix() + " EUR");
            tvStock.setText("Stock : " + produit.getStock());

            String imageUrl = RetrofitClient.buildUploadsUrl(produit.getImage());
            Glide.with(itemView.getContext())
                    .load(produit.hasImage() ? imageUrl : null)
                    .placeholder(android.R.drawable.ic_menu_gallery)
                    .error(android.R.drawable.ic_menu_gallery)
                    .into(ivProduit);

            itemView.setOnClickListener(v -> onProduitClickListener.onProduitClick(produit));
        }
    }
}
