<?php

namespace App\Support;

use CodeIgniter\HTTP\RequestInterface;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use stdClass;
use Throwable;

final class JwtSupport
{
    // Roles autorises a utiliser les endpoints admin. Les controles UI Android
    // sont pratiques, mais cette liste cote API reste la source d'autorite.
    private const PRIVILEGED_ROLES = [
        'admin',
        'superadmin',
    ];

    private function __construct()
    {
    }

    public static function getBearerToken(RequestInterface $request): ?string
    {
        $authHeader = $request->getHeaderLine('Authorization');

        // Format attendu par l'app: Authorization: Bearer <jwt>.
        if (! $authHeader || stripos($authHeader, 'Bearer ') !== 0) {
            return null;
        }

        $token = trim(substr($authHeader, 7));

        return $token === '' ? null : $token;
    }

    public static function decodeBearerToken(RequestInterface $request): ?stdClass
    {
        $token = self::getBearerToken($request);

        if ($token === null) {
            return null;
        }

        return self::decodeToken($token);
    }

    public static function decodeToken(string $token): ?stdClass
    {
        $secret = env('JWT_SECRET');

        if (! $secret) {
            return null;
        }

        try {
            // HS256 correspond a l'algorithme utilise dans AuthApi::login().
            $decoded = JWT::decode($token, new Key($secret, 'HS256'));

            return $decoded instanceof stdClass ? $decoded : (object) $decoded;
        } catch (Throwable) {
            // Token expire, mal signe ou mal forme: les controleurs repondent
            // ensuite avec un 401/403 sans exposer la raison precise.
            return null;
        }
    }

    public static function getUserId(RequestInterface $request): ?int
    {
        $decoded = self::decodeBearerToken($request);

        return isset($decoded->sub) ? (int) $decoded->sub : null;
    }

    public static function getRole(RequestInterface $request): string
    {
        $decoded = self::decodeBearerToken($request);

        // Role absent ou invalide = aucun privilege.
        if (! isset($decoded->role) || ! is_string($decoded->role)) {
            return '';
        }

        return $decoded->role;
    }

    public static function isPrivilegedRole(?string $role): bool
    {
        return in_array($role, self::PRIVILEGED_ROLES, true);
    }

    public static function isAdminRequest(RequestInterface $request): bool
    {
        return self::isPrivilegedRole(self::getRole($request));
    }
}
