package com.example.apimobile;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class AdminUtilisateurAdapter extends RecyclerView.Adapter<AdminUtilisateurAdapter.ViewHolder> {

    private final List<Utilisateur> utilisateurs = new ArrayList<>();

    public void setUtilisateurs(List<Utilisateur> nouveaux) {
        utilisateurs.clear();
        if (nouveaux != null) {
            utilisateurs.addAll(nouveaux);
        }
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_admin_utilisateur, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.bind(utilisateurs.get(position));
    }

    @Override
    public int getItemCount() {
        return utilisateurs.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvNom;
        private final TextView tvEmail;
        private final TextView tvRole;

        ViewHolder(@NonNull View itemView) {
            super(itemView);
            tvNom = itemView.findViewById(R.id.tvAdminUtilisateurNom);
            tvEmail = itemView.findViewById(R.id.tvAdminUtilisateurEmail);
            tvRole = itemView.findViewById(R.id.tvAdminUtilisateurRole);
        }

        void bind(Utilisateur user) {
            tvNom.setText(user.getNomComplet());
            tvEmail.setText(user.getEmail());
            tvRole.setText(user.getRoleLabel());
        }
    }
}
