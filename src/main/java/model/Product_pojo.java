package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.GetConnection;

public class Product_pojo {
    private int productId;
    private String seller_port_id;
    private String productname;  
    private String description;
    private int quantity;
    private double price;

    // Getters and setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getSeller_port_id() { return seller_port_id; }
    public void setSeller_port_id(String seller_port_id) { this.seller_port_id = seller_port_id; }

    public String getProductname() { return productname; }
    public void setProductname(String productname) { this.productname = productname; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

 
    public void addProduct() throws SQLException {
        String sql = "INSERT INTO information (seller_port_id, product_name, description, quantity, price) VALUES (?,?,?,?,?)";
        try (Connection connection = GetConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, seller_port_id);
            ps.setString(2, productname);
            ps.setString(3, description);
            ps.setInt(4, quantity);
            ps.setDouble(5, price);  
            ps.executeUpdate();
        }
    }

    public void updateProduct() throws SQLException {
        String sql = "UPDATE information SET product_name=?, description=?, quantity=?, price=? WHERE product_id=? AND seller_port_id=?";
        try (Connection connection = GetConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, productname);
            ps.setString(2, description);
            ps.setInt(3, quantity);
            ps.setDouble(4, price);  
            ps.setInt(5, productId);
            ps.setString(6, seller_port_id);
            ps.executeUpdate();
        }
    }

    public void deleteProduct() throws SQLException {
        String sql = "DELETE FROM information WHERE product_id=? AND seller_port_id=?";
        try (Connection connection = GetConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, seller_port_id);
            ps.executeUpdate();
        }
    }

    public List<Product_pojo> getProductsBySeller(String sellerPortId) throws SQLException {
        List<Product_pojo> products = new ArrayList<>();
        String sql = "SELECT product_id, seller_port_id, product_name, description, quantity, price " +
                     "FROM information WHERE seller_port_id=?";

        try (Connection connection = GetConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, sellerPortId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product_pojo product = new Product_pojo();
                    product.setProductId(rs.getInt("product_id"));
                    product.setSeller_port_id(rs.getString("seller_port_id"));
                    product.setProductname(rs.getString("product_name"));
                    product.setDescription(rs.getString("description"));
                    product.setQuantity(rs.getInt("quantity"));
                    product.setPrice(rs.getDouble("price"));

                    products.add(product);
                }
            }
        }
        return products;
    }
}
