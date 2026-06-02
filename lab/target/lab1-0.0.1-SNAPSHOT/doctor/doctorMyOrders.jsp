<%-- 
    Document   : doctorMyOrders
    Created on : 18-Feb-2026, 9:11:12 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllOrder" %>
<%@ page import="java.util.List" %>

<%
    // --- LOGIC PRESERVED ---
    Integer physicianIdObj = (Integer) session.getAttribute("userId");
    if (physicianIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int physicianId = physicianIdObj;

    BllOrder bll = new BllOrder();
    List<BllOrder.DoctorOrderInfo> orders = bll.getOrdersByPhysician(physicianId);
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Requisitions | Lab Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --doctor-green: #059669;
            --slate-bg: #f8fafc;
            --border-color: #e2e8f0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--slate-bg);
            color: #334155;
        }

        .page-header {
            background: white;
            border-bottom: 1px solid var(--border-color);
            padding: 30px 0;
            margin-bottom: 30px;
        }

        .content-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            overflow: hidden;
        }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 15px 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .table tbody td {
            padding: 18px 20px;
            border-bottom: 1px solid #f1f5f9;
        }

        /* Modern Status Badges */
        .badge-status {
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
        }
        .status-completed { background: #dcfce7; color: #166534; }
        .status-processing { background: #e0f2fe; color: #075985; }
        .status-collected { background: #fef9c3; color: #854d0e; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }
        .status-pending { background: #f1f5f9; color: #475569; }

        .btn-action {
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.85rem;
            transition: all 0.2s;
        }
        
        .btn-create {
            background-color: var(--doctor-green);
            color: white;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
        }
        .btn-create:hover { background-color: #047857; color: white; }
    </style>
</head>
<body>

    <jsp:include page="doctorNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5 d-flex justify-content-between align-items-center">
            <div>
                <h2 class="fw-bold m-0">My Orders</h2>
                <p class="text-muted small mb-0">Track and manage your patient lab requisitions.</p>
            </div>
            <a href="doctorOrderForm.jsp" class="btn btn-create shadow-sm">
                <i class="bi bi-plus-lg me-2"></i> New Requisition
            </a>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">
        
        <% if (msg != null) { %>
            <div class="alert alert-success border-0 shadow-sm rounded-3 alert-dismissible fade show mb-4" role="alert">
                <div class="d-flex align-items-center">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                    <div><%= msg %></div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="content-card">
            <% if (orders == null || orders.isEmpty()) { %>
                <div class="text-center py-5">
                    <i class="bi bi-clipboard-x text-muted opacity-25" style="font-size: 4rem;"></i>
                    <h4 class="fw-bold text-dark mt-3">No Orders Found</h4>
                    <p class="text-muted">You haven't initiated any lab orders yet.</p>
                    <a href="doctorPatients.jsp" class="btn btn-outline-success rounded-pill px-4">
                        Find a Patient to Start
                    </a>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Patient Name</th>
                                <th>Tests Requested</th>
                                <th>Order Date</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(BllOrder.DoctorOrderInfo o : orders) { 
                                // Enhanced Badge Logic
                                String statusClass = "status-pending";
                                String icon = "bi-clock";
                                
                                if ("Completed".equals(o.status)) {
                                    statusClass = "status-completed"; icon = "bi-check-circle";
                                } else if ("Processing".equals(o.status)) {
                                    statusClass = "status-processing"; icon = "bi-arrow-repeat";
                                } else if ("Collected".equals(o.status)) {
                                    statusClass = "status-collected"; icon = "bi-droplet";
                                } else if ("Cancelled".equals(o.status)) {
                                    statusClass = "status-cancelled"; icon = "bi-x-circle";
                                }
                            %>
                            <tr>
                                <td><span class="fw-bold text-dark">#<%= o.orderId %></span></td>
                                <td>
                                    <div class="fw-semibold"><%= o.patientName %></div>
                                </td>
                                <td>
                                    <div class="text-truncate text-muted small" style="max-width: 250px;">
                                        <%= (o.tests != null && !o.tests.isEmpty()) ? o.tests : "No tests assigned" %>
                                    </div>
                                </td>
                                <td>
                                    <div class="small text-secondary"><%= o.orderDate %></div>
                                </td>
                                <td>
                                    <span class="badge-status <%= statusClass %>">
                                        <i class="bi <%= icon %> me-2"></i> <%= o.status %>
                                    </span>
                                </td>
                                <td class="text-end">
                                    <div class="btn-group">
                                        <a href="viewOrderDetails.jsp?orderId=<%= o.orderId %>" 
                                           class="btn btn-sm btn-outline-secondary btn-action px-3">
                                            View Details
                                        </a>

                                        <% if (!"Completed".equals(o.status) && !"Cancelled".equals(o.status)) { %>
                                            <a href="doctorOrderTests.jsp?orderId=<%= o.orderId %>" 
                                               class="btn btn-sm btn-outline-primary btn-action ms-2">
                                                <i class="bi bi-pencil-square me-1"></i> Tests
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>