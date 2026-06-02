<%-- 
    Document   : doctorNavbar
    Created on : 18-Feb-2026, 6:05:17 pm
    Author     : sahil jadhav
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String requestURI = request.getRequestURI();
    // Logic to determine active tab
    String activeClass = "active-link";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        .navbar-doctor {
            background-color: #059669 !important; /* Medical Green */
            font-family: 'Poppins', sans-serif;
            padding: 0.8rem 0;
        }

        .navbar-doctor .navbar-brand {
            font-size: 1.25rem;
            letter-spacing: -0.5px;
        }

        .navbar-doctor .nav-link {
            color: rgba(255, 255, 255, 0.85) !important;
            font-weight: 500;
            font-size: 0.9rem;
            padding: 0.5rem 1rem !important;
            border-radius: 8px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
        }

        .navbar-doctor .nav-link:hover {
            color: #fff !important;
            background: rgba(255, 255, 255, 0.1);
        }

        .navbar-doctor .nav-link.active-link {
            color: #fff !important;
            background: rgba(255, 255, 255, 0.2);
        }

        .navbar-doctor .nav-link i {
            margin-right: 8px;
            font-size: 1.1rem;
        }

        /* Dropdown Styling */
        .dropdown-menu {
            border: none;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            padding: 0.5rem;
        }

        .dropdown-item {
            border-radius: 6px;
            padding: 0.6rem 1rem;
            font-size: 0.88rem;
            font-weight: 500;
            color: #475569;
        }

        .dropdown-item:hover {
            background-color: #f1f5f9;
            color: #059669;
        }

        .dropdown-item i {
            margin-right: 10px;
            color: #94a3b8;
        }

        .user-profile-box {
            border-left: 1px solid rgba(255,255,255,0.2);
            padding-left: 1.25rem;
            margin-left: 1rem;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-doctor sticky-top shadow-sm">
    <div class="container-fluid px-5">
        <a class="navbar-brand fw-bold d-flex align-items-center" href="doctorDashboard.jsp">
            <i class="bi bi-heart-pulse-fill me-2"></i>
            <span>LabPortal</span>
            <span class="badge bg-white text-success ms-2 fw-bold" style="font-size: 0.65rem; padding: 0.35em 0.65em;">DOCTOR</span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#doctorNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="doctorNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                
                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("doctorDashboard") ? activeClass : "" %>" href="doctorDashboard.jsp">
                        <i class="bi bi-grid-1x2"></i> Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("doctorPatients") ? activeClass : "" %>" href="doctorPatients.jsp">
                        <i class="bi bi-people"></i> Patients
                    </a>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle <%= 
                        (requestURI.contains("Order") || requestURI.contains("History")) ? activeClass : "" 
                    %>" href="#" id="ordersDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-file-earmark-plus"></i> Lab Orders
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="doctorOrderForm.jsp">
                            <i class="bi bi-plus-circle-dotted"></i> New Requisition
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="doctorMyOrders.jsp">
                            <i class="bi bi-list-ul"></i> Pending Orders
                        </a></li>
                        <li><a class="dropdown-item" href="doctorHistory.jsp">
                            <i class="bi bi-clock-history"></i> Order History
                        </a></li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("doctorResults") ? activeClass : "" %>" href="doctorResults.jsp">
                        <i class="bi bi-clipboard2-check"></i> Clinical Results
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center user-profile-box">
                <div class="text-white me-3 d-none d-md-block text-end">
                    <div style="font-size: 0.7rem; opacity: 0.8;">Provider Portal</div>
                    <div class="fw-semibold small">Dr. <%= (session.getAttribute("userName") != null) ? session.getAttribute("userName") : "User" %></div>
                </div>
                <a href="../logout.jsp" class="btn btn-sm btn-light text-success fw-bold px-3 rounded-pill" style="font-size: 0.75rem;">
                    <i class="bi bi-box-arrow-right me-1"></i> LOGOUT
                </a>
            </div>
        </div>
    </div>
</nav>

</body>
</html>