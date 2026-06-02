<%@ page import="com.mycompany.lab.BllOrder" %>
<%@ page import="java.util.List" %>

<%
    // LOGIC PRESERVED EXACTLY
    BllOrder bll = new BllOrder();
    List<BllOrder.OrderInfo> orders = bll.getAllOrders();
    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management | PathLab Admin</title>

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

        /* Page Header matching Dashboard */
        .page-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 40px 0;
            margin-bottom: 30px;
        }

        .page-header h2 {
            font-weight: 700;
            color: var(--dark-header);
            letter-spacing: -0.5px;
        }

        /* Modern Card & Table */
        .content-card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
        }

        .table thead th {
            background-color: #f1f5f9;
            color: #64748b;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
            padding: 15px;
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        /* Badge Enhancements */
        .badge {
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 6px;
        }

        .btn-manage {
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.85rem;
            transition: all 0.2s;
        }

        .btn-manage:hover {
            background-color: var(--primary-blue);
            color: white;
            transform: translateY(-1px);
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

<header class="page-header">
    <div class="container text-center">
        <h2>Order Management</h2>
        <p class="text-muted mb-0">Track and process laboratory diagnostics</p>
    </div>
</header>

<div class="container mb-5">

    <% if (message != null && !message.isEmpty()) { %>
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Patient</th>
                        <th>Physician</th>
                        <th>Diagnosis</th>
                        <th>Tests</th>
                        <th>Status</th>
                        <th class="text-end">Action</th>
                    </tr>
                </thead>
                <tbody>

                <% if (orders.isEmpty()) { %>
                    <tr>
                        <td colspan="8" class="text-center py-5 text-muted">
                            <i class="bi bi-folder2-open fs-2 d-block mb-2"></i>
                            No orders found in the system.
                        </td>
                    </tr>
                <% } else { 
                    for(BllOrder.OrderInfo o : orders) {
                        // LOGIC PRESERVED
                        String badgeClass = "bg-secondary";
                        if("Completed".equals(o.status)) badgeClass = "bg-success bg-opacity-10 text-success border border-success";
                        else if("Processing".equals(o.status)) badgeClass = "bg-primary bg-opacity-10 text-primary border border-primary";
                        else if("Collected".equals(o.status)) badgeClass = "bg-info bg-opacity-10 text-info border border-info";
                        else if("Cancelled".equals(o.status)) badgeClass = "bg-danger bg-opacity-10 text-danger border border-danger";
                %>

                    <tr>
                        <td class="fw-bold">#<%= o.orderId %></td>
                        <td class="text-nowrap small text-muted"><%= o.orderDate %></td>
                        <td class="fw-500"><%= o.patientName %></td>
                        <td><%= (o.physicianName != null) ? o.physicianName : "<span class='text-muted small'>N/A</span>" %></td>
                        <td class="small text-truncate" style="max-width: 150px;"><%= (o.diagnosis != null) ? o.diagnosis : "-" %></td>
                        <td><span class="badge bg-light text-dark fw-normal border"><%= o.tests %></span></td>
                        <td>
                            <span class="badge <%= badgeClass %>">
                                <%= o.status %>
                            </span>
                        </td>
                        <td class="text-end">
                            <a href="orderForm.jsp?orderId=<%= o.orderId %>" 
                               class="btn btn-sm btn-outline-primary btn-manage">
                               <i class="bi bi-gear-fill me-1"></i> Manage
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

<footer class="text-center">
    <p>&copy; 2026 Pathology Lab System | Admin Panel</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>