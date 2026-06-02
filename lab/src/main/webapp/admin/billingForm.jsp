<%-- 
    Document   : billingForm
    Created on : 18-Feb-2026, 5:35:47 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllBilling" %>

<%
    String message = "";
    BllBilling bll = new BllBilling();
    BllBilling.BillInfo bill = null;
    boolean isEdit = false;

    // 1. Handle Form Submission (POST) - LOGIC PRESERVED
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("billId");
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String cptCode = request.getParameter("cptCode");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentStatus = request.getParameter("paymentStatus");

        if (idParam != null && !idParam.isEmpty()) {
            // UPDATE
            int id = Integer.parseInt(idParam);
            message = bll.updateBill(id, orderId, cptCode, amount, paymentStatus);
            bill = bll.getBillById(id);
            isEdit = true;
        } else {
            // ADD NEW
            message = bll.addBill(orderId, cptCode, amount, paymentStatus);
        }
    } else {
        // 2. Load Data for Edit - LOGIC PRESERVED
        if (request.getParameter("editId") != null) {
            isEdit = true;
            try {
                int id = Integer.parseInt(request.getParameter("editId"));
                bill = bll.getBillById(id);
            } catch (Exception e) {
                message = "Error loading bill.";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Edit Invoice" : "Generate Invoice" %> | Lab Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Inter', sans-serif;
            color: #1e293b;
        }
        .form-card {
            background: white;
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            overflow: hidden;
            margin-top: 2rem;
        }
        .card-header-custom {
            background: #1e293b;
            color: white;
            padding: 1.5rem 2rem;
            border: none;
        }
        .form-label {
            font-weight: 600;
            font-size: 0.85rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }
        .form-control, .form-select {
            padding: 0.75rem 1rem;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            background-color: #fcfdfe;
        }
        .form-control:focus, .form-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }
        .input-group-text {
            background-color: #f1f5f9;
            border-color: #e2e8f0;
            color: #64748b;
            border-radius: 10px 0 0 10px;
        }
        .btn-save {
            background-color: #059669;
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.2s;
        }
        .btn-save:hover {
            background-color: #047857;
            transform: translateY(-1px);
        }
        .btn-cancel {
            color: #64748b;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <jsp:include page="./adminNavbar.jsp" />

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="form-card">
                    <div class="card-header-custom">
                        <h4 class="mb-0 fw-bold">
                            <%= isEdit ? "Update Billing Record" : "Create New Invoice" %>
                        </h4>
                        <p class="mb-0 opacity-75 small mt-1">
                            <%= isEdit ? "Modify payment status or billing details for record #" + bill.billId : "Enter transaction details to generate a new patient bill." %>
                        </p>
                    </div>
                    
                    <div class="card-body p-4 p-md-5">
                        
                        <% if (!message.isEmpty()) { %>
                            <div class="alert alert-primary border-0 shadow-sm mb-4"><%= message %></div>
                        <% } %>

                        <form action="billingForm.jsp" method="POST">
                            <input type="hidden" name="billId" value="<%= (bill != null) ? bill.billId : "" %>">

                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">Linked Order ID</label>
                                    <div class="input-group">
                                        <span class="input-group-text">ORD-</span>
                                        <input type="number" name="orderId" class="form-control" 
                                               placeholder="0000"
                                               value="<%= (bill != null) ? bill.orderId : "" %>" required>
                                    </div>
                                    <div class="form-text mt-2 small text-muted">Unique reference number for the lab order.</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">CPT Code</label>
                                    <input type="text" name="cptCode" class="form-control" 
                                           placeholder="e.g. 80053"
                                           value="<%= (bill != null) ? bill.cptCode : "" %>" required>
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Total Amount</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" step="0.01" name="amount" class="form-control fw-bold text-dark" 
                                               placeholder="0.00"
                                               value="<%= (bill != null) ? bill.amount : "" %>" required>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Payment Transaction Status</label>
                                    <select name="paymentStatus" class="form-select" required>
                                        <option value="Pending" <%= (bill != null && "Pending".equals(bill.paymentStatus)) ? "selected" : "" %>>? Pending Payment</option>
                                        <option value="Paid" <%= (bill != null && "Paid".equals(bill.paymentStatus)) ? "selected" : "" %>>? Paid / Settled</option>
                                        <option value="Denied" <%= (bill != null && "Denied".equals(bill.paymentStatus)) ? "selected" : "" %>>? Payment Denied</option>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-5">
                                <a href="manageBilling.jsp" class="btn-cancel">Discard Changes</a>
                                <button type="submit" class="btn btn-success btn-save shadow-sm">
                                    <%= isEdit ? "Update Invoice" : "Generate Invoice" %>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <p class="text-center mt-4 text-muted small">
                    All financial modifications are logged for audit purposes.
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>