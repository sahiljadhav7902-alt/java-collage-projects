<%-- 
    Document   : viewOrderDetails
    Created on : 18-Feb-2026, 9:25:10 pm
    Author     : sahil jadhav
--%>
<%@ page import="com.mycompany.lab.BllOrder" %>
<%@ page import="com.mycompany.lab.BllResult" %>
<%@ page import="java.util.List" %>

<%
    // --- START LOGIC PRESERVED ---
    Integer physicianIdObj = (Integer) session.getAttribute("userId");
    if (physicianIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String orderIdParam = request.getParameter("orderId");
    if (orderIdParam == null || orderIdParam.isEmpty()) {
        response.sendRedirect("doctorDashboard.jsp");
        return;
    }
    int orderId = Integer.parseInt(orderIdParam);

    BllOrder bllOrder = new BllOrder();
    BllOrder.OrderInfo order = bllOrder.getOrderById(orderId);

    BllResult bllResult = new BllResult();
    List<BllResult.ResultInfo> results = bllResult.getResultsByPhysician(physicianIdObj);
    boolean hasFinalResults = false;
    for(BllResult.ResultInfo r : results) {
        if(r.orderId == orderId && "Final".equals(r.resultStatus)) {
            hasFinalResults = true;
            break;
        }
    }
    // --- END LOGIC PRESERVED ---
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details #<%= orderId %> | Lab Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --doctor-green: #059669;
            --slate-bg: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--slate-bg);
            color: #334155;
        }

        .page-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 25px 0;
            margin-bottom: 30px;
        }

        .detail-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            overflow: hidden;
        }

        .info-box {
            background-color: #f8fafc;
            border-radius: 12px;
            padding: 1.5rem;
            height: 100%;
            border: 1px solid #f1f5f9;
        }

        .label-text {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #94a3b8;
            margin-bottom: 0.5rem;
            display: block;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .test-item {
            padding: 12px 20px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
        }

        .test-item:last-child { border-bottom: none; }

        .btn-report {
            background-color: var(--doctor-green);
            color: white;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-report:hover {
            background-color: #047857;
            color: white;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

    <jsp:include page="doctorNavbar.jsp" />

    <header class="page-header">
        <div class="container d-flex justify-content-between align-items-center px-4">
            <div class="d-flex align-items-center">
                <a href="doctorMyOrders.jsp" class="btn btn-outline-secondary btn-sm rounded-circle me-3" style="width: 35px; height: 35px; padding: 4px;">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div>
                    <h3 class="fw-bold m-0">Order Summary</h3>
                    <p class="text-muted small mb-0">Requisition Reference: #<%= orderId %></p>
                </div>
            </div>
            
            <% if (order != null) { %>
            <span class="status-badge 
                <%= "Completed".equals(order.status) ? "bg-success-subtle text-success" : 
                    "Cancelled".equals(order.status) ? "bg-danger-subtle text-danger" : 
                    "Processing".equals(order.status) ? "bg-info-subtle text-info" : 
                    "Ordered".equals(order.status) ? "bg-warning-subtle text-warning" : "bg-primary-subtle text-primary" %>">
                <i class="bi bi-circle-fill me-2" style="font-size: 0.6rem;"></i><%= order.status %>
            </span>
            <% } %>
        </div>
    </header>

    <div class="container pb-5 px-4">
        <% if (order == null) { %>
            <div class="alert alert-danger rounded-4 border-0 shadow-sm p-4 text-center">
                <i class="bi bi-search fs-1 mb-3 d-block"></i>
                <h4 class="fw-bold">Order Not Found</h4>
                <p class="mb-0">The requested lab order could not be located in our clinical database.</p>
            </div>
        <% } else { %>

            <div class="detail-card">
                <div class="card-body p-4 p-md-5">
                    
                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <div class="info-box">
                                <span class="label-text"><i class="bi bi-person-fill me-1"></i> Patient</span>
                                <div class="fw-bold fs-4 text-dark"><%= order.patientName %></div>
                                <div class="text-secondary small">Case ID: <%= order.orderId %></div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-box">
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <span class="label-text"><i class="bi bi-calendar-event me-1"></i> Date</span>
                                        <div class="fw-semibold"><%= order.orderDate %></div>
                                    </div>
                                    <div class="col-6 mb-3 text-md-end">
                                        <span class="label-text"><i class="bi bi-person-badge me-1"></i> Physician</span>
                                        <div class="fw-semibold text-truncate"><%= (order.physicianName != null) ? order.physicianName : "N/A" %></div>
                                    </div>
                                    <div class="col-12">
                                        <span class="label-text"><i class="bi bi-clipboard2-pulse me-1"></i> Primary Diagnosis</span>
                                        <div class="fw-semibold text-dark"><%= (order.diagnosis != null) ? order.diagnosis : "None Provided" %></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-5">
                        <h6 class="label-text mb-3 px-1">Requisitioned Tests</h6>
                        <div class="border rounded-4 overflow-hidden">
                            <% 
                                String[] tests = order.tests.split(",");
                                for(String testName : tests) {
                                    testName = testName.trim();
                            %>
                            <div class="test-item bg-white">
                                <i class="bi bi-vial text-success me-3"></i>
                                <span class="fw-medium text-dark"><%= testName %></span>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center p-4 bg-light rounded-4 border">
                        <div class="mb-3 mb-md-0">
                            <% if (hasFinalResults) { %>
                                <div class="d-flex align-items-center">
                                    <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                        <i class="bi bi-check-lg fs-5"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-success">Results Finalized</div>
                                        <div class="small text-muted">A digital report is available for review.</div>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="d-flex align-items-center">
                                    <div class="bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                        <i class="bi bi-hourglass-split fs-5"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">Processing In-Progress</div>
                                        <div class="small text-muted">Laboratory technician is currently performing analysis.</div>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <div>
                            <% if (hasFinalResults) { %>
                                <a href="doctorReport.jsp?resultId=<%= orderId %>" class="btn btn-report px-4 py-2 shadow-sm">
                                    <i class="bi bi-file-earmark-medical me-2"></i> View Diagnostic Report
                                </a>
                            <% } %>
                        </div>
                    </div>

                </div>
            </div>

        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>