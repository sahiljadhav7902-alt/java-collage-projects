<%-- 
    Document   : patientNavbar
    Created on : 21-Feb-2026
    Author     : sahil jadhav
--%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>

<%
    String requestURI = request.getRequestURI();
    String activeClass = "active shadow-sm";
%>

<style>
    :root {
        --patient-blue: #0284c7; /* Trustworthy medical blue */
        --patient-dark: #0c4a6e;
    }

    .navbar-patient {
        background-color: var(--patient-blue) !important;
        padding: 0.7rem 0;
        transition: all 0.3s ease;
    }

    /* Active Link Styling */
    .navbar-nav .nav-link {
        color: rgba(255, 255, 255, 0.85) !important;
        font-weight: 500;
        padding: 0.6rem 1.2rem !important;
        border-radius: 50px;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .navbar-nav .nav-link:hover {
        color: #fff !important;
        background: rgba(255, 255, 255, 0.15);
    }

    .navbar-nav .nav-link.active {
        color: var(--patient-dark) !important;
        background-color: #fff !important;
    }

    /* Branding */
    .navbar-brand {
        font-size: 1.4rem;
        letter-spacing: -0.5px;
    }

    .patient-tag {
        font-size: 0.65rem;
        background: rgba(255,255,255,0.2);
        border: 1px solid rgba(255,255,255,0.4);
        padding: 2px 8px;
        border-radius: 4px;
        vertical-align: middle;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* Profile Section */
    .user-profile-box {
        border-left: 1px solid rgba(255,255,255,0.3);
        padding-left: 1.25rem;
    }

    .btn-logout {
        border-radius: 50px;
        border: 1px solid rgba(255,255,255,0.5);
        background: transparent;
        color: white;
        font-weight: 600;
        font-size: 0.85rem;
    }

    .btn-logout:hover {
        background: #ef4444; /* Danger red on hover */
        border-color: #ef4444;
    }

    @media (max-width: 991.98px) {
        .user-profile-box {
            border-left: none;
            padding-left: 0;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid rgba(255,255,255,0.2);
        }
        .navbar-nav .nav-link { border-radius: 10px; }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark navbar-patient sticky-top shadow-sm">
    <div class="container-fluid px-lg-5">
        
        <a class="navbar-brand fw-bold d-flex align-items-center" href="patientDashboard.jsp">
            <i class="bi bi-shield-plus fs-3 me-2"></i>
            <span>LabPortal <span class="patient-tag ms-1">Patient</span></span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#patientNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="patientNav">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                
                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("patientDashboard") ? activeClass : "" %>" href="patientDashboard.jsp">
                        <i class="bi bi-house-heart"></i> Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("patientOrders") ? activeClass : "" %>" href="patientOrders.jsp">
                        <i class="bi bi-receipt"></i> My Orders
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("patientResults") ? activeClass : "" %>" href="patientResults.jsp">
                        <i class="bi bi-file-earmark-medical"></i> Reports
                    </a>
                </li>
                 <!-- Track Specimen -->
                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("patientSpecimen") ? activeClass : "" %>" href="patientSpecimen.jsp">
                        <i class="bi bi-box-seam"></i> Track Specimen
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("patientBilling") ? activeClass : "" %>" href="patientBilling.jsp">
                        <i class="bi bi-credit-card"></i> Payments
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link <%= requestURI.contains("patientProfile") ? activeClass : "" %>" href="patientProfile.jsp">
                        <i class="bi bi-person-gear"></i> Settings
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center user-profile-box">
                <div class="text-white me-3 d-none d-lg-block text-end">
                    <div class="small opacity-75" style="font-size: 0.7rem;">Signed in as</div>
                    <div class="fw-bold"><%= (session.getAttribute("userName") != null) ? session.getAttribute("userName") : "Patient" %></div>
                </div>
                <a href="../logout.jsp" class="btn btn-sm btn-logout px-3 py-2">
                    <i class="bi bi-power me-1"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>