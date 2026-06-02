<%-- 
    Document   : doctorHistory
    Created on : 18-Feb-2026, 9:44:57 pm
    Author     : sahil jadhav
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.lab.BllOrder" %>
<%@ page import="java.util.List" %>

<%
    // --- START LOGIC PRESERVED ---
    Integer physicianIdObj = (Integer) session.getAttribute("userId");
    if (physicianIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int physicianId = physicianIdObj;

    BllOrder bll = new BllOrder();
    List<BllOrder.HistoryItem> history = bll.getCompletedOrdersForHistory(physicianId);
    // --- END LOGIC PRESERVED ---
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient History | Lab Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --doctor-green: #059669;
            --slate-bg: #f8fafc;
            --border-color: #e2e8f0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--slate-bg);
            color: #334155;
        }

        .page-header {
            background: white;
            border-bottom: 1px solid var(--border-color);
            padding: 25px 0;
            margin-bottom: 30px;
        }

        .search-container {
            position: relative;
            max-width: 400px;
        }

        .search-container .bi-search {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        .search-input {
            padding-left: 45px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            height: 45px;
            transition: all 0.2s;
        }

        .search-input:focus {
            border-color: var(--doctor-green);
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
        }

        .history-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            overflow: hidden;
        }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 15px 20px;
        }

        .table tbody td {
            padding: 16px 20px;
            border-bottom: 1px solid #f1f5f9;
        }

        .patient-name {
            font-weight: 600;
            color: #1e293b;
        }

        .status-pill {
            background: #dcfce7;
            color: #166534;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .btn-report {
            background-color: #fff;
            color: var(--doctor-green);
            border: 1px solid var(--doctor-green);
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-report:hover {
            background-color: var(--doctor-green);
            color: #fff;
        }

        .empty-state {
            padding: 80px 0;
        }
    </style>
</head>
<body>

    <jsp:include page="doctorNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2 class="fw-bold m-0 text-dark">Order History</h2>
                    <p class="text-muted small mb-0">Review all completed diagnostic records.</p>
                </div>
                <div class="col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <div class="search-container w-100">
                        <i class="bi bi-search"></i>
                        <input type="text" id="searchInput" class="form-control search-input" 
                               placeholder="Search patient records..." onkeyup="filterTable()">
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">
        
        <div class="history-card">
            <% if (history == null || history.isEmpty()) { %>
                <div class="text-center empty-state">
                    <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                        <i class="bi bi-clock-history text-muted fs-2"></i>
                    </div>
                    <h4 class="fw-bold text-dark">No Archived Records</h4>
                    <p class="text-muted mx-auto" style="max-width: 300px;">Completed orders will appear here automatically once finalized by the lab.</p>
                </div>
            <% } else { %>
            
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="historyTable">
                    <thead>
                        <tr>
                            <th style="width: 120px;">Order ID</th>
                            <th>Patient Identity</th>
                            <th>Finalized Date</th>
                            <th>Diagnosis</th>
                            <th>Outcome</th>
                            <th class="text-end">Records</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(BllOrder.HistoryItem h : history) { %>
                        <tr>
                            <td><span class="text-secondary small fw-medium">#<%= h.orderId %></span></td>
                            <td>
                                <div class="patient-name"><%= h.patientName %></div>
                            </td>
                            <td>
                                <div class="small text-dark"><%= h.orderDate %></div>
                            </td>
                            <td>
                                <div class="text-muted small text-truncate" style="max-width: 200px;">
                                    <%= (h.diagnosis != null && !h.diagnosis.isEmpty()) ? h.diagnosis : "N/A" %>
                                </div>
                            </td>
                            <td>
                                <span class="status-pill">
                                    <i class="bi bi-check2-all me-1"></i> Completed
                                </span>
                            </td>
                            <td class="text-end">
                                <a href="doctorReport.jsp?resultId=<%= h.sampleResultId %>" 
                                   class="btn btn-sm btn-report px-3 py-1">
                                    <i class="bi bi-file-earmark-pdf-fill me-1"></i> View Report
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

    <script>
        function filterTable() {
            const input = document.getElementById("searchInput");
            const filter = input.value.toUpperCase();
            const table = document.getElementById("historyTable");
            const tr = table.getElementsByTagName("tr");

            for (let i = 1; i < tr.length; i++) {
                // Target Patient Name (Column 1)
                const td = tr[i].getElementsByTagName("td")[1];
                if (td) {
                    const txtValue = td.textContent || td.innerText;
                    tr[i].style.display = txtValue.toUpperCase().includes(filter) ? "" : "none";
                }
            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>