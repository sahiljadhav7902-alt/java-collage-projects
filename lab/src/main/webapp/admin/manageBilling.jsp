<%-- 
    Document   : manageBilling
    Created on : 18-Feb-2026, 5:35:23 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllBilling" %>
<%@ page import="java.util.List" %>

<%
    // LOGIC PRESERVED
    BllBilling bll = new BllBilling();
    List<BllBilling.BillInfo> bills = bll.getAllBills();
    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Management | Lab Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

        .page-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 30px 0;
            margin-bottom: 25px;
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
            border-bottom: 2px solid #f1f5f9;
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.88rem;
        }

        .bill-id {
            font-weight: 700;
            color: var(--primary-blue);
        }

        .cpt-code {
            background: #f1f5f9;
            padding: 4px 8px;
            border-radius: 6px;
            font-family: monospace;
            font-size: 0.85rem;
            color: #475569;
        }

        .amount-text {
            font-weight: 700;
            color: var(--dark-header);
            font-size: 1rem;
        }

        .status-pill {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.7rem;
            text-transform: uppercase;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold m-0">Billing Management</h2>
                    <p class="text-muted small mb-0">Track invoices, payments, and CPT records.</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="billingForm.jsp" class="btn btn-primary btn-sm px-3">
                        <i class="bi bi-plus-lg me-1"></i> Create New Bill
                    </a>
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">
        
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success border-0 shadow-sm rounded-3 mb-4">
                <i class="bi bi-check-circle-fill me-2"></i> <%= message %>
            </div>
        <% } %>

        <div class="content-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Bill ID</th>
                            <th>Order Ref</th>
                            <th>Patient Identity</th>
                            <th>CPT Code</th>
                            <th class="text-end">Amount</th>
                            <th class="text-center">Status</th>
                            <th class="text-end pe-4">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bills == null || bills.isEmpty()) { %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-receipt fs-1 d-block mb-2"></i>
                                    No billing records found in the system.
                                </td>
                            </tr>
                        <% } else { 
                            for(BllBilling.BillInfo b : bills) {
                                String statusBadge = "bg-secondary text-white";
                                if("Paid".equals(b.paymentStatus)) statusBadge = "bg-success text-white";
                                else if("Denied".equals(b.paymentStatus)) statusBadge = "bg-danger text-white";
                                else if("Pending".equals(b.paymentStatus)) statusBadge = "bg-warning text-dark";
                        %>
                        <tr>
                            <td class="ps-4">
                                <span class="bill-id">#<%= b.billId %></span>
                            </td>
                            <td>
                                <span class="text-muted small fw-bold">ORD-</span><%= b.orderId %>
                            </td>
                            <td>
                                <div class="fw-semibold"><%= b.patientName %></div>
                            </td>
                            <td>
                                <span class="cpt-code"><%= b.cptCode %></span>
                            </td>
                            <td class="text-end amount-text">
                                $<%= String.format("%.2f", b.amount) %>
                            </td>
                            <td class="text-center">
                                <span class="badge status-pill <%= statusBadge %>">
                                    <%= b.paymentStatus %>
                                </span>
                            </td>
                            <td class="text-end pe-4">
                                <div class="btn-group">
                                    <a href="billingForm.jsp?editId=<%= b.billId %>" class="btn btn-sm btn-light border px-3">
                                        <i class="bi bi-pencil me-1"></i> Edit
                                    </a>
                                    <a href="manageBilling.jsp?deleteId=<%= b.billId %>" 
                                       class="btn btn-sm btn-outline-danger px-3"
                                       onclick="return confirm('Confirm permanent deletion of bill #<%= b.billId %>?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
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

    <% if(request.getParameter("deleteId") != null) { %>
        <%
            try {
                int id = Integer.parseInt(request.getParameter("deleteId"));
                String deleteMsg = bll.deleteBill(id);
        %>
            <script>
                window.location.href = "manageBilling.jsp?message=" + encodeURIComponent("<%= deleteMsg %>");
            </script>
        <%
            } catch(Exception e) {}
        %>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>