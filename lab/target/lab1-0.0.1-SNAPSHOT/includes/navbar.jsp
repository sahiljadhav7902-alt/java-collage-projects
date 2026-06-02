<%@ page contentType="text/html;charset=UTF-8" %>

<%
String userName = (String) session.getAttribute("userName");
String userRole = (String) session.getAttribute("userRole");
%>

<style>
    .navbar {
        background: rgba(255, 255, 255, 0.85) !important;
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        padding: 15px 0;
        transition: all 0.3s ease;
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    .navbar-brand {
        font-weight: 700;
        font-size: 1.4rem;
        color: #0561FC !important;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .navbar-brand i {
        font-size: 1.6rem;
        background: linear-gradient(45deg, #0561FC, #00d2ff);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    .nav-link {
        font-weight: 500;
        color: #475569 !important;
        padding: 8px 16px !important;
        transition: 0.2s;
        border-radius: 8px;
    }

    .nav-link:hover {
        color: #0561FC !important;
        background: rgba(5, 97, 252, 0.05);
    }

    /* Modernized Register Button */
    .nav-btn-register {
        background: #0561FC !important;
        color: white !important;
        font-weight: 600 !important;
        padding: 8px 24px !important;
        border-radius: 10px !important;
        box-shadow: 0 4px 12px rgba(5, 97, 252, 0.2);
        transition: 0.3s !important;
    }

    .nav-btn-register:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(5, 97, 252, 0.3);
        background: #044ecb !important;
    }

    .logout-link {
        color: #ef4444 !important;
        font-weight: 600;
    }

    .logout-link:hover {
        background: rgba(239, 68, 68, 0.05) !important;
    }
</style>

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">
            <i class="bi bi-heart-pulse-fill"></i> 
            <span>PathLab</span>
        </a>

        <button class="navbar-toggler border-0 shadow-none" type="button" 
                data-bs-toggle="collapse" 
                data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">

                <% if(userName != null){ %>
                    <li class="nav-item">
                        <span class="nav-link text-muted pe-3">
                            <i class="bi bi-person-circle me-1"></i> Hello, <strong><%= userName %></strong>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" 
                           href="<%= userRole.equals("patient") ? request.getContextPath()+"/patient/dashboard.jsp" : 
                                   userRole.equals("doctor") ? request.getContextPath()+"/doctor/doctorDashboard.jsp" : 
                                   request.getContextPath()+"/admin/adminDashboard.jsp" %>">
                            Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link logout-link" 
                           href="<%= request.getContextPath() %>/logout.jsp">
                            <i class="bi bi-box-arrow-right me-1"></i> Logout
                        </a>
                    </li>

                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/login.jsp">Patient Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/login.jsp">Doctor Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/login.jsp">Admin</a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a class="btn nav-btn-register nav-link ms-2" 
                           href="<%= request.getContextPath() %>/patient/register.jsp">
                            Register
                        </a>
                    </li>
                <% } %>

            </ul>
        </div>
    </div>
</nav>  