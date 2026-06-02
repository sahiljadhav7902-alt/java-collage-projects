<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllUserMaster" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Registration - Pathology Lab System</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f4fdfc;
            color: #2d3748;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 10px 0; /* Add some padding for small screens */
        }

        .register-card {
            max-width: 800px; /* Increased width for two columns */
            width: 100%;
            background: #ffffff;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            border: none;
        }

        .title {
            font-weight: 700;
            color: #2b6cb0;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #4a5568;
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }

        .form-label {
            font-weight: 600;
            color: #2d3748;
        }

        .input-group-text {
            background-color: #f7fafc;
            border: 1px solid #e2e8f0;
            color: #2b6cb0;
        }

        .form-control {
            border: 1px solid #e2e8f0;
        }

        .form-control:focus {
            border-color: #2b6cb0;
            box-shadow: 0 0 0 0.2rem rgba(43, 108, 176, 0.25);
        }

        .form-select:focus {
            border-color: #2b6cb0;
            box-shadow: 0 0 0 0.2rem rgba(43, 108, 176, 0.25);
        }

        .btn-primary {
            background-color: #2b6cb0;
            border-color: #2b6cb0;
            font-weight: 600;
            padding: 0.75rem;
        }

        .btn-primary:hover {
            background-color: #2c5282;
            border-color: #2c5282;
        }

        .btn-outline-primary {
            color: #2b6cb0;
            border-color: #2b6cb0;
        }

        .btn-outline-primary:hover {
            background-color: #2b6cb0;
            border-color: #2b6cb0;
        }

        a {
            color: #2b6cb0;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .main-icon {
            font-size: 3rem;
            color: #2b6cb0;
        }
    </style>
</head>

<body>

<div class="register-card">
    <div class="text-center mb-4">
        <i class="bi bi-person-badge main-icon"></i>
        <h3 class="title mt-3">Staff Registration</h3>
        <p class="subtitle">Create a new doctor account by admin</p>
    </div>

    <%
        String message = null;
        String messageType = null;

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String userType = request.getParameter("user_type");
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String licenseNumber = request.getParameter("license_number");
            String certification = request.getParameter("certification");

            BllUserMaster bll = new BllUserMaster();
            message = bll.registerDoctorOrAdmin(userType, firstName, lastName, email, password, phone, address, licenseNumber, certification);

            if (message != null && message.contains("registration successful"))
                messageType = "success";
            else
                messageType = "danger";
        }
    %>

    <% if (message != null) { %>
        <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
            <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <form action="register.jsp" method="post">
        <!-- Account Type (Full Width) -->
        <div class="row">
            <div class="col-12 mb-3">
                <label for="user_type" class="form-label">Account Type</label>
                 
                <select class="form-select" id="user_type" name="user_type" required>
                    <option value="" selected disabled>Select Account Type</option>
                    <option value="physician">physician</option>
                    <!--<option value="admin">Administrator</option>-->
                </select>
            </div>
        </div>

        <!-- First Name & Last Name -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="first_name" class="form-label">First Name</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" id="first_name" name="first_name" placeholder="First Name" required>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="last_name" class="form-label">Last Name</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" id="last_name" name="last_name" placeholder="Last Name" required>
                </div>
            </div>
        </div>

        <!-- Email & Password -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="email" class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email Address" required>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password (min 6 chars)" minlength="6" required>
                </div>
            </div>
        </div>

        <!-- Phone & Address -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="phone" class="form-label">Phone Number</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
                    <input type="text" class="form-control" id="phone" name="phone" placeholder="Phone Number" required>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="address" class="form-label">Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-house"></i></span>
                    <input type="text" class="form-control" id="address" name="address" placeholder="Address">
                </div>
            </div>
        </div>
        
        <!-- License Number & Certification -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="license_number" class="form-label">License Number</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                    <input type="text" class="form-control" id="license_number" name="license_number" placeholder="License Number (for doctors)">
                </div>
            </div>
            </div>
     
        <!-- Submit Button (Full Width) -->
        <div class="row">
            <div class="col-12 mt-3">
                <button class="btn btn-primary w-100 py-2" type="submit">
                    <i class="bi bi-person-plus me-2"></i>Create Staff Account
                </button>
            </div>
        </div>
    </form>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>