<%-- 
    Document   : resultForm
    Author     : sahil jadhav
--%>
<%@ page import="com.mycompany.lab.BllResult" %>

<%
    // Fix: Resolve potential 500 error by ensuring variable is declared
    String userRole = (String) session.getAttribute("userRole");

    String message = "";
    BllResult bll = new BllResult();
    BllResult.ResultInfo result = null;

    // 1. Handle Verification (POST) - LOGIC PRESERVED
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int resultId = Integer.parseInt(request.getParameter("resultId"));
        String val = request.getParameter("resultValue");
        String unit = request.getParameter("unit");
        String ref = request.getParameter("referenceRange");
        String flag = request.getParameter("abnormalFlag");
        String status = request.getParameter("resultStatus");
        
        message = bll.verifyResult(resultId, val, unit, ref, flag, status);
        result = bll.getResultById(resultId);
    } else {
        // 2. Load Data - LOGIC PRESERVED
        String idParam = request.getParameter("resultId");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                result = bll.getResultById(id);
            } catch (Exception e) {
                message = "Error loading result.";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Verify Result | Lab Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f0f4f8;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #1e293b;
        }
        .main-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
            overflow: hidden;
            background: white;
            margin-top: 2rem;
        }
        .header-gradient {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: white;
            padding: 2rem;
            border: none;
        }
        .patient-context {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .form-label {
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            margin-bottom: 0.5rem;
        }
        .form-control, .form-select {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            border: 1px solid #cbd5e1;
            font-weight: 500;
        }
        .form-control:focus, .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        .val-input {
            color: #2563eb;
            font-size: 1.1rem;
            font-weight: 700;
        }
        .btn-action {
            padding: 0.8rem 2rem;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-finalize {
            background: #10b981;
            color: white;
            border: none;
        }
        .btn-finalize:hover {
            background: #059669;
            transform: translateY(-1px);
        }
        .audit-info {
            background: #f8fafc;
            padding: 1rem;
            font-size: 0.8rem;
            color: #94a3b8;
            border-top: 1px solid #f1f5f9;
        }
    </style>
</head>
<body>

<jsp:include page="./adminNavbar.jsp" />

<div class="container pb-5">
    <% if (result == null) { %>
        <div class="mt-5 text-center">
            <div class="alert alert-warning d-inline-block px-5 shadow-sm">
                <strong>Notice:</strong> Result record not found or inaccessible.
            </div>
            <br>
            <a href="manageResults.jsp" class="btn btn-secondary mt-3 rounded-pill px-4">Back to Dashboard</a>
        </div>
    <% } else { %>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="main-card">
                    <div class="header-gradient">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="fw-bold mb-1">Clinical Validation</h3>
                                <p class="mb-0 opacity-75">Electronic Laboratory Verification</p>
                            </div>
                            <div class="text-end">
                                <span class="badge bg-primary rounded-pill px-3 py-2">Order #<%= result.orderId %></span>
                            </div>
                        </div>
                    </div>

                    <div class="card-body p-4 p-md-5">
                        <% if (!message.isEmpty()) { %>
                            <div class="alert alert-info border-0 rounded-3 mb-4"><%= message %></div>
                        <% } %>

                        <div class="patient-context">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label d-block">Patient Name</label>
                                    <span class="fw-bold fs-5 text-dark">
                                        <%= (result.patientName != null) ? result.patientName : "Patient Identity Pending" %>
                                    </span>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label d-block">Laboratory Test</label>
                                    <span class="fw-bold fs-5 text-dark"><%= result.testName %></span>
                                </div>
                            </div>
                        </div>

                        <form action="resultForm.jsp" method="POST">
                            <input type="hidden" name="resultId" value="<%= result.resultId %>">

                            <div class="row g-4">
                                <div class="col-md-4">
                                    <label class="form-label">Observed Value</label>
                                    <input type="text" name="resultValue" class="form-control val-input" 
                                           value="<%= result.resultValue != null ? result.resultValue : "" %>" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Unit</label>
                                    <input type="text" name="unit" class="form-control" 
                                           value="<%= result.unit != null ? result.unit : "" %>">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Reference Range</label>
                                    <input type="text" name="referenceRange" class="form-control" 
                                           value="<%= result.referenceRange != null ? result.referenceRange : "" %>">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Clinical Flag</label>
                                    <select name="abnormalFlag" class="form-select">
                                        <option value="Normal" <%= "Normal".equals(result.abnormalFlag) ? "selected" : "" %>>Normal</option>
                                        <option value="High" <%= "High".equals(result.abnormalFlag) ? "selected" : "" %>>High (Above Range)</option>
                                        <option value="Low" <%= "Low".equals(result.abnormalFlag) ? "selected" : "" %>>Low (Below Range)</option>
                                        <option value="Critical" <%= "Critical".equals(result.abnormalFlag) ? "selected" : "" %>>Critical Value</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Report Status</label>
                                    <select name="resultStatus" class="form-select border-primary" required>
                                        <option value="Preliminary" <%= "Preliminary".equals(result.resultStatus) ? "selected" : "" %>>Preliminary</option>
                                        <option value="Final" <%= "Final".equals(result.resultStatus) ? "selected" : "" %>>Final (Verified)</option>
                                        <option value="Corrected" <%= "Corrected".equals(result.resultStatus) ? "selected" : "" %>>Corrected</option>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-5 pt-3">
                                <a href="manageResults.jsp" class="text-secondary text-decoration-none fw-bold small">DISCARD CHANGES</a>
                                <button type="submit" class="btn btn-action btn-finalize">
                                    <%= "Preliminary".equals(result.resultStatus) ? "VERIFY & FINALIZE" : "UPDATE RECORD" %>
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="audit-info text-center">
                        Validation ID: <strong>REC-<%= result.resultId %></strong> | 
                        Clinician Session: <strong><%= userRole != null ? userRole : "ADMIN" %></strong>
                    </div>
                </div>
            </div>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>