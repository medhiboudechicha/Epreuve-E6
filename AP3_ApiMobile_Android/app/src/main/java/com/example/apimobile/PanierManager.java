package com.example.apimobile;

import java.util.ArrayList;
import java.util.List;

/**
 * PanierManager — utilitaires de calcul pour le panier.
 *
 * Classe purement statique (non instanciable) qui effectue des calculs
 * sur la liste des articles du panier : total, nombre d'articles, conversion en commande.
 */
public final class PanierManager {

    // Constructeur prive : empeche l'instanciation, cette classe ne contient que des methodes statiques
    private PanierManager() {
    }

    /**
     * Calcule le montant total du panier en additionnant les sous-totaux de chaque article.
     *
     * @param items liste des articles du panier (peut etre null)
     * @return total en euros (0 si la liste est null ou vide)
     */
    public static double getTotal(List<PanierItem> items) {
        double total = 0d;

        if (items == null) {
            return 0d;
        }

        for (PanierItem item : items) {
            total += item.getSousTotal(); // sous-total = prix unitaire x quantite
        }

        return total;
    }

    /**
     * Calcule le nombre total d'articles dans le panier (somme des quantites).
     *
     * @param items liste des articles du panier (peut etre null)
     * @return nombre total d'articles (0 si la liste est null ou vide)
     */
    public static int getNombreArticles(List<PanierItem> items) {
        int total = 0;

        if (items == null) {
            return 0;
        }

        for (PanierItem item : items) {
            total += item.getQuantite();
        }

        return total;
    }

    /**
     * Convertit une liste d'articles du panier en liste de lignes de commande.
     * Filtre les articles invalides (id vide ou quantite <= 0).
     * Utilise lors de la validation du panier pour creer une commande via l'API.
     *
     * @param items liste des articles du panier (peut etre null)
     * @return liste de CommandeRequestItem prete a etre envoyee a l'API
     */
    public static List<CommandeRequestItem> toCommandeRequestItems(List<PanierItem> items) {
        List<CommandeRequestItem> requestItems = new ArrayList<>();

        if (items == null) {
            return requestItems;
        }

        for (PanierItem item : items) {
            // On ignore les articles sans ID ou avec une quantite nulle ou negative
            if (!item.getProduitId().isEmpty() && item.getQuantite() > 0) {
                requestItems.add(new CommandeRequestItem(item.getProduitId(), item.getQuantite()));
            }
        }

        return requestItems;
    }
}
