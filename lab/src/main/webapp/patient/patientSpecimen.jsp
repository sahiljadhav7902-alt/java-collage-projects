<%-- 
    Document   : patientSpecimen
    Updated on : 21-Feb-2026
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllSpecimen" %>
<%@ page import="java.util.List" %>

<%
    // --- LOGIC PRESERVED ---
    Integer patientIdObj = (Integer) session.getAttribute("userId");
    if (patientIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int patientId = patientIdObj;

    BllSpecimen bll = new BllSpecimen();
    List<BllSpecimen.PatientSpecimenInfo> specimens = bll.getSpecimensByPatient(patientId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Track My Samples | LabPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
        }

        .tracking-header {
            background: white;
            padding: 2.5rem 0;
            border-bottom: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }

        .specimen-card {
            background: white;
            border-radius: 20px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            transition: transform 0.2s ease;
        }

        /* Status Timeline Styling */
        .status-pill {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .st-collected { background: #eff6ff; color: #1d4ed8; }
        .st-transit { background: #fef9c3; color: #854d0e; }
        .st-received { background: #f0f9ff; color: #0369a1; }
        .st-processing { background: #f5f3ff; color: #5b21b6; }
        .st-completed { background: #dcfce7; color: #166534; }
        .st-rejected { background: #fee2e2; color: #991b1b; }

        .barcode-text {
            font-family: 'Monaco', 'Consolas', monospace;
            background: #f1f5f9;
            padding: 2px 8px;
            border-radius: 4px;
            color: #475569;
            font-size: 0.85rem;
        }

        .timestamp-box {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #64748b;
            font-size: 0.85rem;
        }

        .table-custom thead th {
            background: #f8fafc;
            text-transform: uppercase;
            font-size: 0.7rem;
            letter-spacing: 0.05rem;
            color: #94a3b8;
            padding: 1rem 1.25rem;
            border: none;
        }

        .table-custom td {
            padding: 1.25rem;
            border-bottom: 1px solid #f1f5f9;
        }
    </style>
</head>
<body>

    <jsp:include page="patientNavbar.jsp" />

    <header class="tracking-header">
        <div class="container">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Specimen Tracking</h2>
                    <p class="text-muted mb-0">Real-time status of your collected lab samples.</p>
                </div>
                <div>
                    <a href="patientOrders.jsp" class="btn btn-outline-primary rounded-pill px-4">
                        View All Orders
                    </a>
                </div>
            </div>
        </div>
    </header>

    <div class="container pb-5">
        
        <div class="specimen-card">
            <% if (specimens == null || specimens.isEmpty()) { %>
                <div class="text-center py-5">
                    <div class="mb-3">
                        <i class="bi bi-box-seam display-1 text-light"></i>
                    </div>
                    <h5 class="text-secondary">No Samples Found</h5>
                    <p class="text-muted px-4">Samples will appear here once they are collected at the diagnostic center.</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Order Ref</th>
                                <th>Barcode ID</th>
                                <th>Sample Type</th>
                                <th>Timeline</th>
                                <th>Current Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(BllSpecimen.PatientSpecimenInfo s : specimens) { 
                                String statusClass = "st-collected";
                                String icon = "bi-droplet";
                                
                                if("In Transit".equals(s.status)) { statusClass = "st-transit"; icon = "bi-truck"; }
                                else if("Received".equals(s.status)) { statusClass = "st-received"; icon = "bi-box-seam"; }
                                else if("Processing".equals(s.status)) { statusClass = "st-processing"; icon = "bi-microscope"; }
                                else if("Completed".equals(s.status)) { statusClass = "st-completed"; icon = "bi-check2-all"; }
                                else if("Rejected".equals(s.status)) { statusClass = "st-rejected"; icon = "bi-x-octagon"; }
                            %>
                            <tr>
                                <td>
                                    <span class="fw-bold text-dark">#<%= s.orderId %></span>
                                </td>
                                <td>
                                    <span class="barcode-text"><i class="bi bi-upc-scan me-1"></i> <%= s.specimenBarcode %></span>
                                </td>
                                <td>
                                    <div class="fw-medium text-dark"><%= s.specimenType %></div>
                                </td>
                                <td>
                                    <div class="timestamp-box mb-1">
                                        <i class="bi bi-calendar-check text-primary"></i>
                                        <span>Collected: <%= s.collectionTime %></span>
                                    </div>
                                    <% if(s.receivedTime != null) { %>
                                        <div class="timestamp-box">
                                            <i class="bi bi-building-check text-success"></i>
                                            <span>Received: <%= s.receivedTime %></span>
                                        </div>
                                    <% } else { %>
                                        <div class="timestamp-box opacity-50">
                                            <i class="bi bi-clock"></i>
                                            <span>Awaiting Lab Arrival</span>
                                        </div>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="status-pill <%= statusClass %>">
                                        <i class="bi <%= icon %>"></i> <%= s.status %>
                                    </span>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <div class="mt-4 p-4 bg-white rounded-4 border-start border-4 border-info shadow-sm">
            <h6 class="fw-bold"><i class="bi bi-info-circle me-2"></i>What do these statuses mean?</h6>
            <div class="row mt-3 g-3">
                <div class="col-md-4 small text-muted">
                    <strong>In Transit:</strong> Your sample is being securely transported to our central processing facility.
                </div>
                <div class="col-md-4 small text-muted">
                    <strong>Processing:</strong> Our lab technicians are currently performing the requested analysis.
                </div>
                <div class="col-md-4 small text-muted">
                    <strong>Rejected:</strong> Rarely, a sample may be unsuitable for testing. We will contact you immediately if a recolletion is needed.
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>