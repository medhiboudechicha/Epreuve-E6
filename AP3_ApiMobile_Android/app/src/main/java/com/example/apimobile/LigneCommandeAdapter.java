package com.example.apimobile;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class LigneCommandeAdapter extends RecyclerView.Adapter<LigneCommandeAdapter.LigneCommandeViewHolder> {
    private final List<LigneCommande> lignes = new ArrayList<>();

    public void setLignes(List<LigneCommande> nouvellesLignes) {
        lignes.clear();

        if (nouvellesLignes != null) {
            lignes.addAll(nouvellesLignes);
        }

        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public LigneCommandeViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_ligne_commande, parent, false);
        return new LigneCommandeViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull LigneCommandeViewHolder holder, int position) {
        holder.bind(lignes.get(position));
    }

    @Override
    public int getItemCount() {
        return lignes.size();
    }

    static class LigneCommandeViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvNom;
        private final TextView tvDescription;
        private final TextView tvQuantite;
        private final TextView tvSousTotal;

        LigneCommandeViewHolder(@NonNull View itemView) {
            super(itemView);
            tvNom = itemView.findViewById(R.id.tvLigneCommandeNom);
            tvDescription = itemView.findViewById(R.id.tvLigneCommandeDescription);
            tvQuantite = itemView.findViewById(R.id.tvLigneCommandeQuantite);
            tvSousTotal = itemView.findViewById(R.id.tvLigneCommandeSousTotal);
        }

        void bind(LigneCommande ligneCommande) {
            tvNom.setText(ligneCommande.getNom());
            tvDescription.setText(TextUtils.isEmpty(ligneCommande.getDescription()) ? "Aucune description." : ligneCommande.getDescription());
            tvQuantite.setText(
                    "Quantite : " + ligneCommande.getQuantite()
                            + " x " + String.format(Locale.US, "%.2f", ligneCommande.getPrix())
                            + " EUR"
            );
            tvSousTotal.setText("Sous-total : " + String.format(Locale.US, "%.2f", ligneCommande.getSousTotal()) + " EUR");
        }
    }
}
