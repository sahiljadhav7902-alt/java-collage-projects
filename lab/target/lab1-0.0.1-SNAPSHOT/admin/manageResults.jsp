<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.lab.BllResult" %>
<%@ page import="java.util.List" %>

<%
    // LOGIC PRESERVED: ADMIN & DOCTOR SECURITY CHECK
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || (!"admin".equals(userRole) && !"doctor".equals(userRole))) {
        response.sendRedirect("../index.jsp");
        return;
    }

    BllResult bll = new BllResult();
    List<BllResult.ResultInfo> results = bll.getAllResults();
    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Result Oversight | PathLab</title>
    
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

        .page-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 30px 0;
            margin-bottom: 25px;
        }

        .content-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            overflow: hidden;
        }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 15px;
            border-bottom: 2px solid #f1f5f9;
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.88rem;
        }

        /* Result Value Styling */
        .res-value {
            font-weight: 700;
            color: var(--dark-header);
            font-size: 1rem;
        }
        .res-unit {
            font-size: 0.75rem;
            color: #64748b;
            font-weight: 400;
        }

        /* Status Badges */
        .status-pill {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.7rem;
            text-transform: uppercase;
        }

        /* Flag Styling */
        .flag-indicator {
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 0.75rem;
        }
        .flag-high { background: #fff7ed; color: #ea580c; border: 1px solid #fdba74; }
        .flag-low { background: #f0f9ff; color: #0284c7; border: 1px solid #7dd3fc; }
        .flag-critical { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; animation: pulse 2s infinite; }
        .flag-normal { color: #10b981; }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold m-0">Result Management</h2>
                    <p class="text-muted small mb-0">Review clinical findings and finalize diagnostic reports</p>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-filter me-2"></i>Filter</button>
                    <button class="btn btn-outline-primary btn-sm"><i class="bi bi-download me-2"></i>Export</button>
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">
        
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success border-0 shadow-sm rounded-3 mb-4">
                <i class="bi bi-check-circle-fill me-2"></i> <%= message %>
            </div>
        <% } %>

        <div class="content-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Order Info</th>
                            <th>Patient Identity</th>
                            <th>Test Parameter</th>
                            <th>Diagnostic Result</th>
                            <th>Ref. Range</th>
                            <th>Clinical Flag</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (results == null || results.isEmpty()) { %>
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-clipboard2-x fs-1 d-block mb-2"></i>
                                    No diagnostic results found in the system.
                                </td>
                            </tr>
                        <% } else { 
                            for (BllResult.ResultInfo r : results) {
                                String resultStatus = (r.resultStatus != null) ? r.resultStatus : "Preliminary";
                                String abnormalFlag = (r.abnormalFlag != null) ? r.abnormalFlag : "Normal";

                                // Status Badge Logic
                                String statusBadge = "bg-secondary";
                                if ("Preliminary".equals(resultStatus)) statusBadge = "bg-warning text-dark";
                                else if ("Final".equals(resultStatus)) statusBadge = "bg-success text-white";
                                else if ("Corrected".equals(resultStatus)) statusBadge = "bg-danger text-white";

                                // Flag Style Logic
                                String flagStyle = "flag-normal";
                                if ("High".equals(abnormalFlag)) flagStyle = "flag-high";
                                else if ("Low".equals(abnormalFlag)) flagStyle = "flag-low";
                                else if ("Critical".equals(abnormalFlag)) flagStyle = "flag-critical";
                        %>
                        <tr>
                            <td class="ps-4">
                                <span class="fw-bold text-primary">#<%= r.orderId %></span>
                                <div class="text-muted small" style="font-size: 0.7rem;">
                                    Ver: <%= r.validatedAt != null ? r.validatedAt : "Pending" %>
                                </div>
                            </td>
                            <td>
                                <div class="fw-semibold"><%= r.patientName != null ? r.patientName : "-" %></div>
                            </td>
                            <td>
                                <div class="text-dark"><%= r.testName != null ? r.testName : "-" %></div>
                            </td>
                            <td>
                                <span class="res-value"><%= r.resultValue != null ? r.resultValue : "-" %></span>
                                <span class="res-unit ms-1"><%= r.unit != null ? r.unit : "" %></span>
                            </td>
                            <td>
                                <code class="text-muted small"><%= r.referenceRange != null ? r.referenceRange : "N/A" %></code>
                            </td>
                            <td>
                                <span class="flag-indicator <%= flagStyle %>">
                                    <%= abnormalFlag %>
                                </span>
                            </td>
                            <td>
                                <span class="badge status-pill <%= statusBadge %>">
                                    <%= resultStatus %>
                                </span>
                            </td>
                            <td>
                                <a href="resultForm.jsp?resultId=<%= r.resultId %>" 
                                   class="btn btn-sm <%= "Preliminary".equals(resultStatus) ? "btn-primary" : "btn-light border" %> px-3">
                                    <%= "Preliminary".equals(resultStatus) ? "<i class='bi bi-shield-check me-1'></i> Verify" : "<i class='bi bi-eye me-1'></i> View" %>
                                </a>
                            </td>
                        </tr>
                        <% 
                            } 
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>