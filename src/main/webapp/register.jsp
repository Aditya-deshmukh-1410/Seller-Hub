<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Seller" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register for Seller ERP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="icon" type="image/png"
      href="<%= request.getContextPath() %>/image/logo.png?v=2">

    </head>
<body>

<div class="full-page-container">
    <div class="card register-card" style="max-width: 900px; width: 100%;">
        <button id="darkModeToggle" class="toggle-btn" aria-label="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </button>
        <div class="row g-0">
            
            <div class="col-md-6 d-none d-md-flex illustration-side">
                <div class="content">
                    <h3 class="fw-bold">Join the Global Trade Network</h3>
                    <p>Register to manage your products and streamline your import-export operations.</p>
                    <img src="https://api.dicebear.com/7.x/shapes/svg?seed=Register&size=200"
                                alt="Register Illustration" class="img-fluid my-4">
                    <a href="login.jsp" class="btn btn-outline-light mt-3">Already have an account? Login here.</a>
                </div>
            </div>
            
            <div class="col-md-6 form-side">
                <h3 class="text-center mb-4">Create Your Account</h3>
                
                <form class="needs-validation" action="RegisterServlet" method="post" novalidate>
                    <div class="mb-3">
                        <label for="port_id" class="form-label">Port ID</label>
                        <input type="text" placeholder="e.g. port1001" class="form-control" id="port_id" name="port_id"
                                value="<%= (request.getAttribute("seller") != null) ? ((Seller) request.getAttribute("seller")).getPortId() : "" %>" required>
                        <div class="invalid-feedback">Please enter a Port ID.</div>
                    </div>

                    <div class="mb-3">
                        <label for="name" class="form-label">Name</label>
                        <input type="text" placeholder="e.g. Ram Verma" class="form-control" id="name" name="name"
                                value="<%= (request.getAttribute("seller") != null) ? ((Seller) request.getAttribute("seller")).getName() : "" %>" required>
                        <div class="invalid-feedback">Please enter your name.</div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" placeholder="e.g. abc12@gmail.com" class="form-control" id="email" name="email"
                                value="<%= (request.getAttribute("seller") != null) ? ((Seller) request.getAttribute("seller")).getEmail() : "" %>" required>
                        <div class="invalid-feedback">Please provide a valid email.</div>
                    </div>

                    <div class="mb-3">
                        <label for="location" class="form-label">Location</label>
                        <input type="text" placeholder="e.g. Mumbai" class="form-control" id="location" name="location"
                                value="<%= (request.getAttribute("seller") != null) ? ((Seller) request.getAttribute("seller")).getLocation() : "" %>" required>
                        <div class="invalid-feedback">Please provide your location.</div>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" placeholder="Enter at least 4 characters" class="form-control" id="password" name="password"
                                value="<%= (request.getAttribute("seller") != null) ? ((Seller) request.getAttribute("seller")).getPassword() : "" %>" required minlength="4">
                        <div class="invalid-feedback">Password must be at least 4 characters.</div>
                    </div>

                    <button type="submit" class="btn btn-success w-100">Register</button>
                </form>
                <div class="text-center mt-3 d-md-none">
                    <a href="login.jsp" class="text-muted">Already have an account? Login</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // SweetAlert2 for error messages
    <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
    <% if (errorMsg != null) { %>
    Swal.fire({
        icon: 'error',
        title: 'Registration Failed!',
        text: '<%= errorMsg %>'
    });
    <% } %>

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

    // Bootstrap form validation
    const form = document.querySelector('.needs-validation');
    form.addEventListener('submit', event => {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    }, false);
</script>

</body>
</html>