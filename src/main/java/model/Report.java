package model;

import java.time.LocalDateTime;

public class Report{
    private int reportId;
    private int productId;
    private String productName;
    private String reporterId;
    private String reason;
    private LocalDateTime reportedAt;
    private String status; // 'open' or 'resolved'

    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getReporterId() { return reporterId; }
    public void setReporterId(String reporterId) { this.reporterId = reporterId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public LocalDateTime getReportedAt() { return reportedAt; }
    public void setReportedAt(LocalDateTime reportedAt) { this.reportedAt = reportedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
