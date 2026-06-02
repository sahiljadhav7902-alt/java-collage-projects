<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is a doctor
    if (session.getAttribute("isLoggedIn") == null || 
        !session.getAttribute("userType").equals("DOCTOR")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - Pathology Lab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-hospital me-2"></i>Pathology Lab
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    Dr. <%= session.getAttribute("userName") %> | License: ${user.licenseNumber}
                </span>
                <a href="../logout.jsp" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- Dashboard Content -->
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <h2>Doctor Dashboard</h2>
                <p class="text-muted">Manage patient orders and review test results</p>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-3">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <h5 class="card-title">New Order</h5>
                        <p class="card-text">Create test orders for patients</p>
                        <a href="#" class="btn btn-light">Create Order</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-info">
                    <div class="card-body">
                        <h5 class="card-title">Patient Results</h5>
                        <p class="card-text">Review and validate results</p>
                        <a href="#" class="btn btn-light">Review Results</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-warning">
                    <div class="card-body">
                        <h5 class="card-title">My Patients</h5>
                        <p class="card-text">View patient list</p>
                        <a href="#" class="btn btn-light">View Patients</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-secondary">
                    <div class="card-body">
                        <h5 class="card-title">Reports</h5>
                        <p class="card-text">Generate reports</p>
                        <a href="#" class="btn btn-light">Generate</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>