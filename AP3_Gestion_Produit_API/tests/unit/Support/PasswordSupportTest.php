<?php

use App\Support\PasswordSupport;
use CodeIgniter\Test\CIUnitTestCase;

/**
 * @internal
 */
final class PasswordSupportTest extends CIUnitTestCase
{
    public function testVerifyAcceptsLegacyPlaintextPassword(): void
    {
        $this->assertTrue(PasswordSupport::verify('secret123', 'secret123'));
        $this->assertFalse(PasswordSupport::verify('wrong', 'secret123'));
    }

    public function testVerifyAcceptsHashedPassword(): void
    {
        $hash = PasswordSupport::hash('secret123');

        $this->assertTrue(PasswordSupport::isHash($hash));
        $this->assertTrue(PasswordSupport::verify('secret123', $hash));
        $this->assertFalse(PasswordSupport::verify('wrong', $hash));
    }

    public function testNeedsUpgradeReturnsTrueForLegacyPassword(): void
    {
        $this->assertTrue(PasswordSupport::needsUpgrade('secret123'));
        $this->assertFalse(PasswordSupport::needsUpgrade(''));
    }
}
