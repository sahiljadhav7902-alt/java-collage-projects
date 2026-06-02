<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.lab.BllDashboard" %>
<%@ page import="com.mycompany.lab.BllUserMaster" %>
<%@ page import="java.util.List" %>

<%
    // LOGIC PRESERVED EXACTLY
    HttpSession sessionObj = request.getSession(false);
    String userRole = (sessionObj != null) ? (String) sessionObj.getAttribute("userRole") : null;
    String userName = (sessionObj != null) ? (String) sessionObj.getAttribute("userName") : null;

    if (sessionObj == null || userRole == null || !"admin".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BllDashboard dashboard = new BllDashboard();
    boolean dataLoaded = dashboard.getCompleteDashboardData();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | PathLab</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #0561FC;
            --slate-bg: #f8fafc;
            --dark-header: #1e293b;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--slate-bg);
            color: #334155;
        }

        /* Dashboard Header */
        .welcome-banner {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 40px 0;
            margin-bottom: 30px;
        }

        .welcome-banner h2 {
            font-weight: 700;
            color: var(--dark-header);
            margin-bottom: 5px;
        }

        /* Metric Cards Styling */
        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid rgba(0,0,0,0.02);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            transition: transform 0.3s ease;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .icon-circle {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 15px;
        }

        .metric-title {
            font-size: 0.85rem;
            color: #64748b;
            font-weight: 500;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .metric-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--dark-header);
            margin-bottom: 0;
        }

        /* Data Table Container */
        .table-container {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            margin-top: 30px;
        }

        .table thead th {
            background: #f1f5f9;
            color: #475569;
            font-weight: 600;
            border: none;
            padding: 15px;
        }

        .table tbody td {
            padding: 15px;
            border-bottom: 1px solid #f1f5f9;
        }

        footer {
            margin-top: 50px;
            padding: 30px;
            color: #94a3b8;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>

<jsp:include page="./adminNavbar.jsp" />

<div class="welcome-banner">
    <div class="container">
        <div class="row align-items-center">
            <div class="col">
                <h2>Welcome back, <%= userName %> 👋</h2>
                <p class="text-muted mb-0">Laboratory System Performance Overview</p>
            </div>
        </div>
    </div>
</div>

<div class="container mb-5">
<% if (dataLoaded) { %>

    <div class="row g-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-primary bg-opacity-10 text-primary">
                    <i class="bi bi-people"></i>
                </div>
                <div class="metric-title">Total Patients</div>
                <p class="metric-value"><%= dashboard.getTotalPatients() %></p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-success bg-opacity-10 text-success">
                    <i class="bi bi-currency-dollar"></i>
                </div>
                <div class="metric-title">Total Revenue</div>
                <p class="metric-value">$<%= String.format("%.2f", dashboard.getTotalRevenue()) %></p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-info bg-opacity-10 text-info">
                    <i class="bi bi-calendar-check"></i>
                </div>
                <div class="metric-title">Today's Appointments</div>
                <p class="metric-value"><%= dashboard.getTodayAppointments() %></p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-warning bg-opacity-10 text-warning">
                    <i class="bi bi-hourglass-split"></i>
                </div>
                <div class="metric-title">Pending Orders</div>
                <p class="metric-value"><%= dashboard.getPendingOrders() %></p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-success bg-opacity-10 text-success">
                    <i class="bi bi-clipboard2-check"></i>
                </div>
                <div class="metric-title">Completed Tests</div>
                <p class="metric-value"><%= dashboard.getCompletedTests() %></p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-danger bg-opacity-10 text-danger">
                    <i class="bi bi-exclamation-triangle"></i>
                </div>
                <div class="metric-title">Low Stock Items</div>
                <p class="metric-value"><%= dashboard.getLowStockItems() %></p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-primary bg-opacity-10 text-primary">
                    <i class="bi bi-file-earmark-medical"></i>
                </div>
                <div class="metric-title">Recent Reports</div>
                <p class="metric-value"><%= dashboard.getRecentReports() %></p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="icon-circle bg-secondary bg-opacity-10 text-secondary">
                    <i class="bi bi-person-check"></i>
                </div>
                <div class="metric-title">Active Users</div>
                <p class="metric-value"><%= dashboard.getActiveUsers() %></p>
            </div>
        </div>
    </div>

    <div class="table-container">
        <h4 class="fw-bold mb-4">Recent Registered Patients</h4>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>Patient Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    List<BllUserMaster> recentPatients = dashboard.getRecentPatients();
                    if (recentPatients != null && !recentPatients.isEmpty()) {
                        for (BllUserMaster patient : recentPatients) {
                %>
                    <tr>
                        <td class="fw-bold"><%= patient.getFullName() %></td>
                        <td class="text-muted"><%= patient.getEmail() %></td>
                        <td><%= patient.getPhone() %></td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="3" class="text-center py-4 text-muted">No recent patients found.</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

<% } else { %>
    <div class="alert alert-danger text-center p-5">
        <i class="bi bi-cloud-slash fs-1 d-block mb-3"></i>
        <strong>Data Load Failed!</strong> Could not load dashboard metrics. Please refresh.
    </div>
<% } %>
</div>

<footer class="text-center">
    <p>&copy; 2026 Pathology Lab System | Professional Admin Panel</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>