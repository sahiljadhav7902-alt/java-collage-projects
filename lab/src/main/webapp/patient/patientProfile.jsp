<%-- 
    Document   : patientProfile
    Updated on : 21-Feb-2026
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllUserMaster" %>
<%@ page import="java.sql.*" %>

<%
    // --- LOGIC PRESERVED ---
    Integer patientIdObj = (Integer) session.getAttribute("userId");
    if (patientIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int patientId = patientIdObj;

    BllUserMaster bll = new BllUserMaster();
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String newPassword = request.getParameter("newPassword");
        message = bll.updatePatientProfile(patientId, email, phone, address, newPassword);
    }

    BllUserMaster user = bll.getUserById(patientId);
    if (user == null) {
        out.println("Error loading user data.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Account Settings | LabPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
        }

        .profile-header-bg {
            
            height: 130px;
            border-radius: 0 0 40px 40px;
        }

        .profile-container {
            margin-top: -80px;
        }

        .avatar-circle {
            width: 100px;
            height: 100px;
            background: white;
            border: 4px solid #fff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #3b82f6;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .settings-card {
            background: white;
            border-radius: 24px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }

        .form-label {
            font-weight: 600;
            color: #475569;
            font-size: 0.875rem;
        }

        .form-control {
            border-radius: 12px;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            transition: all 0.2s;
        }

        .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .form-control[readonly] {
            background-color: #f1f5f9;
            color: #64748b;
        }

        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .save-btn {
            background: #3b82f6;
            border: none;
            border-radius: 12px;
            padding: 10px 30px;
            font-weight: 600;
        }
    </style>
</head>
<body>

    <jsp:include page="patientNavbar.jsp" />

    <div class="profile-header-bg"></div>

    <div class="container profile-container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <% if (!message.isEmpty()) { %>
                    <div class="alert <%= message.contains("Error") ? "alert-danger" : "alert-success" %> alert-dismissible fade show border-0 shadow-sm mb-4" role="alert" style="border-radius: 16px;">
                        <i class="bi <%= message.contains("Error") ? "bi-exclamation-octagon" : "bi-check-circle" %> me-2"></i>
                        <%= message %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="settings-card p-4 p-md-5">
                    <div class="d-flex align-items-center gap-4 mb-5">
                        <div class="avatar-circle">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-1 text-dark"><%= user.getFirstName() %> <%= user.getLastName() %></h3>
                            <span class="badge bg-primary-subtle text-primary rounded-pill">Patient Account</span>
                        </div>
                    </div>

                    <form action="patientProfile.jsp" method="POST">
                        
                        <div class="section-title">
                            <i class="bi bi-shield-lock text-primary"></i> Identity Information
                        </div>
                        <div class="row g-3 mb-5">
                            <div class="col-md-6">
                                <label class="form-label">Medical Record Number (MRN)</label>
                                <input type="text" class="form-control" value="<%= (user.getMrn() != null) ? user.getMrn() : "N/A" %>" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Account Created</label>
                                <input type="text" class="form-control" value="February 2026" readonly>
                            </div>
                        </div>

                        <div class="section-title">
                            <i class="bi bi-envelope-at text-primary"></i> Contact Details
                        </div>
                        <div class="row g-3 mb-5">
                            <div class="col-12">
                                <label for="email" class="form-label">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0 rounded-start-3"><i class="bi bi-envelope"></i></span>
                                    <input type="email" class="form-control border-start-0" id="email" name="email" value="<%= user.getEmail() %>" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="text" class="form-control" id="phone" name="phone" value="<%= (user.getPhone() != null) ? user.getPhone() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="address" class="form-label">Street Address</label>
                                <input type="text" class="form-control" id="address" name="address" value="<%= (user.getAddress() != null) ? user.getAddress() : "" %>">
                            </div>
                        </div>

<!--                        <div class="section-title">
                            <i class="bi bi-key text-primary"></i> Password Security
                        </div>-->
<!--                        <div class="bg-light p-4 rounded-4 mb-5">
                            <label for="newPassword" class="form-label">Change Password</label>
                            <input type="password" class="form-control bg-white" id="newPassword" name="newPassword" placeholder="Enter new password to change">
                            <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i> Leave this field empty if you do not wish to change your current password.</div>
                        </div>-->

                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                            <a href="patientDashboard.jsp" class="text-decoration-none text-muted fw-semibold">
                                <i class="bi bi-arrow-left me-1"></i> Discard changes
                            </a>
                            <button type="submit" class="btn btn-primary save-btn shadow-sm">
                                <i class="bi bi-cloud-check me-2"></i> Save Profile Settings
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>