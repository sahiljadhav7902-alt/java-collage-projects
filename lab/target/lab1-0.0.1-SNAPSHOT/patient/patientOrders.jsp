<%-- 
    Document   : patientOrders
    Created on : 21-Feb-2026
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllOrder" %>
<%@ page import="java.util.List" %>

<%
    // --- LOGIC PRESERVED ---
    Integer patientIdObj = (Integer) session.getAttribute("userId");
    if (patientIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int patientId = patientIdObj;

    BllOrder bll = new BllOrder();
    List<BllOrder.PatientOrderDetail> orders = bll.getPatientOrders(patientId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Order History | LabPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
        }

        .page-header {
            background: white;
            padding: 2rem 0;
            border-bottom: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }

        .search-container {
            position: relative;
        }

        .search-container i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        .search-container .form-control {
            padding-left: 45px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            height: 48px;
        }

        .order-card {
            background: white;
            border-radius: 16px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            transition: all 0.2s ease;
        }

        .order-table th {
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            color: #64748b;
            padding: 1.25rem 1rem;
        }

        .order-table td {
            padding: 1.25rem 1rem;
            vertical-align: middle;
        }

        /* Modern Status Badges */
        .status-pill {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-completed { background: #dcfce7; color: #166534; }
        .status-processing { background: #e0f2fe; color: #075985; }
        .status-collected { background: #fef3c7; color: #92400e; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }

        .pulse-icon {
            width: 8px;
            height: 8px;
            background: currentColor;
            border-radius: 50%;
            display: inline-block;
            animation: pulse-animation 2s infinite;
        }

        @keyframes pulse-animation {
            0% { box-shadow: 0 0 0 0px rgba(7, 89, 133, 0.4); }
            100% { box-shadow: 0 0 0 8px rgba(7, 89, 133, 0); }
        }

        .view-btn {
            border-radius: 10px;
            font-weight: 600;
            padding: 8px 16px;
            transition: all 0.2s;
        }
    </style>
</head>
<body>

    <jsp:include page="patientNavbar.jsp" />

    <header class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2 class="fw-bold mb-1 text-dark">My Orders</h2>
                    <p class="text-muted mb-0">Manage and track your laboratory requests.</p>
                </div>
                <div class="col-md-6 mt-3 mt-md-0">
                    <div class="search-container">
                        <i class="bi bi-search"></i>
                        <input type="text" id="searchInput" class="form-control" 
                               placeholder="Filter by physician or test name..." onkeyup="filterTable()">
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="container pb-5">
        <div class="order-card overflow-hidden">
            <% if (orders.isEmpty()) { %>
                <div class="text-center py-5">
                    <div class="mb-3">
                        <i class="bi bi-folder2-open display-1 text-light"></i>
                    </div>
                    <h4 class="text-secondary">No records found</h4>
                    <p class="text-muted">You haven't placed any laboratory orders yet.</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover order-table mb-0" id="ordersTable">
                        <thead class="bg-light">
                            <tr>
                                <th>Ref ID</th>
                                <th>Ordered Date</th>
                                <th>Prescribed By</th>
                                <th>Tests Included</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(BllOrder.PatientOrderDetail o : orders) { 
                                String statusClass = "status-processing";
                                boolean isCompleted = "Completed".equals(o.status);
                                boolean showPulse = false;

                                if(isCompleted) statusClass = "status-completed";
                                else if("Processing".equals(o.status)) { statusClass = "status-processing"; showPulse = true; }
                                else if("Collected".equals(o.status)) statusClass = "status-collected";
                                else if("Cancelled".equals(o.status)) statusClass = "status-cancelled";
                            %>
                            <tr class="order-row">
                                <td class="fw-bold text-dark">#<%= o.orderId %></td>
                                <td class="text-secondary"><%= o.orderDate %></td>
                                <td>
                                    <div class="fw-semibold text-dark">Dr. <%= o.physicianName %></div>
                                    <div class="small text-muted"><%= (o.diagnosis != null) ? o.diagnosis : "General Checkup" %></div>
                                </td>
                                <td>
                                    <div class="text-truncate" style="max-width: 200px;" title="<%= o.tests %>">
                                        <%= o.tests %>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-pill <%= statusClass %>">
                                        <% if(showPulse) { %><span class="pulse-icon"></span><% } %>
                                        <%= o.status %>
                                    </span>
                                </td>
                                <td class="text-end">
                                    <% if (isCompleted) { %>
                                        <a href="patientResults.jsp?orderId=<%= o.orderId %>" class="btn btn-primary view-btn btn-sm">
                                            <i class="bi bi-file-earmark-arrow-down me-1"></i> Result
                                        </a>
                                    <% } else { %>
                                        <button class="btn btn-light border view-btn btn-sm" disabled>
                                            <i class="bi bi-clock-history me-1"></i> Tracking
                                        </button>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        function filterTable() {
            const filter = document.getElementById("searchInput").value.toUpperCase();
            const rows = document.querySelectorAll(".order-row");

            rows.forEach(row => {
                const physician = row.cells[2].textContent.toUpperCase();
                const tests = row.cells[3].textContent.toUpperCase();
                
                if (physician.indexOf(filter) > -1 || tests.indexOf(filter) > -1) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>

</body>
</html>