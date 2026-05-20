package com.example.apimobile;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class RetrofitClientTest {

    @Test
    public void getBaseUrl_alwaysEndsWithSlash() {
        assertTrue(RetrofitClient.getBaseUrl().endsWith("/"));
    }

    @Test
    public void buildUploadsUrl_appendsUploadsFolder() {
        assertEquals(
                RetrofitClient.getBaseUrl() + "uploads/produit.png",
                RetrofitClient.buildUploadsUrl("produit.png")
        );
    }
}
