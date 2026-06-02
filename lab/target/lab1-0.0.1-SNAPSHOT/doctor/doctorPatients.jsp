<%-- 
    Document   : doctorPatients
    Created on : 18-Feb-2026, 6:00:53 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllPatient" %>
<%@ page import="java.util.List" %>

<%
    // LOGIC PRESERVED
    String query = request.getParameter("q");
    List<BllPatient> patients = null;

    if (query != null && !query.trim().isEmpty()) {
        BllPatient bll = new BllPatient();
        patients = bll.searchPatients(query);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Search | Lab Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --doctor-green: #059669;
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

        .search-container {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            padding: 2rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            margin-bottom: 2rem;
        }

        .form-control-search {
            border-radius: 12px;
            padding: 0.75rem 1.25rem;
            border: 2px solid #e2e8f0;
            font-size: 1rem;
            transition: all 0.2s;
        }

        .form-control-search:focus {
            border-color: var(--doctor-green);
            box-shadow: 0 0 0 4px rgba(5, 150, 105, 0.1);
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
        }

        .mrn-tag {
            background: #f1f5f9;
            font-family: 'Courier New', monospace;
            padding: 3px 8px;
            border-radius: 6px;
            font-size: 0.85rem;
            color: #475569;
            font-weight: 600;
        }

        .btn-order {
            background-color: var(--doctor-green);
            color: white;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-order:hover {
            background-color: #047857;
            color: white;
            transform: translateY(-1px);
        }

        .empty-state {
            padding: 5rem 0;
            text-align: center;
            color: #94a3b8;
        }
    </style>
</head>
<body>

    <jsp:include page="doctorNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <h2 class="fw-bold m-0">Patient Search</h2>
            <p class="text-muted small mb-0">Locate clinical records and initiate new lab requisitions.</p>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">
        <div class="row justify-content-center">
            <div class="col-xl-10">
                
                <div class="search-container">
                    <form action="doctorPatients.jsp" method="GET" class="row g-3">
                        <div class="col-md-9">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0 rounded-start-3" style="border: 2px solid #e2e8f0;">
                                    <i class="bi bi-search text-muted"></i>
                                </span>
                                <input type="text" name="q" class="form-control form-control-search border-start-0" 
                                       placeholder="Enter Patient Name or MRN (e.g. John Doe / P-100)..." 
                                       value="<%= (query != null) ? query : "" %>" required autofocus>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-success w-100 py-2 rounded-3 fw-bold">
                                Search Records
                            </button>
                        </div>
                    </form>
                </div>

                <% if (query != null && !query.trim().isEmpty()) { %>
                    
                    <% if (patients == null || patients.isEmpty()) { %>
                        <div class="alert bg-white border border-warning-subtle text-center py-4 rounded-4 shadow-sm">
                            <i class="bi bi-person-exclamation fs-2 text-warning"></i>
                            <h5 class="mt-2 fw-bold text-dark">No records found</h5>
                            <p class="text-muted mb-0 small">We couldn't find any patient matching "<strong><%= query %></strong>". Please verify the MRN or spelling.</p>
                        </div>
                    <% } else { %>
                        
                        <div class="content-card">
                            <div class="px-4 py-3 border-bottom bg-white d-flex justify-content-between align-items-center">
                                <h6 class="fw-bold m-0">Search Results for "<%= query %>"</h6>
                                <span class="badge bg-light text-dark border"><%= patients.size() %> Match(es)</span>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">MRN</th>
                                            <th>Patient Name</th>
                                            <th>Gender</th>
                                            <th>Date of Birth</th>
                                            <th>Contact</th>
                                            <th class="text-end pe-4">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for(BllPatient p : patients) { %>
                                        <tr>
                                            <td class="ps-4"><span class="mrn-tag"><%= p.mrn %></span></td>
                                            <td>
                                                <div class="fw-bold text-dark"><%= p.firstName %> <%= p.lastName %></div>
                                                <div class="text-muted" style="font-size: 0.75rem;"><%= p.email %></div>
                                            </td>
                                            <td><span class="text-capitalize small"><%= p.gender %></span></td>
                                            <td><small><%= p.dateOfBirth %></small></td>
                                            <td><small><i class="bi bi-telephone me-1 text-muted"></i> <%= p.phone %></small></td>
                                            <td class="text-end pe-4">
                                                <a href="doctorOrderForm.jsp?patientId=<%= p.userId %>" 
                                                   class="btn btn-sm btn-order px-3">
                                                    <i class="bi bi-file-earmark-plus me-1"></i> Order Test
                                                </a>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    <% } %>

                <% } else { %>
                    <div class="empty-state">
                        <i class="bi bi-person-vcard fs-1 opacity-25"></i>
                        <h4 class="mt-3 text-dark fw-semibold">Find a Patient</h4>
                        <p class="small">Search our clinical database by Name or Medical Record Number (MRN) <br>to create new laboratory orders or view history.</p>
                    </div>
                <% } %>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>