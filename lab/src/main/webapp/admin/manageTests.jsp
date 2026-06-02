<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.lab.DataAccess" %>

<%
    // ADMIN SECURITY CHECK PRESERVED
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String message = "";

    // DELETE FUNCTION PRESERVED
    if (request.getParameter("deleteId") != null) {
        int deleteId = Integer.parseInt(request.getParameter("deleteId"));
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            String sql = "DELETE FROM tests WHERE test_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, deleteId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "Diagnostic test removed from catalog.";
            } else {
                message = "Test record not found.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Catalog | PathLab Admin</title>
    
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
            padding: 35px 0;
            margin-bottom: 30px;
        }

        .content-card {
            background: white;
            padding: 20px;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
        }

        .table thead th {
            background-color: #f1f5f9;
            color: #64748b;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 15px;
            border: none;
        }

        .table tbody td {
            padding: 18px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.9rem;
        }

        .code-pill {
            background: #f1f5f9;
            color: #475569;
            font-family: 'Monaco', 'Consolas', monospace;
            font-size: 0.75rem;
            padding: 4px 8px;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
        }

        .specimen-badge {
            background: #eff6ff;
            color: #1d4ed8;
            font-weight: 600;
            font-size: 0.8rem;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .btn-add {
            background-color: var(--primary-blue);
            font-weight: 600;
            padding: 10px 24px;
            border-radius: 10px;
            transition: all 0.3s;
        }

        .btn-action {
            width: 32px;
            height: 32px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            transition: 0.2s;
        }

        .test-name {
            font-weight: 600;
            color: var(--dark-header);
            display: block;
        }

        .range-text {
            color: #059669;
            font-weight: 500;
        }
    </style>
</head>

<body>
    <jsp:include page="adminNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold mb-1">Diagnostic Test Catalog</h2>
                    <p class="text-muted mb-0 small"><i class="bi bi-info-circle me-1"></i> Managing standard laboratory parameters and reference ranges</p>
                </div>
                <a href="testForm.jsp" class="btn btn-primary btn-add text-white shadow-sm">
                    <i class="bi bi-plus-lg me-2"></i>Configure New Test
                </a>
            </div>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4">
                <i class="bi bi-check-circle-fill me-2"></i> <%= message %>
            </div>
        <% } %>

        <div class="content-card">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th>Test Definition</th>
                            <th>LOINC / SNOMED</th>
                            <th>Specimen</th>
                            <th>Normal Range</th>
                            <th>Unit</th>
                            <th>Added On</th>
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
                            String sql = "SELECT * FROM tests ORDER BY test_id DESC";
                            ps = con.prepareStatement(sql);
                            rs = ps.executeQuery();

                            boolean hasData = false;

                            while (rs.next()) {
                                hasData = true;
                    %>
                        <tr>
                            <td class="text-muted small">#<%= rs.getInt("test_id") %></td>
                            <td>
                                <span class="test-name"><%= rs.getString("test_name") %></span>
                            </td>
                            <td>
                                <div class="d-flex flex-column gap-1">
                                    <span class="code-pill">L: <%= rs.getString("loinc_code") %></span>
                                    <span class="code-pill">S: <%= rs.getString("snomed_code") %></span>
                                </div>
                            </td>
                            <td>
                                <span class="specimen-badge"><%= rs.getString("specimen_type") %></span>
                            </td>
                            <td>
                                <span class="range-text"><%= rs.getString("normal_range") %></span>
                            </td>
                            <td>
                                <span class="badge bg-light text-dark border"><%= rs.getString("unit") %></span>
                            </td>
                            <td class="text-muted small">
                                <%= rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString().substring(0, 10) : "N/A" %>
                            </td>
                            <td class="text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="testForm.jsp?editId=<%= rs.getInt("test_id") %>"
                                       class="btn btn-action btn-outline-warning" title="Edit Parameters">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    <a href="manageTests.jsp?deleteId=<%= rs.getInt("test_id") %>"
                                       class="btn btn-action btn-outline-danger"
                                       onclick="return confirm('Deleting this test will affect clinical history. Proceed?')" title="Delete Test">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <%
                            }

                            if (!hasData) {
                    %>
                        <tr>
                            <td colspan="8" class="text-center py-5">
                                <i class="bi bi-clipboard2-x fs-1 d-block mb-3 text-muted"></i>
                                <p class="text-muted">No diagnostic tests currently defined in the system.</p>
                            </td>
                        </tr>
                    <%
                            }

                        } catch (Exception e) {
                    %>
                        <tr>
                            <td colspan="8" class="text-danger text-center py-4">
                                <i class="bi bi-exclamation-octagon me-2"></i> Error loading catalog: <%= e.getMessage() %>
                            </td>
                        </tr>
                    <%
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (ps != null) ps.close(); } catch (Exception e) {}
                            try { if (con != null) con.close(); } catch (Exception e) {}
                        }
                    %>

                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>