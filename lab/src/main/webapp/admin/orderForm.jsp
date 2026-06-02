<%@ page import="com.mycompany.lab.BllOrder" %>

<%
    // LOGIC PRESERVED EXACTLY
    String message = "";
    BllOrder bll = new BllOrder();
    BllOrder.OrderInfo order = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        message = bll.updateOrderStatus(orderId, status);
        order = bll.getOrderById(orderId);
    } else {
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam != null) {
            try {
                int id = Integer.parseInt(orderIdParam);
                order = bll.getOrderById(id);
            } catch (Exception e) {
                message = "Error loading order.";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Order #<%= (order != null) ? order.orderId : "" %> | PathLab</title>
    
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

        .content-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            overflow: hidden;
        }

        .card-header-custom {
            background: #f1f5f9;
            padding: 15px 20px;
            font-weight: 600;
            color: var(--dark-header);
            border-bottom: 1px solid #e2e8f0;
        }

        .detail-label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            font-weight: 600;
        }

        .detail-value {
            font-weight: 500;
            color: var(--dark-header);
        }

        .test-pill {
            display: inline-block;
            background: #f1f5f9;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.85rem;
            margin-right: 5px;
            margin-bottom: 5px;
            border: 1px solid #e2e8f0;
        }

        .btn-update {
            background-color: var(--primary-blue);
            border: none;
            padding: 10px;
            font-weight: 600;
            border-radius: 10px;
        }

        .btn-update:hover {
            background-color: #044ecb;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <div class="container py-5">
        <% if (order == null) { %>
            <div class="alert alert-danger border-0 shadow-sm rounded-3">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> Order not found.
            </div>
            <a href="manageOrders.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i> Back to Orders
            </a>
        <% } else { %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold text-dark">Manage Order <span class="text-primary">#<%= order.orderId %></span></h2>
                <a href="manageOrders.jsp" class="btn btn-outline-secondary px-4 rounded-pill">
                    <i class="bi bi-arrow-left me-1"></i> Back to List
                </a>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4">
                    <i class="bi bi-info-circle-fill me-2"></i> <%= message %>
                </div>
            <% } %>

            <div class="row g-4">
                <div class="col-md-8">
                    <div class="content-card mb-4">
                        <div class="card-header-custom">
                            <i class="bi bi-file-earmark-text me-2"></i>Order Information
                        </div>
                        <div class="card-body p-4">
                            <div class="row mb-4">
                                <div class="col-sm-4 detail-label">Patient Name</div>
                                <div class="col-sm-8 detail-value"><%= order.patientName %></div>
                            </div>
                            <hr class="opacity-10">
                            <div class="row mb-4">
                                <div class="col-sm-4 detail-label">Requesting Physician</div>
                                <div class="col-sm-8 detail-value"><%= (order.physicianName != null) ? order.physicianName : "N/A" %></div>
                            </div>
                            <hr class="opacity-10">
                            <div class="row mb-4">
                                <div class="col-sm-4 detail-label">Primary Diagnosis</div>
                                <div class="col-sm-8 detail-value text-primary"><%= (order.diagnosis != null) ? order.diagnosis : "None Provided" %></div>
                            </div>
                            <hr class="opacity-10">
                            <div class="row mb-4">
                                <div class="col-sm-4 detail-label">Tests Requested</div>
                                <div class="col-sm-8">
                                    <% String[] tests = order.tests.split(","); 
                                       for(String t : tests) { %>
                                        <span class="test-pill"><%= t.trim() %></span>
                                    <% } %>
                                </div>
                            </div>
                            <hr class="opacity-10">
                            <div class="row">
                                <div class="col-sm-4 detail-label">Registration Date</div>
                                <div class="col-sm-8 text-muted"><%= order.orderDate %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="content-card border-top border-primary border-4">
                        <div class="card-header-custom">
                            <i class="bi bi-arrow-repeat me-2"></i>Update Progression
                        </div>
                        <div class="card-body p-4">
                            <form action="orderForm.jsp" method="POST">
                                <input type="hidden" name="orderId" value="<%= order.orderId %>">
                                
                                <div class="mb-4">
                                    <label class="form-label detail-label">Current State</label>
                                    <div class="p-3 bg-light rounded-3 border text-center fw-bold text-primary">
                                        <%= order.status %>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="status" class="form-label detail-label">Assign New Status</label>
                                    <select class="form-select border-0 bg-light p-3" id="status" name="status" required style="border-radius: 12px;">
                                        <option value="">-- Select Status --</option>
                                        <option value="Ordered" <%= "Ordered".equals(order.status) ? "selected" : "" %>>Ordered</option>
                                        <option value="Collected" <%= "Collected".equals(order.status) ? "selected" : "" %>>Collected</option>
                                        <option value="Processing" <%= "Processing".equals(order.status) ? "selected" : "" %>>Processing</option>
                                        <option value="Completed" <%= "Completed".equals(order.status) ? "selected" : "" %>>Completed</option>
                                        <option value="Cancelled" <%= "Cancelled".equals(order.status) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 btn-update py-3">
                                    <i class="bi bi-check-circle me-2"></i>Apply Changes
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>