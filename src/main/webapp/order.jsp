<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,model.Order" %>
<%@ page import="dao.SellerDAO" %>
<%@ page import="model.Seller" %>
<%@ page import="model.Product_pojo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Session check
    Seller seller = (Seller) session.getAttribute("seller");
    if (seller == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String sellerPortId = seller.getPortId();
    // Retrieve orders from request attribute set by OrderServlet
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard - Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/order.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="icon" type="image/png"
      href="<%= request.getContextPath() %>/image/logo.png?v=2">
    
    </head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="startDash.jsp">Seller Dashboard</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="startDash.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="product.jsp">Products</a></li>
                <li class="nav-item"><a class="nav-link active" href="OrderServlet">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="dashboard/reports">Reports</a></li>
                <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Profile</a></li>
                <li class="nav-item"><a class="nav-link text-danger" href="LogoutServlet">Logout</a></li>
            </ul>
        </div>
        <button id="darkModeToggle" class="btn btn-sm ms-3 toggle-btn" aria-label="Toggle dark mode"><i class="fas fa-moon"></i></button>
    </div>
</nav>

<div class="container-fluid main-content">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary-dark mb-0">Manage Orders</h2>
        <div class="d-flex align-items-center">
            <span class="text-muted-dark me-2">Welcome, <b><%= seller.getName() %></b></span>
            <img src="https://cdn-icons-png.flaticon.com/512/4140/4140037.png" class="profile-pic" alt="Profile">
        </div>
    </div>
    
    <%
        int pending = 0, delivered = 0, cancelled = 0, shipped = 0;
        if (orders != null) {
            for (Order o : orders) {
                switch (o.getStatus()) {
                    case "Pending": pending++; break;
                    case "Delivered": delivered++; break;
                    case "Cancelled": cancelled++; break;
                    case "Shipped": shipped++; break;
                }
            }
        }
    %>

    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card-custom text-center p-3">
                <h6 class="text-muted-dark">Total Orders</h6>
                <h4 class="fw-bold text-primary-dark"><%= (orders != null) ? orders.size() : 0 %></h4>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card-custom text-center p-3">
                <h6 class="text-muted-dark">Pending</h6>
                <h4 class="fw-bold text-warning"><%= pending %></h4>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card-custom text-center p-3">
                <h6 class="text-muted-dark">Shipped</h6>
                <h4 class="fw-bold text-info"><%= shipped %></h4>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card-custom text-center p-3">
                <h6 class="text-muted-dark">Delivered</h6>
                <h4 class="fw-bold text-success"><%= delivered %></h4>
            </div>
        </div>
    </div>

    <div class="card-custom p-3">
        <h5 class="mb-3 text-primary-dark">All Orders</h5>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th class="table-custom-cell">Order ID</th>
                        <th class="table-custom-cell">Buyer ID</th>
                        <th class="table-custom-cell">Order Date</th>
                        <th class="table-custom-cell">Total Amount</th>
                        <th class="table-custom-cell">Delivery Address</th>
                        <th class="table-custom-cell">Status</th>
                        <th class="text-center table-custom-cell">Update</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (orders != null && !orders.isEmpty()) {
                        for (Order o : orders) {
                %>
                    <tr>
                        <td><%= o.getOrderId() %></td>
                        <td><%= o.getBuyerId() %></td>
                        <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(o.getOrderDate()) %></td>
                        <td>$<%= o.getTotalAmount() %></td>
                        <td><%= o.getDeliveryAddress() %></td>
                        <td>
                            <span class="badge rounded-pill
                                <%= o.getStatus().equals("Pending") ? "bg-warning text-dark" :
                                    o.getStatus().equals("Shipped") ? "bg-info text-dark" :
                                    o.getStatus().equals("Delivered") ? "bg-success" : "bg-danger" %>">
                                <%= o.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <form method="post" action="OrderServlet" class="d-flex justify-content-center">
                                <input type="hidden" name="order_id" value="<%= o.getOrderId() %>" />
                                <input type="hidden" name="seller_port_id" value="<%= o.getSellerPortId() %>" />
                                <select name="status" class="form-select form-select-sm me-2" style="max-width: 140px;">
                                    <option value="Pending" <%= o.getStatus().equals("Pending")?"selected":"" %>>Pending</option>
                                    <option value="Shipped" <%= o.getStatus().equals("Shipped")?"selected":"" %>>Shipped</option>
                                    <option value="Delivered" <%= o.getStatus().equals("Delivered")?"selected":"" %>>Delivered</option>
                                    <option value="Cancelled" <%= o.getStatus().equals("Cancelled")?"selected":"" %>>Cancelled</option>
                                </select>
                                <button type="submit" class="btn btn-update">Update</button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr><td colspan="7" class="text-center text-muted-dark">No orders found</td></tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // --- Dark Mode Toggle Logic ---
    const darkModeToggle = document.getElementById('darkModeToggle');
    const body = document.body;

    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
    }

    darkModeToggle.addEventListener('click', () => {
        if (body.classList.contains('dark-mode')) {
            body.classList.remove('dark-mode');
            localStorage.setItem('theme', 'light');
        } else {
            body.classList.add('dark-mode');
            localStorage.setItem('theme', 'dark');
        }
    });

    // --- SweetAlert for Update Success ---
    const urlParams = new URLSearchParams(window.location.search);
    const msg = urlParams.get("msg");
    if (msg) {
        Swal.fire({
            icon: 'success',
            title: msg,
            showConfirmButton: false,
            timer: 2000
        });
    }

    // --- Handle Active Nav Link ---
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname.split('/').pop();
        const navLinks = document.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            if (link.getAttribute('href').includes(currentPath)) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    });
</script>

</body>
</html>
