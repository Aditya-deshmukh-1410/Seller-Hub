<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,model.Report" %>
<%@ page import="model.Seller" %>
<%@ page import="dao.SellerDAO" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Session check
    Seller seller = (Seller) session.getAttribute("seller");
    if (seller == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Seller Dashboard - Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/reports.css">
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

<div class="container-fluid main-content">
    <jsp:include page="/shared/flash.jsp"/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary-dark mb-0"> Report Overview</h2>
        <div class="d-flex align-items-center">
            <span class="text-muted-dark me-2">Welcome, <b><%= seller.getName() %></b></span>
            <img src="https://cdn-icons-png.flaticon.com/512/4140/4140037.png" class="profile-pic" alt="Profile">
        </div>
    </div>

    <div class="card-custom mb-4 p-4">
        <form class="row g-3" method="get" action="">
            <div class="col-md-4">
                <input class="form-control" type="text" name="q" value="${param.q}" placeholder="Search reporter / product / reason">
            </div>
            <div class="col-md-2">
                <select class="form-select" name="status">
                    <option value="">All Status</option>
                    <option value="open" ${param.status=='open' ? 'selected' : ''}>Open</option>
                    <option value="resolved" ${param.status=='resolved' ? 'selected' : ''}>Resolved</option>
                </select>
            </div>
            <div class="col-md-2">
                <select class="form-select" name="sort">
                    <option value="reported_at" ${param.sort=='reported_at' ? 'selected' : ''}>Date</option>
                    <option value="product_name" ${param.sort=='product_name' ? 'selected' : ''}>Product</option>
                    <option value="status" ${param.sort=='status' ? 'selected' : ''}>Status</option>
                </select>
            </div>
            <div class="col-md-2">
                <select class="form-select" name="dir">
                    <option value="DESC" ${param.dir=='DESC' ? 'selected' : ''}>Desc</option>
                    <option value="ASC" ${param.dir=='ASC' ? 'selected' : ''}>Asc</option>
                </select>
            </div>
            <div class="col-md-2">
                <button class="btn btn-custom-primary w-100">Apply</button>
            </div>
        </form>
    </div>

    <div class="row g-4">
        <%
            List<Report> reports = (List<Report>) request.getAttribute("reports");
            if (reports == null || reports.isEmpty()) {
        %>
        <div class="col-12">
            <div class="alert alert-warning text-center card-custom"> No reports found.</div>
        </div>
        <%
            } else {
              for (Report r : reports) {
        %>
        <div class="col-md-6 col-lg-4">
            <div class="card report-card h-100">
                <div class="card-body">
                    <h5 class="card-title fw-bold"><%= r.getProductName() %></h5>
                    <p class="text-muted-dark mb-1"><small>Reporter: <%= r.getReporterId() %></small></p>
                    <p class="text-muted-dark"><%= r.getReason() %></p>
                    <p class="mb-1 text-muted-dark"><small><b>Reported At:</b> <%= r.getReportedAt() %></small></p>
                    <span class="status-badge <%= "open".equals(r.getStatus()) ? "status-open" : "status-resolved" %>">
                        <%= r.getStatus().toUpperCase() %>
                    </span>
                </div>
                <div class="card-footer text-end border-0 bg-transparent">
                    <a class="btn btn-outline-primary btn-sm"
                       href="<%=request.getContextPath()%>/dashboard/reports?action=view&id=<%=r.getReportId()%>">
                        View
                    </a>
                </div>
            </div>
        </div>
        <%
              }
            }
        %>
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