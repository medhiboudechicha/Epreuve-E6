package com.example.apimobile;

import com.google.gson.annotations.SerializedName;

public class Utilisateur {

    @SerializedName("id_utilisateur")
    private int idUtilisateur;

    @SerializedName("nom")
    private String nom;

    @SerializedName("prenom")
    private String prenom;

    @SerializedName("email")
    private String email;

    @SerializedName("role")
    private String role;

    public int getIdUtilisateur() {
        return idUtilisateur;
    }

    public String getNom() {
        return nom == null ? "" : nom;
    }

    public String getPrenom() {
        return prenom == null ? "" : prenom;
    }

    public String getEmail() {
        return email == null ? "" : email;
    }

    public String getRole() {
        return role == null ? "" : role;
    }

    public String getNomComplet() {
        return (getPrenom() + " " + getNom()).trim();
    }

    public boolean isAdmin() {
        return SessionManager.isPrivilegedRole(getRole());
    }

    public String getRoleLabel() {
        if ("superadmin".equals(getRole())) {
            return "Superadmin";
        }

        return isAdmin() ? "Admin" : "Utilisateur";
    }
}
