package com.example.orders.api;

import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/orders")
public class OrderController {
    private final JdbcTemplate jdbc;

    public OrderController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping
    public List<Map<String, Object>> list() {
        return jdbc.queryForList("SELECT id, item, quantity, status FROM orders ORDER BY id");
    }

    @GetMapping("/count")
    public Map<String, Object> count() {
        Integer total = jdbc.queryForObject("SELECT COUNT(*) FROM orders", Integer.class);
        return Map.of("orders", total == null ? 0 : total);
    }
}
