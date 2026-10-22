package com.example.orders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

/** Runs against an in-memory database; the production database connection is not used in tests. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class OrdersApiTest {
    @Autowired MockMvc mvc;

    @Test
    void listsOrders() throws Exception {
        mvc.perform(get("/orders")).andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].item").value("Keyboard"));
    }

    @Test
    void countsOrders() throws Exception {
        mvc.perform(get("/orders/count")).andExpect(status().isOk()).andExpect(jsonPath("$.orders").value(2));
    }

    @Test
    void healthIsUpWhenTheDatabaseAnswers() throws Exception {
        mvc.perform(get("/actuator/health")).andExpect(status().isOk()).andExpect(jsonPath("$.status").value("UP"));
    }
}
