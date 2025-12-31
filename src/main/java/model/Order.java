package model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int buyerId;
    private String sellerPortId;  
    private Timestamp orderDate;
    private double totalAmount;
    private String status;
    private String deliveryAddress;
    
    public Order(int orderId, int buyerId, String sellerPortId,
                 Timestamp orderDate, double totalAmount,
                 String status, String deliveryAddress) {
        this.orderId = orderId;
        this.buyerId = buyerId;
        this.sellerPortId = sellerPortId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.deliveryAddress = deliveryAddress;
    }
    public int getOrderId() { return orderId; }
    public int getBuyerId() { return buyerId; }
    public String getSellerPortId() { return sellerPortId; }
    public Timestamp getOrderDate() { return orderDate; }
    public double getTotalAmount() { return totalAmount; }
    public String getStatus() { return status; }
    public String getDeliveryAddress() { return deliveryAddress; }

    public void setOrderId(int orderId) { this.orderId = orderId; }
    public void setBuyerId(int buyerId) { this.buyerId = buyerId; }
    public void setSellerPortId(String sellerPortId) { this.sellerPortId = sellerPortId; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public void setStatus(String status) { this.status = status; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
}
