<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login to Seller ERP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">
    <link rel="icon" type="image/png"
      href="<%= request.getContextPath() %>/image/logo.png?v=2">
    </head>
    
    
<body class="d-flex justify-content-center align-items-center">

<div class="card shadow-lg login-card" style="max-width: 450px; width: 100%;">
    
    <button id="darkModeToggle" class="toggle-btn" aria-label="Toggle dark mode">
        <i class="fas fa-moon"></i>
    </button>
    
    <div class="text-center mb-4">
        <img src="https://api.dicebear.com/7.x/shapes/svg?seed=ERPLogo&size=80"
             alt="Logo" class="brand-logo mb-3 rounded-circle border bg-white p-1">
        <h3 class="fw-bold">Welcome Back</h3>
        <p class="text-muted">Sign in to continue</p>
    </div>

    <form class="needs-validation" action="LoginServlet" method="post" novalidate>
        <div class="mb-3">
            <label for="port_id" class="form-label">Port ID</label>
            <input type="text" class="form-control" id="port_id" name="port_id" required>
            <div class="invalid-feedback">Please enter your Port ID.</div>
        </div>

        <div class="mb-4">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required minlength="4">
            <div class="invalid-feedback">Please enter a valid password (min 4 characters).</div>
        </div>

        <button type="submit" class="btn btn-primary btn-lg w-100">Login</button>
    </form>

    <div class="text-center mt-4">
        <span class="text-muted">Don’t have an account?</span>
        <a href="register.jsp" class="btn btn-outline-success w-100 mt-2">Register</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    // SweetAlert2 for messages
    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');
    const deleted = urlParams.get('deleted');
    const registered = urlParams.get('registered');

    if (error) {
        Swal.fire({
            icon: 'error',
            title: 'Login Failed!',
            text: 'Invalid credentials! Please try again or register.',
        });
    } else if (deleted) {
        Swal.fire({
            icon: 'warning',
            title: 'Account Deleted',
            text: 'Your account has been deleted. Please register again to continue.',
        });
    } else if (registered) {
        Swal.fire({
            icon: 'success',
            title: 'Registration Successful!',
            text: 'You can now log in with your new credentials.',
        });
    }

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