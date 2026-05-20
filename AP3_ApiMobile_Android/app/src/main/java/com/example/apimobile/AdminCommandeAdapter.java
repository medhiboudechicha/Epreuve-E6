package com.example.apimobile;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * AdminCommandeAdapter — adaptateur RecyclerView pour la liste admin des commandes.
 * Affiche les infos de chaque commande + le nom du client.
 * Deux actions : voir le détail, supprimer.
 */
public class AdminCommandeAdapter extends RecyclerView.Adapter<AdminCommandeAdapter.ViewHolder> {

    /** Interface de callbacks pour les actions sur une commande. */
    public interface OnCommandeAdminListener {
        void onDetail(AdminCommande commande);
        void onDelete(AdminCommande commande);
    }

    private final List<AdminCommande> commandes = new ArrayList<>();
    private final OnCommandeAdminListener listener;

    public AdminCommandeAdapter(OnCommandeAdminListener listener) {
        this.listener = listener;
    }

    public void setCommandes(List<AdminCommande> nouvelles) {
        commandes.clear();
        if (nouvelles != null) {
            commandes.addAll(nouvelles);
        }
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_admin_commande, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.bind(commandes.get(position), listener);
    }

    @Override
    public int getItemCount() {
        return commandes.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvId;
        private final TextView tvClient;
        private final TextView tvDate;
        private final TextView tvTotal;
        private final Button btnDetail;
        private final Button btnSupprimer;

        ViewHolder(@NonNull View itemView) {
            super(itemView);
            tvId         = itemView.findViewById(R.id.tvAdminCommandeId);
            tvClient     = itemView.findViewById(R.id.tvAdminCommandeClient);
            tvDate       = itemView.findViewById(R.id.tvAdminCommandeDate);
            tvTotal      = itemView.findViewById(R.id.tvAdminCommandeTotal);
            btnDetail    = itemView.findViewById(R.id.btnAdminCommandeDetail);
            btnSupprimer = itemView.findViewById(R.id.btnAdminCommandeSupprimer);
        }

        void bind(AdminCommande commande, OnCommandeAdminListener listener) {
            tvId.setText("Commande #" + commande.getIdCommande());
            tvClient.setText("Client : " + commande.getNomComplet() + " (" + commande.getEmail() + ")");
            tvDate.setText("Date : " + commande.getDateCommande());
            tvTotal.setText(String.format(Locale.US,
                    "Total : %.2f EUR (%d article(s))",
                    commande.getTotalMontant(), commande.getQuantite()));

            btnDetail.setOnClickListener(v -> listener.onDetail(commande));
            btnSupprimer.setOnClickListener(v -> listener.onDelete(commande));
        }
    }
}
