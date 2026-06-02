<%-- 
    Document   : labReport
    Created on : 18-Feb-2026, 10:50:08 pm
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllReportGenerator" %>
<%@ page import="java.util.List" %>

<%
    // 1. Get Parameters
    String resultIdParam = request.getParameter("resultId");
    String userType = (String) session.getAttribute("userType"); // 'patient', 'physician', 'admin'

    if (resultIdParam == null) {
        response.sendRedirect("patientDashboard.jsp"); // Fallback
        return;
    }
    
    int resultId = Integer.parseInt(resultIdParam);
    BllReportGenerator bll = new BllReportGenerator();
    BllReportGenerator.FullReportData report = null;

    // 2. Secure Fetch Logic
    if ("patient".equals(userType)) {
        // Patient View: Verify ownership
        Integer patientIdObj = (Integer) session.getAttribute("userId");
        if (patientIdObj == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        report = bll.generatePatientReport(resultId, patientIdObj);
    } else {
        // Doctor/Admin View: Standard Fetch (assuming they have general access)
        report = bll.generateReport(resultId);
    }
    
    // 3. Security Check
    if (report == null) {
%>
        <!DOCTYPE html>
        <html>
        <head><title>Access Denied</title></head>
        <body class="bg-light text-center p-5">
            <h1 class="text-danger">Access Denied</h1>
            <p>You do not have permission to view this report.</p>
            <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
        </body>
        </html>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Lab Report #<%= report.orderId %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .paper {
            background: white;
            width: 210mm;
            min-height: 297mm;
            margin: 20px auto;
            padding: 20mm;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            position: relative;
        }
        @media print {
            body { background-color: white; }
            .paper { margin: 0; box-shadow: none; width: 100%; padding: 0; border: none; }
            .no-print { display: none !important; }
        }
        .header-line { border-bottom: 2px solid #000; margin-bottom: 20px; padding-bottom: 10px; }
        .lab-title { color: #0056b3; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; }
        .report-title { font-size: 1.5em; font-weight: bold; color: #333; margin-bottom: 5px; }
        .section-title { font-weight: bold; background-color: #e9ecef; padding: 8px; margin-top: 25px; border-left: 5px solid #0056b3; border-radius: 4px; }
        table.report-table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 0.95em; }
        table.report-table th, table.report-table td { border: 1px solid #dee2e6; padding: 10px; vertical-align: middle; }
        table.report-table th { background-color: #f8f9fa; color: #495057; text-align: left; font-weight: 600; }
        .flag-high { color: #d9534f; font-weight: bold; background-color: #f8d7da; padding: 2px 6px; border-radius: 4px; }
        .flag-low { color: #0dcaf0; font-weight: bold; background-color: #cff4fc; padding: 2px 6px; border-radius: 4px; }
        .flag-critical { color: #dc3545; font-weight: 900; background-color: #f8d7da; padding: 4px 8px; border-radius: 4px; border: 1px solid #dc3545; }
    </style>
</head>
<body>

    <!-- Action Buttons -->
    <div class="no-print container mb-3 d-flex justify-content-between">
        <a href="javascript:history.back()" class="btn btn-secondary">&larr; Back</a>
        <button onclick="window.print()" class="btn btn-primary shadow">
            <i class="bi bi-printer-fill"></i> Download PDF / Print
        </button>
    </div>

    <!-- Report Paper -->
    <div class="paper">
        
        <!-- Header -->
        <div class="text-center mb-4">
            <div class="lab-title fs-2">Pathology Lab Information System</div>
            <div class="report-title">Final Laboratory Report</div>
            <div class="header-line"></div>
        </div>

        <!-- Patient & Order Info -->
        <div class="row mb-4">
            <div class="col-6">
                <div class="mb-1"><strong>Patient Name:</strong> <%= report.patientName %></div>
                <div class="mb-1"><strong>MRN:</strong> <%= report.mrn %></div>
                <div class="mb-1"><strong>Gender / DOB:</strong> <%= report.patientGender %> / <%= report.patientDob %></div>
            </div>
            <div class="col-6 text-end">
                <div class="mb-1"><strong>Order ID:</strong> #<%= report.orderId %></div>
                <div class="mb-1"><strong>Order Date:</strong> <%= report.orderDate %></div>
                <div class="mb-1"><strong>Report Date:</strong> <%= report.reportDate %></div>
            </div>
        </div>

        <!-- Physician Info -->
        <div class="mb-4 p-3 bg-light border rounded">
            <div class="row">
                <div class="col-6">
                    <strong>Requesting Physician:</strong> <%= (report.physicianName != null) ? report.physicianName : "N/A" %>
                </div>
                <div class="col-6 text-end">
                    <strong>Diagnosis:</strong> <%= (report.diagnosis != null) ? report.diagnosis : "-" %>
                </div>
            </div>
        </div>

        <!-- Results Table -->
        <div class="section-title">Investigation Results</div>
        <table class="report-table table-sm">
            <thead>
                <tr>
                    <th style="width: 35%">Test Name</th>
                    <th style="width: 20%">Result</th>
                    <th style="width: 10%">Unit</th>
                    <th style="width: 35%">Reference Range</th>
                </tr>
            </thead>
            <tbody>
                <% if (report.resultRows != null) { 
                    for (BllReportGenerator.FullReportData.ResultRow r : report.resultRows) { 
                        String flagClass = "";
                        if("High".equals(r.flag)) flagClass = "flag-high";
                        else if("Low".equals(r.flag)) flagClass = "flag-low";
                        else if("Critical".equals(r.flag)) flagClass = "flag-critical";
                %>
                <tr>
                    <td><%= r.testName %></td>
                    <td class="fw-bold fs-6"><%= r.resultValue %></td>
                    <td class="text-muted small"><%= r.unit %></td>
                    <td class="text-muted small"><%= r.refRange %></td>
                </tr>
                <!-- Add Flag Row below result if abnormal -->
                <% if (!"Normal".equals(r.flag)) { %>
                <tr>
                    <td colspan="4" class="p-1">
                        <span class="<%= flagClass %>">Flag: <%= r.flag %></span>
                    </td>
                </tr>
                <% } %>
                <% } } %>
            </tbody>
        </table>

        <!-- Footer -->
        <div style="position: absolute; bottom: 15mm; left: 20mm; right: 20mm;">
            <div class="row">
                <div class="col-8">
                    <div style="border-top: 1px solid #000; width: 60%; margin-top: 50px;"></div>
                    <small class="text-muted">Pathologist / Validating Technician Signature</small>
                </div>
                <div class="col-4 text-end mt-5">
                    <small class="text-muted fw-bold">End of Report</small>
                </div>
            </div>
        </div>

    </div>

</body>
</html>