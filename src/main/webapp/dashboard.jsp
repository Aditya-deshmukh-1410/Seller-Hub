<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Seller" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    if(session == null || session.getAttribute("seller") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Seller seller = (Seller) session.getAttribute("seller");

    String profilePic = "https://api.dicebear.com/7.x/shapes/svg?seed=" + seller.getPortId();

    // Dummy values
    double avgRating = 4.2;
    int totalReviews = 128;
    DecimalFormat df = new DecimalFormat("#.#");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Seller Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="icon" type="image/png"
      href="<%= request.getContextPath() %>/image/logo.png?v=2">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #4f46e5;
            --success-color: #10b981;
            --danger-color: #dc2626;
            --warning-color: #f59e0b;
            --info-color: #0d6efd;
            --bg-start-color: #f8f9fa;
            --bg-end-color: #e9f2ff;
            --card-bg-color: #ffffff;
            --text-color: #1f2937;
            --text-secondary-color: #4b5563;
            --card-border-color: #e2e8f0;
            --navbar-bg-color: #1f2937;
            --navbar-text-color: #e2e8f0;
        }

        /* --- Dark Mode Variables --- */
        body.dark-mode {
            --bg-start-color: #1a202c;
            --bg-end-color: #2d3748;
            --card-bg-color: #2d3748;
            --text-color: #e2e8f0;
            --text-secondary-color: #9ca3af;
            --primary-color: #63b3ed;
            --secondary-color: #9f7aea;
            --success-color: #34d399;
            --danger-color: #f87171;
            --warning-color: #fcd34d;
            --info-color: #38bdf8;
            --card-border-color: #4a5568;
            --navbar-bg-color: #1a202c;
            --navbar-text-color: #e2e8f0;
        }

        /* --- Base Styles --- */
        body {
            background: linear-gradient(135deg, var(--bg-start-color), var(--bg-end-color));
            font-family: 'Poppins', sans-serif;
            color: var(--text-color);
            min-height: 100vh;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        
        .main-content {
            padding: 2rem;
        }

        /* --- Navbar --- */
        .navbar-custom {
            position: sticky;
            top: 0;
            z-index: 1000;
            background: var(--navbar-bg-color);
            padding: 1rem;
            border-bottom: 2px solid var(--primary-color);
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .navbar-custom .navbar-brand {
            font-weight: 600;
            color: var(--navbar-text-color) !important;
        }
        
        .nav-link {
            font-weight: 600;
            color: var(--navbar-text-color) !important;
            transition: color 0.3s ease;
        }
        
        .nav-link.active {
            color: var(--primary-color) !important;
        }

        .toggle-btn {
            background: transparent;
            border: none;
            color: var(--navbar-text-color);
            font-size: 1.5rem;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        
        .toggle-btn:hover {
            color: var(--primary-color);
        }

        body.dark-mode .navbar-custom {
            background-color: var(--navbar-bg-color);
            border-bottom: 2px solid var(--primary-color);
        }
        
        body.dark-mode .nav-link {
            color: var(--navbar-text-color) !important;
        }
        
        body.dark-mode .nav-link.active {
            color: var(--primary-color) !important;
        }

        /* --- Main Content --- */
        .card-custom {
            border: none;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            background: var(--card-bg-color);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        
        body.dark-mode .card-custom {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
            background: var(--card-bg-color);
        }
        
        .text-primary-dark {
            color: var(--primary-color) !important;
            font-weight: 700;
        }
        
        body.dark-mode .text-primary-dark {
            color: var(--primary-color) !important;
        }

        .text-muted-dark {
            color: var(--text-secondary-color) !important;
        }
        
        .profile-pic {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary-color);
        }
        
        body.dark-mode .profile-pic {
            border-color: var(--primary-color);
        }

        .profile-pic-wrapper {
            display: flex;
            justify-content: center;
            margin-bottom: 1rem;
        }

        .rating-stars { 
            color: var(--warning-color); 
            font-size: 18px; 
            font-weight: 600;
        }
        
        .form-control {
            border-radius: 10px;
            background-color: var(--bg-start-color);
            color: var(--text-color);
            border-color: var(--card-border-color);
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }
        
        body.dark-mode .form-control {
            background-color: #3f4756;
            color: var(--text-color);
            border-color: var(--card-border-color);
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
        }

        .form-label {
            color: var(--text-secondary-color);
        }
        
        body.dark-mode .form-label {
            color: var(--text-secondary-color);
        }

        .btn-save { background: var(--success-color); color: white; }
        .btn-delete { background: var(--danger-color); color: white; }
        .btn-logout { background: var(--danger-color); color: white; }

        .btn-save:hover, .btn-delete:hover, .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }
        .btn-save:hover { background: #0d9d6a; }
        .btn-delete:hover { background: #b91c1c; }
        .btn-logout:hover { background: #b91c1c; }

        .modal-content {
            border-radius: 20px;
            background-color: var(--card-bg-color);
            color: var(--text-color);
        }
        
        body.dark-mode .modal-content {
            background-color: var(--card-bg-color);
            color: var(--text-color);
        }
        
        .modal-header, .modal-footer {
            border-color: var(--card-border-color);
        }
        
        .modal-title {
            color: var(--primary-color);
        }
        
        body.dark-mode .form-control::placeholder {
            color: var(--text-secondary-color);
        }

    </style>
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
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/dashboard/reports">Reports</a></li>
                <li class="nav-item"><a class="nav-link active" href="<%= request.getContextPath() %>/dashboard.jsp">Profile</a></li>
                <li class="nav-item"><a class="nav-link text-danger" href="<%= request.getContextPath() %>/LogoutServlet">Logout</a></li>
            </ul>
        </div>
        <button id="darkModeToggle" class="btn btn-sm ms-3 toggle-btn" aria-label="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </button>
    </div>
</nav>

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary-dark mb-0">My Profile</h2>
        
    </div>
    
    <div class="row">
        
        <div class="col-md-4">
            <div class="card card-custom p-4 text-center h-100">
                <div class="profile-pic-wrapper">
                    <img src="https://cdn-icons-png.flaticon.com/512/4140/4140037.png" class="profile-pic" alt="Profile">
                </div>
                <h4 class="fw-bold text-primary-dark"><%= seller.getName() %></h4>
                <p class="text-muted-dark"><%= seller.getEmail() %></p>
                
                <p class="text-muted-dark mt-2">
                    A dedicated seller specializing in high-quality electronics. <br>
                    We pride ourselves on fast shipping and excellent customer service.
                </p>

                <div class="mt-2">
                    <span class="rating-stars"><i class="fas fa-star"></i> <%= df.format(avgRating) %></span>
                    <p class="text-muted-dark mb-0"><%= totalReviews %> Reviews</p>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card card-custom p-4 h-100">
                <h5 class="mb-3 fw-bold text-primary-dark">Edit Profile</h5>
                
                <form id="updateForm" action="UpdateServlet" method="post" class="needs-validation" novalidate>
                    <div class="form-group mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-control" name="password" value="<%= seller.getPassword() %>" required minlength="4">
                        <div class="invalid-feedback">Password must be at least 4 characters.</div>
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-label">Location</label>
                        <input type="text" class="form-control" name="location" value="<%= seller.getLocation() %>" required>
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" value="<%= seller.getName() %>" required>
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" value="<%= seller.getEmail() %>" required>
                    </div>
                    
                                        <input type="hidden" name="port_id" value="<%= seller.getPortId() %>">

                    <button type="button" class="btn btn-save w-100 mt-4" data-bs-toggle="modal" data-bs-target="#saveModal">
                        Save Changes
                    </button>
                </form>

                <form id="deleteForm" action="DeleteServlet" method="post" class="mt-3">
                    <button type="button" class="btn btn-delete w-100" data-bs-toggle="modal" data-bs-target="#deleteModal">
                        Delete Account
                    </button>
                </form>

            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="saveModal" tabindex="-1" aria-labelledby="saveModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="saveModalLabel">Confirm Update</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to save these changes to your profile?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-save" onclick="document.getElementById('updateForm').submit();">
                    Yes, Save
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to <strong>delete your account</strong>? This action cannot be undone.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-delete" onclick="document.getElementById('deleteForm').submit();">
                    Yes, Delete
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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

    // --- Handle Active Nav Link ---
    document.addEventListener('DOMContentLoaded', function() {
        const navLinks = document.querySelectorAll('.nav-link');
        const currentPath = window.location.pathname;
        navLinks.forEach(link => {
            if (link.getAttribute('href').includes(currentPath.split('/').pop())) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    });

    // --- Bootstrap form validation ---
    const forms = document.querySelectorAll('.needs-validation');
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
</script>
</body>
</html>