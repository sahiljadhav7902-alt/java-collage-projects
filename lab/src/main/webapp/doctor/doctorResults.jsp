<%-- 
    Document   : doctorResults
    Created on : 18-Feb-2026, 9:24:22 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllResult" %>
<%@ page import="java.util.List" %>

<%
    // 1. Get Physician ID from Session
    Integer physicianIdObj = (Integer) session.getAttribute("userId");
    if (physicianIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int physicianId = physicianIdObj;

    // 2. Fetch Data
    BllResult bll = new BllResult();
    List<BllResult.ResultInfo> results = bll.getResultsByPhysician(physicianId);
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Navbar -->
    <jsp:include page="doctorNavbar.jsp" />

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Patient Test Results</h2>
            <!-- Simple Filter Placeholder -->
            <div class="input-group" style="max-width: 300px;">
                <input type="text" class="form-control" placeholder="Search patient...">
                <button class="btn btn-outline-secondary" type="button"><i class="bi bi-search"></i></button>
            </div>
        </div>

        <!-- Results Table -->
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <% if (results.isEmpty()) { %>
                    <div class="text-center p-5 text-muted">
                        <i class="bi bi-file-earmark-medical fs-1"></i>
                        <p class="mt-3">No finalized results found for your patients.</p>
                    </div>
                <% } else { %>
                
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Order ID</th>
                                <th>Patient</th>
                                <th>Test Name</th>
                                <th>Result & Unit</th>
                                <th>Reference Range</th>
                                <th>Flag</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(BllResult.ResultInfo r : results) { 
                                
                                // Color Logic for Abnormal Flags
                                String flagClass = "text-success"; // Normal
                                String flagIcon = "bi-check-circle-fill";
                                if ("High".equals(r.abnormalFlag)) {
                                    flagClass = "text-warning fw-bold";
                                    flagIcon = "bi-exclamation-triangle-fill";
                                } else if ("Low".equals(r.abnormalFlag)) {
                                    flagClass = "text-info fw-bold";
                                    flagIcon = "bi-arrow-down-circle-fill";
                                } else if ("Critical".equals(r.abnormalFlag)) {
                                    flagClass = "text-danger fw-bold";
                                    flagIcon = "bi-exclamation-circle-fill";
                                }

                                // Status Logic
                                String statusBadge = "bg-secondary";
                                if ("Final".equals(r.resultStatus)) statusBadge = "bg-success";
                            %>
                            <tr>
                                <td><%= r.orderId %></td>
                                <td class="fw-bold"><%= r.patientName %></td>
                                <td><%= r.testName %></td>
                                <td class="fs-5">
                                    <%= r.resultValue %> 
                                    <span class="text-muted small"><%= r.unit %></span>
                                </td>
                                <td><small class="text-muted"><%= r.referenceRange %></small></td>
                                <td class="<%= flagClass %>">
                                    <i class="bi <%= flagIcon %>"></i> <%= r.abnormalFlag %>
                                </td>
                                <td><span class="badge <%= statusBadge %>"><%= r.resultStatus %></span></td>
                                <td class="text-end">
                                    <a href="doctorReport.jsp?resultId=<%= r.resultId %>" class="btn btn-sm btn-primary" title="Download Report">
                                        <i class="bi bi-file-earmark-pdf"></i> Report
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

    </div>

</body>
</html>