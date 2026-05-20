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

public class PanierAdapter extends RecyclerView.Adapter<PanierAdapter.PanierViewHolder> {
    public interface OnPanierActionListener {
        void onIncrement(PanierItem item);
        void onDecrement(PanierItem item);
        void onRemove(PanierItem item);
    }

    private final List<PanierItem> items = new ArrayList<>();
    private final OnPanierActionListener actionListener;

    public PanierAdapter(OnPanierActionListener actionListener) {
        this.actionListener = actionListener;
    }

    public void setItems(List<PanierItem> nouveauxItems) {
        items.clear();

        if (nouveauxItems != null) {
            items.addAll(nouveauxItems);
        }

        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public PanierViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_panier, parent, false);
        return new PanierViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull PanierViewHolder holder, int position) {
        holder.bind(items.get(position), actionListener);
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    static class PanierViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvNom;
        private final TextView tvPrix;
        private final TextView tvQuantite;
        private final TextView tvSousTotal;
        private final Button btnMoins;
        private final Button btnPlus;
        private final Button btnSupprimer;

        PanierViewHolder(@NonNull View itemView) {
            super(itemView);
            tvNom = itemView.findViewById(R.id.tvPanierNom);
            tvPrix = itemView.findViewById(R.id.tvPanierPrix);
            tvQuantite = itemView.findViewById(R.id.tvPanierQuantite);
            tvSousTotal = itemView.findViewById(R.id.tvPanierSousTotal);
            btnMoins = itemView.findViewById(R.id.btnPanierMoins);
            btnPlus = itemView.findViewById(R.id.btnPanierPlus);
            btnSupprimer = itemView.findViewById(R.id.btnPanierSupprimer);
        }

        void bind(PanierItem item, OnPanierActionListener actionListener) {
            tvNom.setText(item.getNom());
            tvPrix.setText("Prix unitaire : " + formatPrice(item.getPrixUnitaire()) + " EUR");
            tvQuantite.setText(String.valueOf(item.getQuantite()));
            tvSousTotal.setText("Sous-total : " + formatPrice(item.getSousTotal()) + " EUR");

            btnMoins.setOnClickListener(v -> actionListener.onDecrement(item));
            btnPlus.setOnClickListener(v -> actionListener.onIncrement(item));
            btnSupprimer.setOnClickListener(v -> actionListener.onRemove(item));
        }

        private String formatPrice(double value) {
            return String.format(Locale.US, "%.2f", value);
        }
    }
}
