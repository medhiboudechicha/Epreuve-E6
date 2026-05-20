<?php

namespace App\Filters;

use App\Support\JwtSupport;
use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\Services;

class JWTFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        // Le filtre verifie seulement que le token est present et valide.
        // Les permissions fines restent dans chaque controleur API.
        if (JwtSupport::getBearerToken($request) === null) {
            return $this->unauthorized('Token manquant');
        }

        $secret = env('JWT_SECRET');

        if (! $secret) {
            return $this->serverError('JWT_SECRET manquant dans le .env');
        }

        if (JwtSupport::decodeBearerToken($request) === null) {
            return $this->unauthorized('Token invalide');
        }

        // CodeIgniter continue ensuite vers le controleur cible.
        return $request;
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }

    private function unauthorized(string $message)
    {
        $response = Services::response();
        return $response->setJSON(['message' => $message])->setStatusCode(401);
    }

    private function serverError(string $message)
    {
        $response = Services::response();
        return $response->setJSON(['message' => $message])->setStatusCode(500);
    }
}
