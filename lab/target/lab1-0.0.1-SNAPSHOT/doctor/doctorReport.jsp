<%-- 
    Document   : doctorReport
    Created on : 21-Feb-2026
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllReportGenerator" %>
<%@ page import="java.util.List" %>

<%
    // --- START LOGIC PRESERVED ---
    String resultIdParam = request.getParameter("resultId");
    if (resultIdParam == null) {
        response.sendRedirect("doctorDashboard.jsp");
        return;
    }
    
    int resultId = Integer.parseInt(resultIdParam);
    BllReportGenerator bll = new BllReportGenerator();
    BllReportGenerator.FullReportData report = bll.generateReport(resultId);
    
    if (report == null) {
        out.println("<div class='alert alert-danger'>Error generating report. Data not found.</div>");
        return;
    }
    // --- END LOGIC PRESERVED ---
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report_#<%= report.orderId %>_<%= report.patientName.replace(" ", "_") %></title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono&display=swap" rel="stylesheet">

    <style>
        :root {
            --report-blue: #1e293b;
            --doctor-green: #059669;
            --critical-red: #be123c;
        }

        body { 
            background-color: #f1f5f9; 
            font-family: 'Inter', sans-serif;
            -webkit-print-color-adjust: exact;
        }

        .paper {
            background: white;
            width: 210mm;
            min-height: 297mm;
            margin: 30px auto;
            padding: 15mm;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            border-top: 8px solid var(--doctor-green);
        }

        /* Medical Header */
        .lab-brand { color: var(--doctor-green); font-weight: 800; letter-spacing: -1px; }
        .report-type { font-weight: 700; color: var(--report-blue); text-transform: uppercase; letter-spacing: 2px; }
        
        .metadata-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 15px;
            font-size: 0.9rem;
        }

        /* Results Table */
        .section-header {
            background: #f1f5f9;
            color: #475569;
            padding: 8px 15px;
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            border-radius: 4px;
            margin-top: 30px;
        }

        .report-table { width: 100%; margin-top: 15px; border-collapse: separate; border-spacing: 0; }
        .report-table th { 
            border-bottom: 2px solid #e2e8f0; 
            padding: 12px; 
            font-size: 0.8rem; 
            color: #64748b; 
            text-transform: uppercase;
        }
        .report-table td { padding: 12px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }

        .result-val { font-family: 'JetBrains Mono', monospace; font-weight: 700; font-size: 1.05rem; }
        
        /* Flags */
        .flag { font-weight: 800; font-size: 0.75rem; padding: 2px 8px; border-radius: 4px; }
        .flag-high { color: #991b1b; background: #fee2e2; }
        .flag-low { color: #075985; background: #e0f2fe; }
        .flag-critical { color: white !important; background: var(--critical-red) !important; animation: blink 2s infinite; }

        @keyframes blink { 50% { opacity: 0.7; } }

        /* Footer */
        .report-footer {
            margin-top: 60px;
            border-top: 1px solid #e2e8f0;
            padding-top: 20px;
            font-size: 0.8rem;
            color: #94a3b8;
        }

        @media print {
            body { background-color: white; margin: 0; padding: 0; }
            .paper { margin: 0; box-shadow: none; border-top: none; width: 100%; padding: 10mm; }
            .no-print { display: none !important; }
            .flag-critical { border: 1px solid var(--critical-red) !important; color: var(--critical-red) !important; background: transparent !important; }
        }
    </style>
</head>
<body>

    <div class="no-print container py-3">
        <div class="d-flex justify-content-between align-items-center bg-white p-3 rounded-4 shadow-sm">
            <div>
                <a href="doctorHistory.jsp" class="btn btn-light rounded-pill px-3">
                    <i class="bi bi-arrow-left me-2"></i>Back
                </a>
            </div>
            <div class="d-flex gap-2">
                <button onclick="window.print()" class="btn btn-success rounded-pill px-4">
                    <i class="bi bi-printer-fill me-2"></i>Print / Download PDF
                </button>
            </div>
        </div>
    </div>

    <div class="paper">
        
        <div class="row align-items-center mb-4">
            <div class="col-7">
                <h1 class="lab-brand m-0"><%= report.labName %></h1>
                <p class="text-muted small m-0">Diagnostic & Molecular Research Center</p>
            </div>
            <div class="col-5 text-end">
                <h4 class="report-type m-0">Lab Report</h4>
                <div class="text-secondary small">Ref: #<%= report.orderId %></div>
            </div>
        </div>

        <div class="row g-3">
            <div class="col-7">
                <div class="metadata-box h-100">
                    <div class="row">
                        <div class="col-4 text-muted">Patient Name:</div>
                        <div class="col-8 fw-bold text-dark"><%= report.patientName %></div>
                        
                        <div class="col-4 text-muted">MRN / ID:</div>
                        <div class="col-8 fw-semibold"><%= report.mrn %></div>
                        
                        <div class="col-4 text-muted">Gender/Age:</div>
                        <div class="col-8"><%= report.patientGender %> / <%= report.patientDob %></div>
                    </div>
                </div>
            </div>
            <div class="col-5">
                <div class="metadata-box h-100">
                    <div class="row">
                        <div class="col-5 text-muted">Ordered:</div>
                        <div class="col-7 text-end fw-medium"><%= report.orderDate %></div>
                        
                        <div class="col-5 text-muted">Reported:</div>
                        <div class="col-7 text-end fw-bold text-success"><%= report.reportDate %></div>
                        
                        <div class="col-5 text-muted">Status:</div>
                        <div class="col-7 text-end text-uppercase fw-bold small">Final</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4 px-2">
            <span class="text-muted small text-uppercase fw-bold">Requesting Physician:</span>
            <span class="ms-2 fw-semibold text-dark"><%= report.physicianName %></span>
            <hr class="my-2 opacity-50">
            <span class="text-muted small text-uppercase fw-bold">Clinical Diagnosis:</span>
            <span class="ms-2 text-dark"><%= (report.diagnosis != null) ? report.diagnosis : "Routine Investigation" %></span>
        </div>

        <div class="section-header">Diagnostic Results</div>
        
        <table class="report-table">
            <thead>
                <tr>
                    <th style="width: 35%">Investigation</th>
                    <th style="width: 15%">Result</th>
                    <th style="width: 10%">Unit</th>
                    <th style="width: 25%">Reference Range</th>
                    <th style="width: 15%" class="text-center">Interpretation</th>
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
                    <td>
                        <div class="fw-semibold text-dark"><%= r.testName %></div>
                        <div class="text-muted" style="font-size: 0.7rem;">Method: Automated Photometry</div>
                    </td>
                    <td class="result-val"><%= r.resultValue %></td>
                    <td class="text-secondary"><%= r.unit %></td>
                    <td class="text-muted small"><%= r.refRange %></td>
                    <td class="text-center">
                        <% if(r.flag != null && !r.flag.isEmpty()) { %>
                            <span class="flag <%= flagClass %>"><%= r.flag %></span>
                        <% } else { %>
                            <span class="text-success small fw-bold">Normal</span>
                        <% } %>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>

        <div class="row mt-5 pt-5">
            <div class="col-6">
                <div class="mb-4">
                    <p class="text-muted small fw-bold mb-1">Clinical Remarks:</p>
                    <p class="small text-secondary border-start ps-3 py-1">Results correlate with clinical symptoms. Please maintain clinical follow-up as advised.</p>
                </div>
                <div style="border-top: 1px solid #334155; width: 180px;" class="mt-5"></div>
                <p class="small fw-bold text-dark m-0">Lab Director</p>
                <p class="text-muted" style="font-size: 0.7rem;">Dr. Alan S. Pathologist (MD)</p>
            </div>
            <div class="col-6 text-end">
                <div class="mt-5">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=80x80&data=<%= report.orderId %>" alt="Verification QR" class="mb-2">
                    <p class="text-muted" style="font-size: 0.65rem;">Scan to verify original record online<br>Report ID: <%= report.orderId %>-<%= resultId %></p>
                </div>
            </div>
        </div>

        <div class="report-footer text-center">
            <p class="mb-0">*** End of Diagnostic Report ***</p>
            <p style="font-size: 0.7rem;">This is an electronically verified report and does not require a physical signature for validity.</p>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>