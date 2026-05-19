<?php

class User
{
    private $pdo;

    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    public function all()
    {
        $sql = 'SELECT id_utilisateur, nom, prenom, email, role FROM dbo.utilisateur ORDER BY id_utilisateur';
        return $this->pdo->query($sql)->fetchAll();
    }

    public function find($id)
    {
        $requete = $this->pdo->prepare('SELECT id_utilisateur, nom, prenom, email, role FROM dbo.utilisateur WHERE id_utilisateur = ?');
        $requete->execute([$id]);
        return $requete->fetch();
    }

    public function findByEmail($email)
    {
        $requete = $this->pdo->prepare('SELECT * FROM dbo.utilisateur WHERE email = ?');
        $requete->execute([$email]);
        return $requete->fetch();
    }

    public function create($data)
    {
        $sql = 'INSERT INTO dbo.utilisateur (nom, prenom, email, mot_de_passe, role) VALUES (?, ?, ?, ?, ?)';
        $requete = $this->pdo->prepare($sql);
        $requete->execute([
            $data['nom'],
            $data['prenom'],
            $data['email'],
            password_hash($data['mot_de_passe'], PASSWORD_DEFAULT),
            $data['role'],
        ]);
    }

    public function update($id, $data)
    {
        if ($data['mot_de_passe'] !== '') {
            $sql = 'UPDATE dbo.utilisateur SET nom = ?, prenom = ?, email = ?, role = ?, mot_de_passe = ? WHERE id_utilisateur = ?';
            $requete = $this->pdo->prepare($sql);
            $requete->execute([
                $data['nom'],
                $data['prenom'],
                $data['email'],
                $data['role'],
                password_hash($data['mot_de_passe'], PASSWORD_DEFAULT),
                $id,
            ]);
        } else {
            $sql = 'UPDATE dbo.utilisateur SET nom = ?, prenom = ?, email = ?, role = ? WHERE id_utilisateur = ?';
            $requete = $this->pdo->prepare($sql);
            $requete->execute([
                $data['nom'],
                $data['prenom'],
                $data['email'],
                $data['role'],
                $id,
            ]);
        }
    }

    public function updateAccount($id, $data)
    {
        if ($data['mot_de_passe'] !== '') {
            $sql = 'UPDATE dbo.utilisateur SET nom = ?, prenom = ?, email = ?, mot_de_passe = ? WHERE id_utilisateur = ?';
            $requete = $this->pdo->prepare($sql);
            $requete->execute([
                $data['nom'],
                $data['prenom'],
                $data['email'],
                password_hash($data['mot_de_passe'], PASSWORD_DEFAULT),
                $id,
            ]);
        } else {
            $sql = 'UPDATE dbo.utilisateur SET nom = ?, prenom = ?, email = ? WHERE id_utilisateur = ?';
            $requete = $this->pdo->prepare($sql);
            $requete->execute([$data['nom'], $data['prenom'], $data['email'], $id]);
        }
    }

    public function delete($id)
    {
        $requete = $this->pdo->prepare('DELETE FROM dbo.utilisateur WHERE id_utilisateur = ?');
        $requete->execute([$id]);
    }
}
