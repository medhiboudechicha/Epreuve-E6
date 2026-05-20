<?php

namespace App\Support;

final class PasswordSupport
{
    // Prefixes des formats acceptes par password_verify/password_needs_rehash.
    // Tout autre format est considere comme un ancien mot de passe en clair.
    private const HASH_PREFIXES = [
        '$2y$',
        '$2a$',
        '$2b$',
        '$argon2',
    ];

    private function __construct()
    {
    }

    public static function isHash(string $storedPassword): bool
    {
        foreach (self::HASH_PREFIXES as $prefix) {
            if (str_starts_with($storedPassword, $prefix)) {
                return true;
            }
        }

        return false;
    }

    public static function verify(string $plainPassword, ?string $storedPassword): bool
    {
        if ($storedPassword === null || $storedPassword === '') {
            return false;
        }

        // Chemin normal: mot de passe stocke sous forme de hash PHP.
        if (self::isHash($storedPassword)) {
            return password_verify($plainPassword, $storedPassword);
        }

        // Chemin legacy: certains comptes de la base initiale etaient encore
        // en clair. hash_equals evite une comparaison sensible au timing.
        return hash_equals($storedPassword, $plainPassword);
    }

    public static function needsUpgrade(?string $storedPassword): bool
    {
        if ($storedPassword === null || $storedPassword === '') {
            return false;
        }

        if (! self::isHash($storedPassword)) {
            return true;
        }

        // Permet de profiter automatiquement d'un changement futur du cout ou
        // de l'algorithme defini par PASSWORD_DEFAULT.
        return password_needs_rehash($storedPassword, PASSWORD_DEFAULT);
    }

    public static function hash(string $plainPassword): string
    {
        return password_hash($plainPassword, PASSWORD_DEFAULT);
    }
}
