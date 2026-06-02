<%-- 
    Document   : payBill
    Created on : 20-Feb-2026, 10:08:36 pm
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllBilling" %>

<%
    Integer patientIdObj = (Integer) session.getAttribute("userId");
    if (patientIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String billIdParam = request.getParameter("billId");
    if (billIdParam == null) {
        response.sendRedirect("patientBilling.jsp");
        return;
    }

    int billId = Integer.parseInt(billIdParam);

    BllBilling bll = new BllBilling();
    BllBilling.BillInfo bill = bll.getBillById(billId);

    String message = "";

    // 🔥 Handle Payment Confirmation
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String result = bll.markBillAsPaid(billId);

        if (result.startsWith("SUCCESS")) {
            response.sendRedirect("patientBilling.jsp");
            return;
        } else {
            message = result;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Online Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<jsp:include page="patientNavbar.jsp" />

<div class="container mt-5">

    <div class="card shadow col-md-6 offset-md-3">
        <div class="card-header bg-primary text-white">
            <h4>Online Payment</h4>
        </div>

        <div class="card-body">

            <% if(!message.isEmpty()) { %>
                <div class="alert alert-danger"><%= message %></div>
            <% } %>

            <p><strong>Bill ID:</strong> #<%= bill.billId %></p>
            <p><strong>Order ID:</strong> #<%= bill.orderId %></p>
            <p><strong>Amount:</strong> $<%= bill.amount %></p>

            <hr>

            <!-- Dummy Card Form -->
            <form method="POST">

                <div class="mb-3">
                    <label>Card Number</label>
                    <input type="text" class="form-control" 
                           placeholder="4111 1111 1111 1111" required>
                </div>

                <div class="mb-3">
                    <label>Expiry</label>
                    <input type="text" class="form-control" 
                           placeholder="12/28" required>
                </div>

                <div class="mb-3">
                    <label>CVV</label>
                    <input type="password" class="form-control" 
                           placeholder="123" required>
                </div>

                <button type="submit" class="btn btn-success w-100">
                    Confirm Payment
                </button>
            </form>

        </div>
    </div>

</div>

</body>
</html>