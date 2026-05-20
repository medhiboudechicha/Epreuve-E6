<?php

namespace App\Controllers\Api;

use App\Models\UserModel;
use App\Support\PasswordSupport;
use CodeIgniter\RESTful\ResourceController;
use Firebase\JWT\JWT;

class AuthApi extends ResourceController
{
    protected $format = 'json';

    /**
     * Petit endpoint de diagnostic utilise par l'app mobile pour verifier
     * rapidement que l'API CodeIgniter est joignable.
     */
    public function test()
    {
        return $this->respond([
            'status'    => 'ok',
            'message'   => 'API accessible',
            'login_url' => site_url('api/login'),
        ]);
    }

    public function login()
    {
        // L'app Android envoie toujours du JSON: { email, password }.
        $data = $this->request->getJSON(true);

        if (! $data || empty($data['email']) || empty($data['password'])) {
            return $this->failValidationErrors('Email et mot de passe requis');
        }

        $userModel = new UserModel();
        $user = $userModel->getByEmail((string) $data['email']);

        // PasswordSupport garde une compatibilite temporaire avec les anciens
        // mots de passe en clair, tout en favorisant les hashes modernes.
        if (! $user || ! PasswordSupport::verify((string) $data['password'], $user['mot_de_passe'] ?? null)) {
            return $this->failUnauthorized('Identifiants incorrects');
        }

        // Si un ancien mot de passe a encore ete accepte, on le migre a la
        // connexion pour eviter une migration manuelle compte par compte.
        if (PasswordSupport::needsUpgrade($user['mot_de_passe'] ?? null)) {
            $userModel->update($user['id_utilisateur'], [
                'mot_de_passe' => PasswordSupport::hash((string) $data['password']),
            ]);
        }

        $secret = env('JWT_SECRET');
        if (! $secret) {
            return $this->failServerError('JWT_SECRET manquant dans le .env');
        }

        // Le role est mis dans le JWT pour que l'app puisse rediriger vers
        // les ecrans admin, mais les controles d'acces restent cote API.
        $payload = [
            'iss'   => base_url(),
            'iat'   => time(),
            'exp'   => time() + 3600, // 1h
            'sub'   => $user['id_utilisateur'],
            'email' => $user['email'],
            'role'  => $user['role'],
        ];

        $token = JWT::encode($payload, $secret, 'HS256');

        return $this->respond([
            'access_token' => $token
        ]);
    }
}
