<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // LOGIC PRESERVED EXACTLY
    HttpSession sessionObj = request.getSession(false);
    String userRole = (sessionObj != null) ? (String) sessionObj.getAttribute("userRole") : null;
    String userName = (sessionObj != null) ? (String) sessionObj.getAttribute("userName") : null;

    if (sessionObj == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String currentPage = request.getRequestURI();
%>

<style>
    .navbar-admin {
        background-color: #0f172a !important; /* Deep Professional Slate */
        padding: 0.8rem 1.5rem;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .navbar-brand-custom {
        font-weight: 700;
        color: #ffffff !important;
        font-size: 1.25rem;
        letter-spacing: -0.5px;
    }

    .nav-link-custom {
        color: #94a3b8 !important;
        font-size: 0.85rem;
        font-weight: 500;
        padding: 0.5rem 0.8rem !important;
        border-radius: 8px;
        transition: all 0.2s ease;
        margin: 0 2px;
    }

    .nav-link-custom:hover {
        color: #38bdf8 !important;
        background: rgba(56, 189, 248, 0.05);
    }

    .nav-link-custom.active {
        color: #ffffff !important;
        background-color: #0561FC !important; /* Matches Index.jsp Primary Blue */
    }

    .nav-separator {
        color: #334155;
        padding: 0 10px;
        display: flex;
        align-items: center;
        user-select: none;
    }

    .logout-pill {
        background-color: #ef4444;
        color: white !important;
        padding: 6px 16px !important;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.8rem;
        margin-left: 10px;
        transition: transform 0.2s ease;
    }

    .logout-pill:hover {
        background-color: #dc2626;
        transform: scale(1.05);
    }

    /* Responsive adjustments */
    @media (max-width: 991px) {
        .nav-separator { display: none; }
        .nav-link-custom { margin: 5px 0; }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark navbar-admin sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand navbar-brand-custom" href="adminDashboard.jsp">
            <i class="bi bi-capsule-pill text-info me-2"></i>LabAdmin
        </a>
        
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-lg-center">
                
                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("adminDashboard.jsp") ? "active" : "" %>" 
                       href="adminDashboard.jsp">Dashboard</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageOrders.jsp") ? "active" : "" %>" 
                       href="manageOrders.jsp">Orders</a>
                </li>

                <span class="nav-separator">|</span>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("managePatients.jsp") ? "active" : "" %>" 
                       href="managePatients.jsp">Patients</a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("managePhysicians.jsp") ? "active" : "" %>" 
                       href="managePhysicians.jsp">Physicians</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageLabs.jsp") ? "active" : "" %>" 
                       href="manageLabs.jsp">Labs</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageTests.jsp") ? "active" : "" %>" 
                       href="manageTests.jsp">Tests</a>
                </li>

                <span class="nav-separator">|</span>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageSpecimens.jsp") ? "active" : "" %>" 
                       href="manageSpecimens.jsp">Specimens</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageResults.jsp") ? "active" : "" %>" 
                       href="manageResults.jsp">Results</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageBilling.jsp") ? "active" : "" %>" 
                       href="manageBilling.jsp">Billing</a>
                </li>

                <span class="nav-separator">|</span>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageInventory.jsp") ? "active" : "" %>" 
                       href="manageInventory.jsp">Inventory</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link nav-link-custom <%= currentPage.contains("manageReports.jsp") ? "active" : "" %>" 
                       href="manageReports.jsp">Reports</a>
                </li>
            </ul>

            <div class="d-flex align-items-center">
                <span class="text-white-50 small me-3 d-none d-xl-inline">
                    <i class="bi bi-person-circle me-1"></i> <%= userName %>
                </span>
                <a href="<%= request.getContextPath() %>/logout.jsp" class="nav-link logout-pill">
                    <i class="bi bi-box-arrow-right me-1"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>