<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.lab.DataAccess" %>
<%@ page import="com.mycompany.lab.BllLaboratory" %>

<%
    // LOGIC PRESERVED EXACTLY
    String message = "";

    if (request.getParameter("deleteId") != null) {
        try {
            int deleteId = Integer.parseInt(request.getParameter("deleteId"));
            BllLaboratory bll = new BllLaboratory();
            message = bll.deleteLaboratory(deleteId);
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laboratory Network | PathLab Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
            padding: 40px 0;
            margin-bottom: 30px;
        }

        .page-header h2 {
            font-weight: 700;
            color: var(--dark-header);
            letter-spacing: -0.5px;
        }

        .content-card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
        }

        .table thead th {
            background-color: #f1f5f9;
            color: #64748b;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 15px;
            border: none;
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        .acc-badge {
            background-color: #e0f2fe;
            color: #0369a1;
            font-weight: 600;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.75rem;
            border: 1px solid #bae6fd;
        }

        .btn-add {
            background-color: var(--primary-blue);
            font-weight: 600;
            padding: 10px 24px;
            border-radius: 10px;
            transition: all 0.3s;
        }

        .btn-add:hover {
            background-color: #044ecb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(5, 97, 252, 0.2);
        }

        .lab-name {
            font-weight: 600;
            color: #1e293b;
            display: block;
        }

        .location-text {
            color: #64748b;
            font-size: 0.85rem;
        }

        footer {
            margin-top: 50px;
            padding: 30px;
            color: #94a3b8;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>

<jsp:include page="./adminNavbar.jsp" />

<header class="page-header text-center">
    <div class="container">
        <h2>Laboratory Network</h2>
        <p class="text-muted mb-0">Manage clinical branches, locations, and quality certifications</p>
    </div>
</header>

<div class="container mb-5">

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4 text-center">
            <i class="bi bi-info-circle-fill me-2"></i> <%= message %>
        </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="fw-bold m-0"><i class="bi bi-building-gear me-2 text-primary"></i>Branch Directory</h5>
        <a href="labForm.jsp" class="btn btn-primary btn-add text-white">
            <i class="bi bi-plus-circle-fill me-2"></i>Register New Lab
        </a>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th>Laboratory Name</th>
                        <th>Location/Address</th>
                        <th>Accreditation</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>

                <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    con = DataAccess.getConnection();
                    String sql = "SELECT lab_id, lab_name, location, accreditation FROM laboratories ORDER BY lab_id DESC";
                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    boolean hasData = false;

                    while (rs.next()) {
                        hasData = true;
                %>
                    <tr>
                        <td class="text-muted small">#<%= rs.getInt("lab_id") %></td>
                        <td>
                            <span class="lab-name"><%= rs.getString("lab_name") %></span>
                        </td>
                        <td>
                            <span class="location-text">
                                <i class="bi bi-geo-alt me-1 text-danger"></i>
                                <%= rs.getString("location") %>
                            </span>
                        </td>
                        <td>
                            <span class="acc-badge">
                                <i class="bi bi-patch-check-fill me-1"></i>
                                <%= rs.getString("accreditation") %>
                            </span>
                        </td>
                        <td class="text-end">
                            <div class="btn-group shadow-sm rounded">
                                <a href="labForm.jsp?editId=<%= rs.getInt("lab_id") %>" 
                                   class="btn btn-sm btn-white border border-end-0" title="Edit Lab Details">
                                    <i class="bi bi-pencil-square text-warning"></i>
                                </a>
                                <a href="manageLabs.jsp?deleteId=<%= rs.getInt("lab_id") %>"
                                   class="btn btn-sm btn-white border"
                                   onclick="return confirm('Are you sure you want to delete this laboratory? This action cannot be undone.')" title="Remove Branch">
                                    <i class="bi bi-trash text-danger"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                <%
                    }

                    if (!hasData) {
                %>
                    <tr>
                        <td colspan="5" class="text-center py-5 text-muted">
                            <i class="bi bi-building-exclamation fs-1 d-block mb-3"></i>
                            No laboratory branches registered in the system.
                        </td>
                    </tr>
                <%
                    }

                } catch (Exception e) {
                %>
                    <tr>
                        <td colspan="5" class="text-danger text-center py-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> Error loading branch data.
                        </td>
                    </tr>
                <%
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (Exception e) {}
                }
                %>

                </tbody>
            </table>
        </div>
    </div>
</div>

<footer class="text-center">
    <p class="mb-0">&copy; 2026 Pathology Lab System | Facility Management Module</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>