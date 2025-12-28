package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil { // or GetConnection
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 1. Load the MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Fetch credentials from Environment Variables (set in Render later)
            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");

            // 3. Establish the connection
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("Database connected successfully!");
            
        } catch (Exception e) {
            System.out.println("Connection Failed! Check your Render environment variables.");
            e.printStackTrace();
        }
        return conn;
    }
}