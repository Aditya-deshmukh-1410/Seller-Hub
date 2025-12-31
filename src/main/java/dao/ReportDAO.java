package dao;

import model.Report;
import java.sql.*;
import java.util.*;

public class ReportDAO {

    private static final String BASE_SELECT =
        "SELECT r.report_id, r.product_id, i.product_name, r.reporter_id, r.reason, r.reported_at, r.status " +
        "FROM reported_products r JOIN information i ON i.product_id = r.product_id " +
        "WHERE i.seller_port_id = ? ";

    public List<Report> listBySeller(String sellerPortId, String status, String q,
                                     int page, int size, String sortCol, String sortDir) throws SQLException {

        StringBuilder sql = new StringBuilder(BASE_SELECT);
        List<Object> params = new ArrayList<>();
        params.add(sellerPortId);

        if (status != null && !status.isBlank()) {
            sql.append("AND r.status = ? ");
            params.add(status);
        }
        if (q != null && !q.isBlank()) {
            sql.append("AND (i.product_name LIKE ? OR r.reason LIKE ? OR r.reporter_id LIKE ?) ");
            String like = "%" + q + "%";
            params.add(like); params.add(like); params.add(like);
        }

        // Whitelist sort columns
        Set<String> allowedCols = Set.of("reported_at","product_name","status");
        if (sortCol == null || !allowedCols.contains(sortCol)) sortCol = "reported_at";
        String dir = "DESC".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";
        sql.append("ORDER BY ").append(sortCol).append(" ").append(dir).append(" ");
        sql.append("LIMIT ? OFFSET ?");

        params.add(size);
        params.add(Math.max(0, (page - 1) * size)); 

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                List<Report> out = new ArrayList<>();
                while (rs.next()) {
                    Report r = new Report();
                    r.setReportId(rs.getInt("report_id"));
                    r.setProductId(rs.getInt("product_id"));
                    r.setProductName(rs.getString("product_name"));
                    r.setReporterId(rs.getString("reporter_id"));
                    r.setReason(rs.getString("reason"));
                    Timestamp t = rs.getTimestamp("reported_at");
                    if (t != null) r.setReportedAt(t.toLocalDateTime());
                    r.setStatus(rs.getString("status"));
                    out.add(r);
                }
                return out;
            }
        }
    }

    public int countBySeller(String sellerPortId, String status, String q) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM reported_products r JOIN information i ON i.product_id = r.product_id WHERE i.seller_port_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(sellerPortId);

        if (status != null && !status.isBlank()) { sql.append("AND r.status = ? "); params.add(status); }
        if (q != null && !q.isBlank()) {
            sql.append("AND (i.product_name LIKE ? OR r.reason LIKE ? OR r.reporter_id LIKE ?) ");
            String like = "%" + q + "%";
            params.add(like); params.add(like); params.add(like);
        }

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public Report findOne(int reportId, String sellerPortId) throws SQLException {
        String sql = BASE_SELECT + "AND r.report_id = ? LIMIT 1";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sellerPortId);
            ps.setInt(2, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Report r = new Report();
                r.setReportId(rs.getInt("report_id"));
                r.setProductId(rs.getInt("product_id"));
                r.setProductName(rs.getString("product_name"));
                r.setReporterId(rs.getString("reporter_id"));
                r.setReason(rs.getString("reason"));
                Timestamp t = rs.getTimestamp("reported_at");
                if (t != null) r.setReportedAt(t.toLocalDateTime());
                r.setStatus(rs.getString("status"));
                return r;
            }
        }
    }

    public boolean resolve(int reportId, String sellerPortId) throws SQLException {
        String sql =
          "UPDATE reported_products r JOIN information i ON i.product_id = r.product_id " +
          "SET r.status='resolved' WHERE r.report_id=? AND i.seller_port_id=? AND r.status='open'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.setString(2, sellerPortId);
            return ps.executeUpdate() == 1;
        }
    }

   
    public int create(int productId, String reporterId, String reason) throws SQLException {
        String sql = "INSERT INTO reported_products (product_id, reporter_id, reason, status) VALUES (?,?,?,'open')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, productId);
            ps.setString(2, reporterId);
            ps.setString(3, reason);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        }
    }
}
