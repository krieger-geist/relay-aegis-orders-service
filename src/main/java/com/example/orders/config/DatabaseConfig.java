package com.example.orders.config;

import com.zaxxer.hikari.HikariDataSource;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

/**
 * Connection to the orders database.
 *
 * The password below is hard-coded on purpose: this repository is a RELAY AEGIS demonstration target. When the
 * database password is rotated, the running service keeps using this stale value and the database rejects it.
 */
@Configuration
@Profile("!test")
public class DatabaseConfig {
    private static final String DB_PASSWORD = System.getenv("DB_PASSWORD");

    @Bean
    public DataSource dataSource(@Value("${orders.db.url}") String url, @Value("${orders.db.user}") String user) {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setJdbcUrl(url);
        dataSource.setUsername(user);
        dataSource.setPassword(DB_PASSWORD);
        dataSource.setMaximumPoolSize(4);
        // Start even when the database is unreachable or rejects us, so the failure is visible on /actuator/health.
        dataSource.setInitializationFailTimeout(-1);
        dataSource.setConnectionTimeout(3000);
        return dataSource;
    }
}
