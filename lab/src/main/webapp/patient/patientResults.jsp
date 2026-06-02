<%-- 
    Document   : patientResults
    Updated on : 21-Feb-2026
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllResult" %>
<%@ page import="java.util.List" %>

<%
    // --- LOGIC PRESERVED ---
    Integer patientIdObj = (Integer) session.getAttribute("userId");
    if (patientIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int patientId = patientIdObj;

    BllResult bll = new BllResult();
    List<BllResult.ResultInfo> results = bll.getFinalizedResultsForPatient(patientId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Medical Reports | LabPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
        }

        .results-header {
            background: white;
            padding: 2.5rem 0;
            border-bottom: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }

        .info-banner {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            color: #0369a1;
            font-size: 0.9rem;
        }

        .result-card {
            background: white;
            border-radius: 20px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table-results thead th {
            background: #f8fafc;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05rem;
            color: #64748b;
            padding: 1.25rem;
            border: none;
        }

        .table-results td {
            padding: 1.25rem;
            border-bottom: 1px solid #f1f5f9;
        }

        .value-display {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
        }

        .unit-label {
            font-size: 0.8rem;
            color: #94a3b8;
            font-weight: 400;
        }

        /* Flag Indicators */
        .flag-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .flag-normal { background: #f0fdf4; color: #166534; }
        .flag-warning { background: #fffbeb; color: #92400e; }
        .flag-danger { background: #fef2f2; color: #991b1b; }
        .flag-info { background: #f0f9ff; color: #075985; }

        .btn-view-report {
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-view-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(2, 132, 199, 0.2);
        }
    </style>
</head>
<body>

    <jsp:include page="patientNavbar.jsp" />

    <header class="results-header">
        <div class="container">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Medical Reports</h2>
                    <p class="text-muted mb-0">Securely view and download your laboratory findings.</p>
                </div>
                <div>
                    <a href="patientDashboard.jsp" class="btn btn-outline-primary rounded-pill px-4">
                        <i class="bi bi-arrow-left me-2"></i>Dashboard
                    </a>
                </div>
            </div>
        </div>
    </header>

    <div class="container pb-5">
        
        <div class="info-banner mb-4 d-flex align-items-center">
            <i class="bi bi-shield-check fs-4 me-3"></i>
            <div>
                <strong>Clinical Note:</strong> Only verified results are displayed. For a comprehensive interpretation of these values, please schedule a follow-up with your prescribing physician.
            </div>
        </div>

        <div class="result-card">
            <% if (results == null || results.isEmpty()) { %>
                <div class="text-center py-5">
                    <img src="https://cdn-icons-png.flaticon.com/512/6598/6598519.png" alt="No reports" style="width: 80px; opacity: 0.2;" class="mb-3">
                    <h5 class="text-secondary">No Finalized Reports Yet</h5>
                    <p class="text-muted">Your results will appear here once the laboratory validation is complete.</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-results align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Test Date</th>
                                <th>Investigation</th>
                                <th>Measured Value</th>
                                <th>Reference Range</th>
                                <th>Clinical Flag</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(BllResult.ResultInfo r : results) { 
                                String flagClass = "flag-normal";
                                String flagIcon = "bi-check-circle";
                                
                                if ("High".equalsIgnoreCase(r.abnormalFlag)) {
                                    flagClass = "flag-warning";
                                    flagIcon = "bi-arrow-up-circle";
                                } else if ("Low".equalsIgnoreCase(r.abnormalFlag)) {
                                    flagClass = "flag-info";
                                    flagIcon = "bi-arrow-down-circle";
                                } else if ("Critical".equalsIgnoreCase(r.abnormalFlag)) {
                                    flagClass = "flag-danger";
                                    flagIcon = "bi-exclamation-octagon";
                                }
                            %>
                            <tr>
                                <td class="text-secondary small"><%= r.orderDate %></td>
                                <td>
                                    <div class="fw-semibold text-dark"><%= r.testName %></div>
                                </td>
                                <td>
                                    <span class="value-display"><%= r.resultValue %></span>
                                    <span class="unit-label ms-1"><%= r.unit %></span>
                                </td>
                                <td>
                                    <code class="text-muted bg-light px-2 py-1 rounded small"><%= r.referenceRange %></code>
                                </td>
                                <td>
                                    <span class="flag-pill <%= flagClass %>">
                                        <i class="bi <%= flagIcon %>"></i> <%= r.abnormalFlag %>
                                    </span>
                                </td>
                                <td class="text-end">
                                    <a href="labReport.jsp?resultId=<%= r.resultId %>" target="_blank" 
                                       class="btn btn-primary btn-view-report px-3">
                                        <i class="bi bi-filetype-pdf me-1"></i> View Report
                                    </a>
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