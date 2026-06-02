<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllUserMaster" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Registration - Pathology Lab System</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #0561FC;
            --dark-blue: #1e293b;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: radial-gradient(circle at top right, #e0f2fe 0%, #f8fafc 50%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-card {
            background: #ffffff;
            padding: 40px;
            border-radius: 24px;
            width: 100%;
            /* Wider max-width for horizontal layout */
            max-width: 850px; 
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
        }

        .brand-header {
            border-bottom: 1px solid #f1f5f9;
            margin-bottom: 30px;
            padding-bottom: 20px;
        }

        .title {
            font-weight: 700;
            color: var(--dark-blue);
        }

        /* Input Styling */
        .input-group-text {
            background: #fdfdfd;
            border-right: none;
            color: var(--primary-blue);
        }

        .form-control, .form-select {
            border-left: none;
            padding: 12px;
            background-color: #fdfdfd;
        }

        .input-group:focus-within {
            box-shadow: 0 0 0 4px rgba(5, 97, 252, 0.08);
            border-radius: 8px;
        }

        .btn-primary {
            background: var(--primary-blue);
            border: none;
            padding: 14px 30px;
            font-weight: 600;
            border-radius: 12px;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background: #044ecb;
            transform: translateY(-2px);
        }

        .footer-nav {
            background: #f8fafc;
            margin: 30px -40px -40px -40px;
            padding: 20px;
            border-radius: 0 0 24px 24px;
            display: flex;
            justify-content: center;
            gap: 20px;
            font-size: 0.85rem;
        }
    </style>
</head>

<body>
<div class="register-card">
    <div class="brand-header text-center">
        <i class="bi bi-heart-pulse-fill text-primary" style="font-size: 2.5rem;"></i>
        <h3 class="title mt-2">Patient Registration</h3>
        <p class="text-muted">Fill in your details to create a secure lab account</p>
    </div>

    <%
        String message = null;
        String messageType = null;
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String dob = request.getParameter("dob");
            String gender = request.getParameter("gender");

            BllUserMaster bll = new BllUserMaster();
            message = bll.registerPatient(firstName, lastName, email, password, phone, dob, gender);

            if (message != null && message.startsWith("Patient registration successful"))
                messageType = "success";
            else
                messageType = "danger";
        }
    %>

    <% if (message != null) { %>
        <div class="alert alert-<%= messageType %> alert-dismissible fade show mb-4" role="alert">
            <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <form action="register.jsp" method="post">
        <div class="row g-4">
            <div class="col-md-6">
                <label class="form-label small fw-bold">First Name</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" name="first_name" placeholder="Enter first name" required>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-bold">Last Name</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" name="last_name" placeholder="Enter last name" required>
                </div>
            </div>

            <div class="col-md-6">
                <label class="form-label small fw-bold">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" name="email" placeholder="email@example.com" required>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-bold">Phone Number</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
                    <input type="text" class="form-control" name="phone" placeholder="Contact number" required>
                </div>
            </div>

            <div class="col-md-4">
                <label class="form-label small fw-bold">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" name="password" placeholder="Min 6 chars" minlength="6" required>
                </div>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-bold">Date of Birth</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                    <input type="date" class="form-control" name="dob" required>
                </div>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-bold">Gender</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-gender-ambiguous"></i></span>
                    <select class="form-select" name="gender" required>
                        <option value="" disabled selected>Select</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>

            <div class="col-12 text-center mt-5">
                <button class="btn btn-primary px-5 shadow-sm" type="submit">
                    <i class="bi bi-person-plus me-2"></i>Create My Account
                </button>
            </div>
        </div>
    </form>

    <div class="footer-nav">
        <span class="text-muted">Already have an account? <a href="../login.jsp" class="text-primary fw-bold text-decoration-none">Login</a></span>
        <span class="text-muted">|</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>