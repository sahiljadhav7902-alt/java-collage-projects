<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.lab.DataAccess" %>
<%@ page import="com.mycompany.lab.BllPatient" %>

<%
    // LOGIC PRESERVED EXACTLY
    String message = "";

    if (request.getParameter("deleteId") != null) {
        try {
            int deleteId = Integer.parseInt(request.getParameter("deleteId"));
            BllPatient bll = new BllPatient();
            message = bll.deletePatient(deleteId);
        } catch (NumberFormatException e) {
            message = "Invalid ID.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management | PathLab Admin</title>

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

        .mrn-badge {
            background-color: #e2e8f0;
            color: #475569;
            font-family: monospace;
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 6px;
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
        <h2>Manage Patients</h2>
        <p class="text-muted mb-0">Centralized database for all registered laboratory patients</p>
    </div>
</header>

<div class="container mb-5">

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4 text-center">
            <i class="bi bi-info-circle-fill me-2"></i> <%= message %>
        </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="fw-bold m-0"><i class="bi bi-people-fill me-2"></i>Patient Registry</h5>
        <a href="patientForm.jsp" class="btn btn-primary btn-add">
            <i class="bi bi-person-plus-fill me-2"></i>Add New Patient
        </a>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>MRN</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>DOB</th>
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
                    String sql = "SELECT user_id, mrn, first_name, last_name, email, phone, date_of_birth FROM users WHERE user_type='patient' ORDER BY created_at DESC";
                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    boolean hasData = false;

                    while (rs.next()) {
                        hasData = true;
                %>
                    <tr>
                        <td class="text-muted small">#<%= rs.getInt("user_id") %></td>
                        <td>
                            <span class="mrn-badge">
                                <%= rs.getString("mrn") %>
                            </span>
                        </td>
                        <td class="fw-600 text-dark">
                            <%= rs.getString("first_name") %> <%= rs.getString("last_name") %>
                        </td>
                        <td class="small"><%= rs.getString("email") %></td>
                        <td class="small"><%= rs.getString("phone") %></td>
                        <td class="text-muted small"><%= rs.getString("date_of_birth") %></td>
                        <td class="text-end">
                            <div class="btn-group">
                                <a href="patientForm.jsp?editId=<%= rs.getInt("user_id") %>" 
                                   class="btn btn-sm btn-outline-warning border-0">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                                <a href="managePatients.jsp?deleteId=<%= rs.getInt("user_id") %>"
                                   class="btn btn-sm btn-outline-danger border-0"
                                   onclick="return confirm('Are you sure you want to delete this patient? This may affect their order history.')">
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
                        <td colspan="7" class="text-center py-5 text-muted">
                            <i class="bi bi-person-x fs-1 d-block mb-3"></i>
                            No patients found in the database.
                        </td>
                    </tr>
                <%
                    }

                } catch (Exception e) {
                %>
                    <tr>
                        <td colspan="7" class="text-danger text-center py-4">
                            <i class="bi bi-exclamation-octagon me-2"></i> Error loading patient data: <%= e.getMessage() %>
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
    <p class="mb-0">&copy; 2026 Pathology Lab System | Patient Management Module</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>