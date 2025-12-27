package dao;

import java.sql.*;
import java.util.*;
import model.Order;

public class OrdersDAO {
    private Connection conn;

    
    public OrdersDAO() throws SQLException {
        this.conn = GetConnection.getConnection();
    }

   
    public List<Order> getOrdersBySeller(String sellerPortId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE seller_port_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sellerPortId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("buyer_id"),
                        rs.getString("seller_port_id"),
                        rs.getTimestamp("order_date"),
                        rs.getDouble("total_amount"),
                        rs.getString("status"),
                        rs.getString("delivery_address")
                    );
                    list.add(o);
                }
            }
        }
        return list;
    }

    
    public void updateStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }
}
