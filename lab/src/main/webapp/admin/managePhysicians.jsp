<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.lab.DataAccess" %>
<%@ page import="com.mycompany.lab.BllPhysician" %>

<%
    // LOGIC PRESERVED EXACTLY
    String message = "";

    if (request.getParameter("deleteId") != null) {
        try {
            int deleteId = Integer.parseInt(request.getParameter("deleteId"));
            BllPhysician bll = new BllPhysician();
            message = bll.deletePhysician(deleteId);
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
    <title>Physician Management | PathLab Admin</title>

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

        .license-badge {
            background-color: #f1f5f9;
            color: #475569;
            font-family: monospace;
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
        }

        .btn-add {
            background-color: var(--primary-blue);
            font-weight: 600;
            padding: 10px 24px;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .btn-add:hover {
            background-color: #044ecb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(5, 97, 252, 0.2);
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
        <h2>Manage Physicians</h2>
        <p class="text-muted mb-0">Oversee healthcare professionals and medical licensing</p>
    </div>
</header>

<div class="container mb-5">

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4 text-center">
            <i class="bi bi-info-circle-fill me-2"></i> <%= message %>
        </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="fw-bold m-0"><i class="bi bi-person-workspace me-2 text-primary"></i>Medical Staff Registry</h5>
        <a href="physicianForm.jsp" class="btn btn-primary btn-add">
            <i class="bi bi-person-plus-fill me-2"></i>Add Physician
        </a>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Contact Email</th>
                        <th>Phone</th>
                        <th>License Number</th>
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
                    String sql = "SELECT user_id, first_name, last_name, email, phone, license_number FROM users WHERE user_type='physician' ORDER BY user_id DESC";
                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    boolean hasData = false;

                    while (rs.next()) {
                        hasData = true;
                %>
                    <tr>
                        <td class="text-muted small">#<%= rs.getInt("user_id") %></td>
                        <td class="fw-600">
                            Dr. <%= rs.getString("first_name") %> <%= rs.getString("last_name") %>
                        </td>
                        <td class="small text-muted"><%= rs.getString("email") %></td>
                        <td class="small"><%= rs.getString("phone") %></td>
                        <td>
                            <span class="license-badge">
                                <%= rs.getString("license_number") != null ? rs.getString("license_number") : "N/A" %>
                            </span>
                        </td>
                        <td class="text-end">
                            <div class="btn-group">
                                <a href="physicianForm.jsp?editId=<%= rs.getInt("user_id") %>" 
                                   class="btn btn-sm btn-outline-warning border-0" title="Edit Physician">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                                <a href="managePhysicians.jsp?deleteId=<%= rs.getInt("user_id") %>"
                                   class="btn btn-sm btn-outline-danger border-0"
                                   onclick="return confirm('Delete this physician? This may affect existing diagnostic orders.')" title="Delete">
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
                        <td colspan="6" class="text-center py-5 text-muted">
                            <i class="bi bi-person-slash fs-1 d-block mb-3"></i>
                            No physicians found in the system.
                        </td>
                    </tr>
                <%
                    }

                } catch (Exception e) {
                %>
                    <tr>
                        <td colspan="6" class="text-danger text-center py-4">
                            <i class="bi bi-exclamation-triangle me-2"></i> Error loading staff data.
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
    <p class="mb-0">&copy; 2026 Pathology Lab System | Professional Staff Portal</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>