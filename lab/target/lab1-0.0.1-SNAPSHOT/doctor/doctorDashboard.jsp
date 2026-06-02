<%-- 
    Document   : doctorDashboard
    Created on : 18-Feb-2026, 5:51:47 pm
    Author     : sahil jadhav
--%>
<%@ page import="com.mycompany.lab.BllDashboard" %>
<%@ page import="java.util.List" %>

<%
    // LOGIC PRESERVED
    Integer physicianIdObj = (Integer) session.getAttribute("userId");
    if (physicianIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    int physicianId = physicianIdObj;
    BllDashboard bll = new BllDashboard();
    BllDashboard.DoctorStats stats = bll.getDoctorStats(physicianId);
    List<BllDashboard.DoctorOrderInfo> orders = bll.getDoctorRecentOrders(physicianId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Physician Dashboard | Lab Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --doctor-green: #059669;
            --slate-bg: #f8fafc;
            --dark-header: #1e293b;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--slate-bg);
            color: #334155;
        }

        .page-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 30px 0;
            margin-bottom: 25px;
        }

        .stats-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            padding: 1.5rem;
            transition: all 0.2s ease;
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .stats-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 4px; height: 100%;
        }

        .card-patients::before { background: #3b82f6; }
        .card-active::before { background: #f59e0b; }
        .card-completed::before { background: #10b981; }

        .icon-circle {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .content-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            overflow: hidden;
        }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 15px;
        }

        .status-pill {
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.7rem;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <jsp:include page="doctorNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold m-0">Physician Dashboard</h2>
                    <p class="text-muted small mb-0">Welcome back, Dr. <%= session.getAttribute("firstName") %></p>
                </div>
                <div class="d-flex gap-2">
                    <a href="doctorOrderForm.jsp" class="btn btn-success btn-sm px-4 rounded-pill">
                        <i class="bi bi-plus-lg me-1"></i> New Lab Order
                    </a>
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">
        
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="stats-card card-patients">
                    <div class="icon-circle bg-primary-subtle text-primary">
                        <i class="bi bi-people"></i>
                    </div>
                    <div class="text-muted small fw-medium text-uppercase">My Patients</div>
                    <div class="display-6 fw-bold text-dark mt-1"><%= stats.totalPatients %></div>
                    <div class="mt-2 small text-muted">Unique clinical records</div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stats-card card-active">
                    <div class="icon-circle bg-warning-subtle text-warning">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                    <div class="text-muted small fw-medium text-uppercase">Active Orders</div>
                    <div class="display-6 fw-bold text-dark mt-1"><%= stats.activeOrders %></div>
                    <div class="mt-2 small text-muted">Processing or pending</div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stats-card card-completed">
                    <div class="icon-circle bg-success-subtle text-success">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                    <div class="text-muted small fw-medium text-uppercase">Results Ready</div>
                    <div class="display-6 fw-bold text-dark mt-1"><%= stats.completedOrders %></div>
                    <div class="mt-2 small text-muted">Validated reports</div>
                </div>
            </div>
        </div>

        <div class="content-card">
            <div class="px-4 py-3 border-bottom d-flex justify-content-between align-items-center bg-white">
                <h5 class="fw-bold m-0">Recent Lab Requisitions</h5>
                <a href="doctorMyOrders.jsp" class="btn btn-link text-success text-decoration-none fw-semibold btn-sm">
                    View All Orders <i class="bi bi-arrow-right"></i>
                </a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Patient Name</th>
                            <th>Test Description</th>
                            <th>Request Date</th>
                            <th>Status</th>
                            <th class="text-end pe-4">Report</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orders == null || orders.isEmpty()) { %>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-clipboard2-x d-block fs-2 mb-2 opacity-50"></i>
                                    No recent orders found.
                                </td>
                            </tr>
                        <% } else { 
                            for(BllDashboard.DoctorOrderInfo o : orders) {
                                String badgeClass = "bg-secondary-subtle text-secondary";
                                if("Completed".equals(o.status)) badgeClass = "bg-success-subtle text-success";
                                else if("Processing".equals(o.status)) badgeClass = "bg-info-subtle text-info";
                                else if("Ordered".equals(o.status)) badgeClass = "bg-warning-subtle text-warning";
                        %>
                        <tr>
                            <td class="ps-4 text-muted small">#<%= o.orderId %></td>
                            <td><span class="fw-semibold text-dark"><%= o.patientName %></span></td>
                            <td><div class="text-truncate" style="max-width: 250px;"><small><%= o.tests %></small></div></td>
                            <td><small><%= o.orderDate %></small></td>
                            <td><span class="status-pill <%= badgeClass %>"><%= o.status %></span></td>
                            <td class="text-end pe-4">
                                <a href="viewOrderDetails.jsp?orderId=<%= o.orderId %>" class="btn btn-sm btn-light border px-3">
                                    <i class="bi bi-eye me-1"></i> Details
                                </a>
                            </td>
                        </tr>
                        <% 
                            } 
                        } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>