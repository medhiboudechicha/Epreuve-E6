package com.example.apimobile;

import java.util.List;
import java.util.Map;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;

/**
 * ApiService — interface Retrofit qui declare tous les endpoints de l'API CI4.
 *
 * Retrofit genere automatiquement l'implementation a partir de ces annotations.
 * Chaque methode correspond a une route de l'API backend.
 * Le header "Accept: application/json" indique au serveur qu'on attend du JSON en reponse.
 * Le header "Authorization" transporte le token JWT sous la forme "Bearer <token>".
 */
public interface ApiService {

    // ─── Authentification ────────────────────────────────────────────────────

    /** Connexion de l'utilisateur. Envoie email + mot de passe, recoit un JWT en retour. */
    @Headers("Accept: application/json")
    @POST("api/login")
    Call<LoginResponse> login(@Body LoginRequest loginRequest);

    // ─── Produits ─────────────────────────────────────────────────────────────

    /** Recupere la liste de tous les produits disponibles. Necessite un token valide. */
    @Headers("Accept: application/json")
    @GET("api/produits")
    Call<List<Produit>> getProduits(@Header("Authorization") String authorization);

    /** Cree un nouveau produit (admin). Corps JSON contenant id_produit, nom, prix, stock, etc. */
    @Headers("Accept: application/json")
    @POST("api/produits")
    Call<Void> createProduit(
            @Header("Authorization") String authorization,
            @Body Map<String, Object> body
    );

    /** Met a jour un produit existant (admin). */
    @Headers("Accept: application/json")
    @PUT("api/produits/{id}")
    Call<Void> updateProduit(
            @Header("Authorization") String authorization,
            @Path("id") String idProduit,
            @Body Map<String, Object> body
    );

    /** Supprime un produit (admin). */
    @Headers("Accept: application/json")
    @DELETE("api/produits/{id}")
    Call<Void> deleteProduit(
            @Header("Authorization") String authorization,
            @Path("id") String idProduit
    );

    // ─── Panier ───────────────────────────────────────────────────────────────

    /** Recupere le contenu actuel du panier de l'utilisateur connecte. */
    @Headers("Accept: application/json")
    @GET("api/panier")
    Call<PanierResponse> getPanier(@Header("Authorization") String authorization);

    /** Ajoute un produit au panier (ou incremente sa quantite s'il est deja present). */
    @Headers("Accept: application/json")
    @POST("api/panier/add")
    Call<PanierResponse> addToPanier(
            @Header("Authorization") String authorization,
            @Body PanierMutationRequest request
    );

    /** Met a jour la quantite d'un produit existant dans le panier. */
    @Headers("Accept: application/json")
    @POST("api/panier/update")
    Call<PanierResponse> updatePanier(
            @Header("Authorization") String authorization,
            @Body PanierMutationRequest request
    );

    /** Retire completement un produit du panier. */
    @Headers("Accept: application/json")
    @POST("api/panier/remove")
    Call<PanierResponse> removeFromPanier(
            @Header("Authorization") String authorization,
            @Body PanierMutationRequest request
    );

    /** Vide entierement le panier de l'utilisateur. */
    @Headers("Accept: application/json")
    @POST("api/panier/clear")
    Call<PanierResponse> clearPanier(@Header("Authorization") String authorization);

    // ─── Commandes ────────────────────────────────────────────────────────────

    /** Cree une nouvelle commande a partir du contenu du panier. */
    @Headers("Accept: application/json")
    @POST("api/commandes")
    Call<CommandeCreationResponse> createCommande(
            @Header("Authorization") String authorization,
            @Body CommandeRequest commandeRequest
    );

    /** Recupere la liste de toutes les commandes passees par l'utilisateur connecte. */
    @Headers("Accept: application/json")
    @GET("api/commandes")
    Call<List<Commande>> getCommandes(@Header("Authorization") String authorization);

    /** Recupere le detail d'une commande specifique par son identifiant. */
    @Headers("Accept: application/json")
    @GET("api/commandes/{id}")
    Call<Commande> getCommandeDetail(
            @Header("Authorization") String authorization,
            @Path("id") int commandeId  // {id} dans l'URL est remplace par cette valeur
    );

    // ─── Admin ────────────────────────────────────────────────────────────────

    /** Recupere les statistiques globales (nb produits, commandes, utilisateurs, CA). */
    @Headers("Accept: application/json")
    @GET("api/admin/stats")
    Call<AdminStats> getAdminStats(@Header("Authorization") String authorization);

    /** Recupere toutes les commandes de tous les utilisateurs (vue admin). */
    @Headers("Accept: application/json")
    @GET("api/admin/commandes")
    Call<List<AdminCommande>> getAdminCommandes(@Header("Authorization") String authorization);

    /** Recupere le detail d'une commande specifique en tant qu'admin (sans restriction d'utilisateur). */
    @Headers("Accept: application/json")
    @GET("api/admin/commandes/{id}")
    Call<AdminCommande> getAdminCommandeDetail(
            @Header("Authorization") String authorization,
            @Path("id") int commandeId
    );

    /** Supprime une commande (admin uniquement). */
    @Headers("Accept: application/json")
    @DELETE("api/admin/commandes/{id}")
    Call<Void> deleteAdminCommande(
            @Header("Authorization") String authorization,
            @Path("id") int commandeId
    );

    /** Recupere la liste de tous les utilisateurs (admin uniquement). */
    @Headers("Accept: application/json")
    @GET("api/admin/utilisateurs")
    Call<List<Utilisateur>> getAdminUtilisateurs(@Header("Authorization") String authorization);
}
