package com.example.apimobile;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class CommandeAdapter extends RecyclerView.Adapter<CommandeAdapter.CommandeViewHolder> {
    public interface OnCommandeClickListener {
        void onCommandeClick(Commande commande);
    }

    private final List<Commande> commandes = new ArrayList<>();
    private final OnCommandeClickListener onCommandeClickListener;

    public CommandeAdapter(OnCommandeClickListener onCommandeClickListener) {
        this.onCommandeClickListener = onCommandeClickListener;
    }

    public void setCommandes(List<Commande> nouvellesCommandes) {
        commandes.clear();

        if (nouvellesCommandes != null) {
            commandes.addAll(nouvellesCommandes);
        }

        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public CommandeViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_commande, parent, false);
        return new CommandeViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull CommandeViewHolder holder, int position) {
        holder.bind(commandes.get(position), onCommandeClickListener);
    }

    @Override
    public int getItemCount() {
        return commandes.size();
    }

    static class CommandeViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvCommandeTitre;
        private final TextView tvCommandeDate;
        private final TextView tvCommandeQuantite;
        private final TextView tvCommandeTotal;

        CommandeViewHolder(@NonNull View itemView) {
            super(itemView);
            tvCommandeTitre = itemView.findViewById(R.id.tvCommandeTitre);
            tvCommandeDate = itemView.findViewById(R.id.tvCommandeDate);
            tvCommandeQuantite = itemView.findViewById(R.id.tvCommandeQuantite);
            tvCommandeTotal = itemView.findViewById(R.id.tvCommandeTotal);
        }

        void bind(Commande commande, OnCommandeClickListener onCommandeClickListener) {
            tvCommandeTitre.setText("Commande #" + commande.getIdCommande());
            tvCommandeDate.setText("Date : " + commande.getDateCommande());
            tvCommandeQuantite.setText("Articles : " + commande.getQuantite());
            tvCommandeTotal.setText("Total : " + String.format(Locale.US, "%.2f", commande.getTotalMontant()) + " EUR");
            itemView.setOnClickListener(v -> onCommandeClickListener.onCommandeClick(commande));
        }
    }
}
