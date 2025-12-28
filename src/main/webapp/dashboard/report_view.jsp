<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Report" %>
<%@ page import="model.Seller" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Session check
    if (session == null || session.getAttribute("seller") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    Seller seller = (Seller) session.getAttribute("seller");
%>

<html>
<head>
    <title>Seller Dashboard - Report Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/reportview.css">
    <link rel="icon" type="image/png"
      href="<%= request.getContextPath() %>/image/logo.png?v=2">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        </head>

<body>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/startDash.jsp">Seller Dashboard</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/startDash.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/product.jsp">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/OrderServlet">Orders</a></li>
                <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/dashboard/reports">Reports</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/dashboard.jsp">Profile</a></li>
                <li class="nav-item"><a class="nav-link text-danger" href="<%= request.getContextPath() %>/LogoutServlet">Logout</a></li>
            </ul>
        </div>
        <button id="darkModeToggle" class="btn btn-sm ms-3 toggle-btn" aria-label="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </button>
    </div>
</nav>

<div class="container main-content">

    <%
        Report r = (Report) request.getAttribute("report");
        if (r == null) { out.print("<div class='alert alert-danger card-custom'>Not found</div>"); return; }
    %>

    <div class="card shadow card-custom">

        <div class="report-header">
            <h3 class="mb-0 text-white">Report #<%= r.getReportId() %></h3>
            <small class="opacity-75 text-white">Details of the reported product</small>
        </div>

        <div class="card-body">

            <div class="report-section d-flex justify-content-between">
                <span class="report-label">Product</span>
                <span class="report-value"><%= r.getProductName() %></span>
            </div>

            <div class="report-section d-flex justify-content-between">
                <span class="report-label">Reporter</span>
                <span class="report-value"><%= r.getReporterId() %></span>
            </div>

            <div class="report-section">
                <span class="report-label">Reason</span>
                <p class="report-value mt-2 mb-0"><%= r.getReason() %></p>
            </div>

            <div class="report-section d-flex justify-content-between">
                <span class="report-label">Reported At</span>
                <span class="report-value"><%= r.getReportedAt() %></span>
            </div>

            <div class="report-section d-flex justify-content-between align-items-center">
                <span class="report-label">Status</span>
                <span class="badge status-badge
                  <%= "resolved".equalsIgnoreCase(r.getStatus()) ? "status-resolved" : "status-open" %>">
                  <%= r.getStatus().toUpperCase() %>
                </span>
            </div>
        </div>

        <div class="card-footer d-flex justify-content-between">
            <a class="btn btn-back" href="<%=request.getContextPath()%>/dashboard/reports">← Back</a>
            <% if ("open".equalsIgnoreCase(r.getStatus())) { %>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#resolveModal">
                    Mark as Resolved
                </button>
            <% } %>
        </div>

    </div>
</div>

<div class="modal fade" id="resolveModal" tabindex="-1" aria-labelledby="resolveModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="resolveModalLabel">Confirm Action</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to <strong>mark this report as resolved</strong>?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>

                <form method="post" action="<%=request.getContextPath()%>/dashboard/reports" class="d-inline">
                    <input type="hidden" name="action" value="resolve"/>
                    <input type="hidden" name="report_id" value="<%=r.getReportId()%>"/>
                    <button type="submit" class="btn btn-primary">Yes, Resolve</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // --- Dark Mode Toggle Logic ---
    const darkModeToggle = document.getElementById('darkModeToggle');
    const body = document.body;

    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
    }

    function toggleTheme() {
        if (body.classList.contains('dark-mode')) {
            body.classList.remove('dark-mode');
            localStorage.setItem('theme', 'light');
        } else {
            body.classList.add('dark-mode');
            localStorage.setItem('theme', 'dark');
        }
    }

    if (darkModeToggle) {
        darkModeToggle.addEventListener('click', toggleTheme);
    }
    
    // --- Handle Active Nav Link ---
    document.addEventListener('DOMContentLoaded', function() {
        const navLinks = document.querySelectorAll('.nav-link');
        const currentPath = window.location.pathname;
        navLinks.forEach(link => {
            if (currentPath.endsWith(link.getAttribute('href').split('/').pop())) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    });
</script>

</body>
</html>