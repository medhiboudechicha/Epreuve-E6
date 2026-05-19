<?php

class UserController extends Controller
{
    public function index()
    {
        $this->verifierAdmin();

        $model = new User($this->pdo);
        $this->view('users/index', [
            'titre' => 'Utilisateurs',
            'utilisateurs' => $model->all(),
        ]);
    }

    public function form()
    {
        $this->verifierAdmin();

        $model = new User($this->pdo);
        $id = $_GET['id'] ?? null;

        if ($id) {
            $user = $model->find($id);
            if (!$user) {
                message('Utilisateur introuvable.', 'erreur');
                redirection('utilisateurs');
            }
        } else {
            $user = [
                'id_utilisateur' => '',
                'nom' => '',
                'prenom' => '',
                'email' => '',
                'role' => 'utilisateur',
            ];
        }

        $this->view('users/form', [
            'titre' => $id ? 'Modifier utilisateur' : 'Ajouter utilisateur',
            'user' => $user,
            'id' => $id,
        ]);
    }

    public function save()
    {
        $this->verifierAdmin();

        $data = [
            'nom' => trim($_POST['nom'] ?? ''),
            'prenom' => trim($_POST['prenom'] ?? ''),
            'email' => trim($_POST['email'] ?? ''),
            'mot_de_passe' => $_POST['mot_de_passe'] ?? '',
            'role' => $_POST['role'] ?? 'utilisateur',
        ];

        $model = new User($this->pdo);

        try {
            if ($_POST['mode'] === 'modifier') {
                $id = (int) $_POST['id_utilisateur'];
                $model->update($id, $data);

                if ($id === (int) $_SESSION['user']['id_utilisateur']) {
                    $_SESSION['user']['nom'] = $data['nom'];
                    $_SESSION['user']['prenom'] = $data['prenom'];
                    $_SESSION['user']['email'] = $data['email'];
                    $_SESSION['user']['role'] = $data['role'];
                }

                message('Utilisateur modifié.');
            } else {
                if ($data['mot_de_passe'] === '') {
                    message('Le mot de passe est obligatoire.', 'erreur');
                    redirection('utilisateur_form');
                }

                $model->create($data);
                message('Utilisateur ajouté.');
            }
        } catch (PDOException $e) {
            message('Erreur SQL : ' . $e->getMessage(), 'erreur');
            redirection('utilisateurs');
        }

        redirection('utilisateurs');
    }

    public function delete()
    {
        $this->verifierAdmin();

        $id = (int) ($_POST['id_utilisateur'] ?? 0);

        if ($id === (int) $_SESSION['user']['id_utilisateur']) {
            message('Tu ne peux pas supprimer ton propre compte.', 'erreur');
            redirection('utilisateurs');
        }

        try {
            $model = new User($this->pdo);
            $model->delete($id);
            message('Utilisateur supprimé.');
        } catch (PDOException $e) {
            message('Impossible de supprimer : utilisateur lié à une autre table.', 'erreur');
        }

        redirection('utilisateurs');
    }
}
