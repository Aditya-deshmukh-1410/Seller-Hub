package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.List;

import model.Product_pojo;
import model.Seller;

public class SellerDAO {

    // Register seller
    public String registerSeller(Seller s) {
        String sql = "INSERT INTO sellers (port_id, password, name, email, location) VALUES (?,?,?,?,?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, s.getPortId());
            ps.setString(2, s.getPassword());
            ps.setString(3, s.getName());
            ps.setString(4, s.getEmail());
            ps.setString(5, s.getLocation());

            int rows = ps.executeUpdate();
            return rows > 0 ? "SUCCESS" : "ERROR";

        } catch (SQLIntegrityConstraintViolationException e) {
            // Duplicate port_id
            System.out.println("Duplicate entry for port_id: " + s.getPortId());
            return "DUPLICATE";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    // Login seller
    public Seller loginSeller(String portId, String password) {
        String sql = "SELECT * FROM sellers WHERE port_id=? AND password=?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, portId);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Seller(
                        rs.getString("port_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("location"),
                        rs.getString("password")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update seller profile
    public void updateSeller(Seller s) {
        String sql = "UPDATE sellers SET name=?, email=?, location=?, password=? WHERE port_id=?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getLocation());
            ps.setString(4, s.getPassword());
            ps.setString(5, s.getPortId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete seller
    public void deleteSeller(String portId) {
        String sql = "DELETE FROM sellers WHERE port_id=?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, portId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get products by seller
    public List<Product_pojo> getProductsBySeller(String sellerPortId) {
        List<Product_pojo> products = new ArrayList<>();
        String sql = "SELECT * FROM information WHERE seller_port_id=?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }
}
