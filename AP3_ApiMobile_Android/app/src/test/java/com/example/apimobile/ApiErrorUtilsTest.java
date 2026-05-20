package com.example.apimobile;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class ApiErrorUtilsTest {

    @Test
    public void extractApiMessage_returnsNestedErrorMessage() {
        String errorBody = "{\"messages\":{\"error\":\"Stock insuffisant\"}}";

        assertEquals("Stock insuffisant", ApiErrorUtils.extractApiMessage(errorBody, "TEST"));
    }

    @Test
    public void extractApiMessage_returnsTopLevelMessage() {
        String errorBody = "{\"message\":\"Acces refuse\"}";

        assertEquals("Acces refuse", ApiErrorUtils.extractApiMessage(errorBody, "TEST"));
    }

    @Test
    public void extractApiMessage_returnsRawBodyWhenJsonIsInvalid() {
        String errorBody = "Erreur brute";

        assertEquals("Erreur brute", ApiErrorUtils.extractApiMessage(errorBody, "TEST"));
    }
}
