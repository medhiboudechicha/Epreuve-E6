package com.example.apimobile;

import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class SessionManagerRoleTest {

    @Test
    public void isPrivilegedRole_acceptsAdminAndSuperadmin() {
        assertTrue(SessionManager.isPrivilegedRole("admin"));
        assertTrue(SessionManager.isPrivilegedRole("superadmin"));
    }

    @Test
    public void isPrivilegedRole_rejectsStandardAndUnknownRoles() {
        assertFalse(SessionManager.isPrivilegedRole("utilisateur"));
        assertFalse(SessionManager.isPrivilegedRole(""));
        assertFalse(SessionManager.isPrivilegedRole(null));
    }
}
