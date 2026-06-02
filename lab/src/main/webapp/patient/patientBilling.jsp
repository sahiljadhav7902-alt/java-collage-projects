<%-- 
    Document   : patientBilling
    Updated on : 21-Feb-2026
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllBilling" %>
<%@ page import="java.util.List" %>

<%
    // --- LOGIC PRESERVED ---
    Integer patientIdObj = (Integer) session.getAttribute("userId");
    if (patientIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int patientId = patientIdObj;

    BllBilling bll = new BllBilling();
    double totalDue = bll.getTotalOutstanding(patientId);
    List<BllBilling.PatientBillInfo> bills = bll.getBillsByPatient(patientId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing & Payments | LabPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
        }

        .billing-header {
            background: white;
            padding: 2.5rem 0;
            border-bottom: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }

        .summary-card {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: white;
            border-radius: 24px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .summary-card::after {
            content: "";
            position: absolute;
            right: -20px;
            top: -20px;
            width: 150px;
            height: 150px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }

        .info-card {
            background: white;
            border-radius: 24px;
            border: 1px dashed #cbd5e1;
            padding: 2rem;
            height: 100%;
            display: flex;
            align-items: center;
        }

        .invoice-card {
            background: white;
            border-radius: 20px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table-billing thead th {
            background: #f8fafc;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05rem;
            color: #64748b;
            padding: 1.25rem;
        }

        .table-billing td {
            padding: 1.25rem;
            border-bottom: 1px solid #f1f5f9;
        }

        .badge-status {
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .pay-btn {
            border-radius: 10px;
            font-weight: 700;
            padding: 8px 20px;
            transition: all 0.2s;
        }

        .amount-text {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
        }
    </style>
</head>
<body>

    <jsp:include page="patientNavbar.jsp" />

    <header class="billing-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Billing & Invoices</h2>
                    <p class="text-muted mb-0">Track your expenses and clear outstanding dues.</p>
                </div>
                <a href="patientDashboard.jsp" class="btn btn-outline-secondary rounded-pill px-4">
                    Dashboard
                </a>
            </div>
        </div>
    </header>

    <div class="container pb-5">
        
        <div class="row g-4 mb-5">
            <div class="col-lg-5">
                <div class="summary-card shadow-lg">
                    <h6 class="text-uppercase opacity-75 small fw-bold mb-3">Total Outstanding Balance</h6>
                    <h1 class="display-5 fw-bold mb-3">₹<%= String.format("%.2f", totalDue) %></h1>
                    <p class="mb-0 opacity-75 small">
                        <i class="bi bi-info-circle me-1"></i> Balance includes all pending and denied service claims.
                    </p>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="info-card">
                    <div class="d-flex align-items-center gap-4">
                        <div class="bg-primary bg-opacity-10 p-4 rounded-circle">
                            <i class="bi bi-credit-card-2-back fs-2 text-primary"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1">Payment Policy</h6>
                            <p class="text-muted small mb-0">
                                To avoid delays in report generation, please ensure all "Pending" invoices are settled. 
                                For "Denied" payments, please visit the helpdesk with your insurance details.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="invoice-card">
            <div class="card-header bg-white py-3 border-0">
                <h5 class="fw-bold mb-0">Transaction History</h5>
            </div>
            <% if (bills.isEmpty()) { %>
                <div class="text-center py-5">
                    <i class="bi bi-receipt-cutoff display-1 text-light"></i>
                    <h5 class="text-secondary mt-3">No Invoices Found</h5>
                    <p class="text-muted">You haven't been billed for any services yet.</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-billing align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Invoice ID</th>
                                <th>Order Date</th>
                                <th>Details</th>
                                <th class="text-end">Amount</th>
                                <th class="text-center">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (BllBilling.PatientBillInfo b : bills) {
                                String badgeClass = "bg-secondary-subtle text-secondary";
                                String icon = "bi-question-circle";
                                boolean isPending = "Pending".equals(b.paymentStatus);

                                if ("Paid".equals(b.paymentStatus)) {
                                    badgeClass = "bg-success-subtle text-success";
                                    icon = "bi-check-circle-fill";
                                } else if (isPending) {
                                    badgeClass = "bg-warning-subtle text-warning-emphasis";
                                    icon = "bi-clock-fill";
                                } else if ("Denied".equals(b.paymentStatus)) {
                                    badgeClass = "bg-danger-subtle text-danger";
                                    icon = "bi-exclamation-octagon-fill";
                                }
                            %>
                            <tr>
                                <td class="fw-bold text-dark">#<%= b.billId %></td>
                                <td class="text-secondary small"><%= b.orderDate %></td>
                                <td>
                                    <div class="fw-semibold text-dark">Lab Services</div>
                                    <div class="small text-muted">Ref: #<%= b.orderId %> | CPT: <%= b.cptCode %></div>
                                </td>
                                <td class="text-end">
                                    <span class="amount-text">₹<%= String.format("%.2f", b.amount) %></span>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex flex-column align-items-center gap-2">
                                        <span class="badge-status <%= badgeClass %>">
                                            <i class="bi <%= icon %>"></i> <%= b.paymentStatus %>
                                        </span>

                                        <% if (isPending) { %>
                                            <a href="payBill.jsp?billId=<%= b.billId %>" 
                                               class="btn btn-success pay-btn btn-sm">
                                                Proceed to Pay
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