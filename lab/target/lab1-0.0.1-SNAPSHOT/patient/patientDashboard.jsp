<%-- 
    Document   : patientDashboard
    Created on : 21-Feb-2026
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllDashboard" %>
<%@ page import="java.util.List" %>

<%
    // --- START LOGIC PRESERVED ---
    Integer patientIdObj = (Integer) session.getAttribute("userId");
    if (patientIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int patientId = patientIdObj;

    BllDashboard bll = new BllDashboard();
    BllDashboard.PatientStats stats = bll.getPatientStats(patientId);
    List<BllDashboard.PatientOrderInfo> orders = bll.getPatientRecentOrders(patientId);
    // --- END LOGIC PRESERVED ---
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Health Dashboard | LabPortal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --patient-blue: #0284c7;
            --soft-bg: #f0f9ff;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }

        .welcome-section {
            background: linear-gradient(135deg, #0369a1 0%, #0284c7 100%);
            border-radius: 24px;
            padding: 40px;
            color: white;
            margin-bottom: 30px;
            box-shadow: 0 10px 25px rgba(2, 132, 199, 0.15);
        }

        .stat-card {
            background: white;
            border: none;
            border-radius: 20px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.05);
        }

        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }

        .table-card {
            background: white;
            border-radius: 20px;
            border: none;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* Status Colors */
        .status-completed { background: #dcfce7; color: #15803d; }
        .status-processing { background: #e0f2fe; color: #0369a1; }
        .status-warning { background: #fef3c7; color: #92400e; }
    </style>
</head>
<body>

    <jsp:include page="patientNavbar.jsp" />

    <div class="container py-5">
       

        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card stat-card p-3 h-100">
                    <div class="card-body">
                        <div class="icon-box bg-light text-primary">
                            <i class="bi bi-files fs-4"></i>
                        </div>
                        <h6 class="text-secondary fw-semibold">Total Orders</h6>
                        <h2 class="fw-bold"><%= stats.totalOrders %></h2>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card p-3 h-100">
                    <div class="card-body">
                        <div class="icon-box" style="background: #fff7ed; color: #ea580c;">
                            <i class="bi bi-hourglass-top fs-4"></i>
                        </div>
                        <h6 class="text-secondary fw-semibold">Pending Analysis</h6>
                        <h2 class="fw-bold"><%= stats.activeOrders %></h2>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card p-3 h-100">
                    <div class="card-body">
                        <div class="icon-box" style="background: #f0fdf4; color: #16a34a;">
                            <i class="bi bi-check2-circle fs-4"></i>
                        </div>
                        <h6 class="text-secondary fw-semibold">Ready Reports</h6>
                        <h2 class="fw-bold"><%= stats.completedOrders %></h2>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-3 px-2">
                    <h4 class="fw-bold m-0">Recent Lab Tests</h4>
                    <a href="patientOrders.jsp" class="text-decoration-none fw-semibold">See all history &rarr;</a>
                </div>

                <div class="table-card">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4 border-0 text-secondary small py-3">ORDER REF</th>
                                    <th class="border-0 text-secondary small py-3">INVESTIGATIONS</th>
                                    <th class="border-0 text-secondary small py-3">DATE</th>
                                    <th class="border-0 text-secondary small py-3">CURRENT STATUS</th>
                                    <th class="pe-4 border-0 text-secondary text-end py-3">ACTION</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (orders == null || orders.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" class="text-center py-5">
                                            <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" alt="No data" style="width: 60px; opacity: 0.3;">
                                            <p class="mt-3 text-muted">You haven't placed any orders yet.</p>
                                        </td>
                                    </tr>
                                <% } else { 
                                    for(BllDashboard.PatientOrderInfo o : orders) {
                                        String badgeStyle = "status-warning";
                                        if("Completed".equals(o.status)) badgeStyle = "status-completed";
                                        else if("Processing".equals(o.status) || "Collected".equals(o.status)) badgeStyle = "status-processing";
                                %>
                                <tr>
                                    <td class="ps-4 fw-bold text-dark">#<%= o.orderId %></td>
                                    <td>
                                        <div class="fw-medium text-dark"><%= o.tests %></div>
                                    </td>
                                    <td class="text-muted"><%= o.orderDate %></td>
                                    <td>
                                        <span class="status-badge <%= badgeStyle %>">
                                            <i class="bi bi-dot"></i> <%= o.status %>
                                        </span>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <a href="patientOrders.jsp" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                            Track Order
                                        </a>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>