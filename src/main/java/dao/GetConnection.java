package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GetConnection {

    public static Connection getConnection() {
        // These will pull the values you set in the Render Dashboard
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            // This will help you see exactly what went wrong in Render's logs
            System.err.println("Database Connection Error. Check your Render Environment Variables.");
            throw new RuntimeException("Database connection failed!", e);
        }
    }
}