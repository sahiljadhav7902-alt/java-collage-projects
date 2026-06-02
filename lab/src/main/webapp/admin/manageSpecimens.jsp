<%@ page import="com.mycompany.lab.BllSpecimen" %>
<%@ page import="java.util.List" %>

<%
    // LOGIC PRESERVED 100%
    BllSpecimen bll = new BllSpecimen();
    List<BllSpecimen.SpecimenInfo> specimens = bll.getAllSpecimens();
    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Specimen Lifecycle | PathLab Admin</title>
    
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

        .barcode-text {
            font-family: 'Monaco', 'Consolas', monospace;
            background: #f1f5f9;
            padding: 2px 6px;
            border-radius: 4px;
            color: #475569;
            font-size: 0.8rem;
        }

        .patient-name {
            font-weight: 600;
            color: var(--dark-header);
        }

        .time-label {
            display: block;
            font-size: 0.75rem;
            color: #94a3b8;
        }

        /* Status Badges Enhancement */
        .status-pill {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .btn-track {
            border: 1px solid #e2e8f0;
            background: white;
            color: #64748b;
            font-weight: 500;
        }
        
        .btn-results {
            background-color: #10b981;
            color: white;
            border: none;
            font-weight: 500;
        }

        .btn-results:hover {
            background-color: #059669;
            color: white;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold m-0">Specimen Tracking</h2>
                    <p class="text-muted small mb-0">Monitor lifecycle from collection to clinical validation</p>
                </div>
                <a href="specimenForm.jsp" class="btn btn-primary px-4 py-2 rounded-3 fw-bold shadow-sm">
                    <i class="bi bi-plus-circle-fill me-2"></i>Register Specimen
                </a>
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
                            <th class="ps-4">UID</th>
                            <th>Barcode</th>
                            <th>Patient Identity</th>
                            <th>Specimen Type</th>
                            <th>Collection Timeline</th>
                            <th>Technician</th>
                            <th>Current Status</th>
                            <th class="text-end pe-4">Control Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (specimens.isEmpty()) { %>
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-box-seam fs-1 d-block mb-2"></i>
                                    No specimens currently in the tracking pipeline.
                                </td>
                            </tr>
                        <% } else { 
                            for(BllSpecimen.SpecimenInfo s : specimens) {
                                
                                // Enhanced Badge Logic based on your original colors
                                String badgeClass = "bg-secondary";
                                if("Received".equals(s.status)) badgeClass = "bg-primary text-white";
                                else if("Processing".equals(s.status)) badgeClass = "bg-info text-dark";
                                else if("Completed".equals(s.status)) badgeClass = "bg-success text-white";
                                else if("Rejected".equals(s.status)) badgeClass = "bg-danger text-white";
                        %>
                        <tr>
                            <td class="ps-4 text-muted">#<%= s.specimenId %></td>
                            <td><span class="barcode-text"><%= s.specimenBarcode %></span></td>
                            <td>
                                <span class="patient-name"><%= s.patientName %></span>
                            </td>
                            <td>
                                <span class="badge bg-light text-dark border"><%= s.specimenType %></span>
                            </td>
                            <td>
                                <span class="time-label"><i class="bi bi-clock-history me-1"></i> Collected: <%= s.collectionTime %></span>
                                <span class="time-label"><i class="bi bi-building-down me-1"></i> Received: <%= (s.receivedTime != null) ? s.receivedTime : "Pending" %></span>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-person-circle me-2 text-muted"></i>
                                    <%= (s.technicianId != null) ? s.technicianId : "Unassigned" %>
                                </div>
                            </td>
                            <td>
                                <span class="badge status-pill <%= badgeClass %>"><%= s.status %></span>
                            </td>
                            <td class="text-end pe-4">
                                <div class="btn-group shadow-sm">
                                    <a href="specimenForm.jsp?editId=<%= s.specimenId %>" class="btn btn-sm btn-track" title="Update Chain of Custody">
                                        <i class="bi bi-diagram-3 me-1"></i> Track
                                    </a>
                                    <a href="enterResults.jsp?orderId=<%= s.orderId %>" class="btn btn-sm btn-results">
                                        <i class="bi bi-pencil-square me-1"></i> Results
                                    </a>
                                </div>
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