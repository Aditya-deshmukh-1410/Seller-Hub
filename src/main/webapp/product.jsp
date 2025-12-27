<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Seller" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.GetConnection" %>
<%@ page import="dao.SellerDAO" %>
<%@ page import="model.Product_pojo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.concurrent.atomic.AtomicInteger" %>

<%
    // Session check
    Seller seller = (Seller) session.getAttribute("seller");
    if (seller == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String sellerPortId = seller.getPortId();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/product.css">
    <link rel="icon" type="image/png"
      href="<%= request.getContextPath() %>/image/logo.png?v=2">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
<body>

<nav class="navbar navbar-expand-md navbar-custom">
    <div class="container-fluid">

        <!-- Brand -->
        <a class="navbar-brand" href="startDash.jsp">Seller Dashboard</a>

        <!-- ✅ Hamburger button (mobile only) -->
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarMenu"
                aria-controls="navbarMenu"
                aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- ✅ Collapsible Menu -->
        <div class="collapse navbar-collapse" id="navbarMenu">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("startDash.jsp") ? "active" : "" %>"
                       href="startDash.jsp">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("product.jsp") ? "active" : "" %>"
                       href="product.jsp">Products</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("order.jsp") ? "active" : "" %>"
                       href="OrderServlet">Orders</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/dashboard/reports">Reports</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="dashboard.jsp">Profile</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-danger" href="LogoutServlet">Logout</a>
                </li>

                <!-- 🌙 Dark mode button moves inside menu (mobile friendly) -->
                <li class="nav-item ms-lg-3">
                    <button id="darkModeToggle"
                            class="btn btn-dark toggle-btn">
                        <i class="fas fa-moon"></i>
                    </button>
                </li>
            </ul>
        </div>

    </div>
</nav>

<div class="container py-4">
    <div class="card card-custom mb-4 p-3 d-flex flex-row justify-content-between align-items-center">
        <h2 class="fw-bold text-primary-dark mb-0">Manage Products</h2>
        <div class="d-flex align-items-center">
            <span class="text-muted">Welcome, <b><%= seller.getName() %></b></span>
            <img src="https://cdn-icons-png.flaticon.com/512/4140/4140037.png" class="ms-2 profile-img" alt="Profile">
        </div>
    </div>

    <div class="row">
        <div class="col-md-4">
            <div class="card card-custom p-3 mb-4">
                <h5 class="text-center mb-3 text-primary-dark">Product Form</h5>
                <form name="productForm" method="post" action="ProductServlet">
                    <input type="hidden" name="product_id">
                    <input type="hidden" name="action">
                    <div class="mb-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" name="product_name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" name="quantity" min="0" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price</label>
                        <input type="number" name="price" min="0" step="0.01" class="form-control" required>
                    </div>
                    <div class="d-flex flex-column gap-2">
                        <button type="submit" onclick="setAction('add')" class="btn btn-add w-100">Add</button>
                        <button type="submit" onclick="setAction('update')" class="btn btn-update w-100">Update</button>
                        <button type="button" class="btn btn-delete w-100" onclick="confirmDelete()">Delete</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card card-custom p-3">
                <h5 class="mb-3 text-primary-dark">All Products (Click a row to edit)</h5>
                <div class="table-responsive">
                    <table class="table table-hover text-center">
                        <thead>
                            <tr>
                                <th class="table-custom-cell">Product ID</th>
                                <th class="table-custom-cell">Product Name</th>
                                <th class="table-custom-cell">Description</th>
                                <th class="table-custom-cell">Quantity</th>
                                <th class="table-custom-cell">Price</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            try {
                                SellerDAO sellerDao = new SellerDAO();
                                List<Product_pojo> products = sellerDao.getProductsBySeller(sellerPortId);
                                for (Product_pojo p : products) {
                        %>
                        <tr onclick="fillForm('<%= p.getProductId() %>', '<%= p.getProductname().replace("'", "\\'") %>', '<%= p.getDescription().replace("'", "\\'") %>', '<%= p.getQuantity() %>', '<%= p.getPrice() %>')">
                            <td><%= p.getProductId() %></td>
                            <td><%= p.getProductname() %></td>
                            <td><%= p.getDescription() %></td>
                            <td><%= p.getQuantity() %></td>
                            <td><%= p.getPrice() %></td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Dark mode toggle functionality
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

    function fillForm(id, name, desc, qty, price) {
        document.forms["productForm"]["product_id"].value = id;
        document.forms["productForm"]["product_name"].value = name;
        document.forms["productForm"]["description"].value = desc;
        document.forms["productForm"]["quantity"].value = qty;
        document.forms["productForm"]["price"].value = price;
    }
    function setAction(actionType) {
        document.forms["productForm"]["action"].value = actionType;
    }
    function confirmDelete() {
        const productId = document.forms["productForm"]["product_id"].value;
        if (!productId) {
            Swal.fire({ title: "Error!", text: "Please select a product to delete.", icon: "error" });
            return;
        }
        Swal.fire({
            title: "Are you sure?",
            text: "This will permanently delete the product.",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#dc2626",
            cancelButtonColor: "#6b7280",
            confirmButtonText: "Yes, delete it!"
        }).then((result) => {
            if (result.isConfirmed) {
                document.forms["productForm"]["action"].value = "delete";
                document.forms["productForm"].submit();
            }
        });
    }

    <%
    String message = request.getParameter("msg");
    String type = request.getParameter("type");
    if (message != null) {
        if (type == null) type = "success";
    %>
    Swal.fire({
        icon: '<%= type %>',
        title: '<%= message %>',
        showConfirmButton: false,
        timer: 2000
    });
    <% } %>
</script>
</body>
</html>