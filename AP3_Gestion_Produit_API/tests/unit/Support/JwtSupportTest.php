<?php

use App\Support\JwtSupport;
use CodeIgniter\Test\CIUnitTestCase;
use Firebase\JWT\JWT;

/**
 * @internal
 */
final class JwtSupportTest extends CIUnitTestCase
{
    public function testIsPrivilegedRoleRecognizesAdminRoles(): void
    {
        $this->assertTrue(JwtSupport::isPrivilegedRole('admin'));
        $this->assertTrue(JwtSupport::isPrivilegedRole('superadmin'));
        $this->assertFalse(JwtSupport::isPrivilegedRole('utilisateur'));
        $this->assertFalse(JwtSupport::isPrivilegedRole(null));
    }

    public function testDecodeTokenReturnsPayloadWhenSecretMatches(): void
    {
        $secret = 'unit-test-secret-key-with-32-bytes';

        $_ENV['JWT_SECRET'] = $secret;
        $_SERVER['JWT_SECRET'] = $secret;

        $token = JWT::encode([
            'sub' => 42,
            'role' => 'admin',
            'exp' => time() + 3600,
        ], $secret, 'HS256');

        $decoded = JwtSupport::decodeToken($token);

        $this->assertNotNull($decoded);
        $this->assertSame(42, (int) $decoded->sub);
        $this->assertSame('admin', $decoded->role);
    }
}
