<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.pathology.BllTechnician" %>
<%@ page import="com.mycompany.pathology.BllLaboratory" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technician Management - Pathology Lab System</title>

    <!-- Bootstrap 5 CDN -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #2D3748;
            --primary-light: #4A5568;
            --secondary: #4299E1;
            --bg-light: #F7FAFC;
            --white: #FFFFFF;
            --text-dark: #2D3748;
            --text-muted: #718096;
            --border-light: #E2E8F0;
            --success: #48BB78;
            --warning: #ED8936;
            --danger: #F56565;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .header {
            background: var(--white);
            padding: 2rem 0;
            border-bottom: 1px solid var(--border-light);
        }

        .header-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--primary);
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .card {
            background: var(--white);
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border: 1px solid var(--border-light);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .card-header {
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--border-light);
            font-size: 1.1rem;
        }

        .btn-primary {
            background: var(--secondary);
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
            font-weight: 500;
            font-size: 0.95rem;
        }

        .btn-primary:hover {
            background: #3182CE;
        }

        .btn-outline-primary {
            border-radius: 6px;
            border: 1px solid var(--secondary);
            color: var(--secondary);
            font-weight: 500;
            font-size: 0.95rem;
        }

        .btn-outline-primary:hover {
            background: var(--secondary);
            color: var(--white);
        }

        .btn-danger {
            background: var(--danger);
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 0.9rem;
        }

        .btn-danger:hover {
            background: #E53E3E;
        }

        .table th {
            font-weight: 600;
            color: var(--primary);
            border-bottom: 2px solid var(--border-light);
        }

        .table td {
            vertical-align: middle;
            color: var(--text-muted);
        }

        .badge-active {
            background: var(--success);
            color: var(--white);
        }

        .badge-inactive {
            background: var(--danger);
            color: var(--white);
        }

        .form-label {
            font-weight: 500;
            color: var(--primary);
            font-size: 0.95rem;
        }

        .form-control {
            border: 1px solid var(--border-light);
            border-radius: 6px;
        }

        .footer {
            background: var(--white);
            border-top: 1px solid var(--border-light);
            padding: 2rem 0;
            margin-top: 3rem;
        }

        .footer-title {
            font-weight: 600;
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }

        .footer-link {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.95rem;
        }

        .footer-link:hover {
            color: var(--secondary);
        }

        .social-icons {
            font-size: 1.1rem;
            margin-right: 1rem;
            color: var(--text-muted);
        }

        .social-icons:hover {
            color: var(--secondary);
        }
    </style>
</head>

<body>

<!-- Header -->
<header class="header">
    <div class="container">
        <h1 class="header-title">Pathology Lab System</h1>
    </div>
</header>

<!-- Main Content -->
<div class="main-container">
    
    <!-- Page Title and Actions -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Technician Management</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addTechnicianModal">
            <i class="bi bi-plus-lg me-2"></i>Add Technician
        </button>
    </div>

    <!-- Success/Error Messages -->
    <%
        String message = (String) request.getAttribute("message");
        String messageType = (String) request.getAttribute("messageType");
        if (message != null) {
    %>
    <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
        <%= message %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <%
        }
    %>

    <!-- Technicians Table -->
    <div class="card">
        <div class="card-header">Technician List</div>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Certification</th>
                        <th>Lab</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        BllTechnician bllTechnician = new BllTechnician();
                        List<BllTechnician> technicians = bllTechnician.getAllTechnicians();
                        
                        if (technicians.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No technicians found</td>
                    </tr>
                    <%
                        } else {
                            for (BllTechnician technician : technicians) {
                    %>
                    <tr>
                        <td><%= technician.getTechnicianId() %></td>
                        <td><strong><%= technician.getFirstName() %> <%= technician.getLastName() %></strong></td>
                        <td><%= technician.getCertification() != null ? technician.getCertification() : "-" %></td>
                        <td><%= technician.getLabName() != null ? technician.getLabName() : "-" %></td>
                        <td>
                            <span class="badge <%= technician.isActive() ? "badge-active" : "badge-inactive" %>">
                                <%= technician.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#editTechnicianModal<%= technician.getTechnicianId() %>">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete(<%= technician.getTechnicianId() %>, '<%= technician.getFirstName() %> <%= technician.getLastName() %>')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Technician Modal -->
    <div class="modal fade" id="addTechnicianModal" tabindex="-1" aria-labelledby="addTechnicianModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTechnicianModalLabel">Add New Technician</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="technicians.jsp" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="firstName" class="form-label">First Name *</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" required>
                        </div>
                        <div class="mb-3">
                            <label for="lastName" class="form-label">Last Name *</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" required>
                        </div>
                        <div class="mb-3">
                            <label for="certification" class="form-label">Certification</label>
                            <input type="text" class="form-control" id="certification" name="certification">
                        </div>
                        <div class="mb-3">
                            <label for="lab" class="form-label">Lab *</label>
                            <select class="form-control" id="lab" name="lab" required>
                                <option value="">Select Laboratory</option>
                                <%
                                    BllLaboratory bllLab = new BllLaboratory();
                                    List<BllLaboratory> laboratories = bllLab.getAllLaboratories();
                                    for (BllLaboratory lab : laboratories) {
                                %>
                                <option value="<%= lab.getLabId() %>"><%= lab.getLabName() %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Technician</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Technician Modals (one for each technician) -->
    <%
        if (!technicians.isEmpty()) {
            for (BllTechnician technician : technicians) {
    %>
    <div class="modal fade" id="editTechnicianModal<%= technician.getTechnicianId() %>" tabindex="-1" aria-labelledby="editTechnicianModalLabel<%= technician.getTechnicianId() %>" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editTechnicianModalLabel<%= technician.getTechnicianId() %>">Edit Technician</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="technicians.jsp" method="post">
                    <input type="hidden" name="technicianId" value="<%= technician.getTechnicianId() %>">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editFirstName<%= technician.getTechnicianId() %>" class="form-label">First Name *</label>
                            <input type="text" class="form-control" id="editFirstName<%= technician.getTechnicianId() %>" name="firstName" value="<%= technician.getFirstName() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="editLastName<%= technician.getTechnicianId() %>" class="form-label">Last Name *</label>
                            <input type="text" class="form-control" id="editLastName<%= technician.getTechnicianId() %>" name="lastName" value="<%= technician.getLastName() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="editCertification<%= technician.getTechnicianId() %>" class="form-label">Certification</label>
                            <input type="text" class="form-control" id="editCertification<%= technician.getTechnicianId() %>" name="certification" value="<%= technician.getCertification() != null ? technician.getCertification() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label for="editLab<%= technician.getTechnicianId() %>" class="form-label">Lab *</label>
                            <select class="form-control" id="editLab<%= technician.getTechnicianId() %>" name="lab" required>
                                <%
                                    List<BllLaboratory> labs = bllLab.getAllLaboratories();
                                    for (BllLaboratory lab : labs) {
                                %>
                                <option value="<%= lab.getLabId() %>" <%= lab.getLabId() == technician.getLabId() ? "selected" : "" %>><%= lab.getLabName() %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Technician</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%
            }
        }
    %>

</div>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h4 class="footer-title">Pathology Lab System</h4>
                <p class="text-muted" style="font-size: 0.95rem;">Advanced Laboratory Management and Diagnostic Solutions</p>
                <div class="mt-3">
                    <i class="bi bi-telephone social-icons"></i>
                    <i class="bi bi-envelope social-icons"></i>
                    <i class="bi bi-globe social-icons"></i>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <h4 class="footer-title">Quick Links</h4>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="login.jsp" class="footer-link">Login</a></li>
                    <li class="mb-2"><a href="patient/register.jsp" class="footer-link">Register</a></li>
                    <li class="mb-2"><a href="admin/dashboard.jsp" class="footer-link">Admin Panel</a></li>
                    <li class="mb-2"><a href="#" class="footer-link">Contact Us</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-4">
                <h4 class="footer-title">Follow Us</h4>
                <div class="mt-3">
                    <i class="bi bi-facebook social-icons"></i>
                    <i class="bi bi-twitter social-icons"></i>
                    <i class="bi bi-linkedin social-icons"></i>
                    <i class="bi bi-instagram social-icons"></i>
                </div>
            </div>
        </div>
        <div class="text-center mt-4 pt-4 border-top border-secondary">
            <p class="mb-0" style="font-size: 0.95rem;">&copy; 2024 Pathology Lab System. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function confirmDelete(technicianId, technicianName) {
        if (confirm('Are you sure you want to delete technician "' + technicianName + '"?')) {
            window.location.href = 'technicians.jsp?action=delete&technicianId=' + technicianId;
        }
    }
</script>

<%
    // Handle form submissions
    String action = request.getParameter("action");
    String message = null;
    String messageType = null;
    
    if ("add".equals(action)) {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String certification = request.getParameter("certification");
        int labId = Integer.parseInt(request.getParameter("lab"));
        
        BllTechnician bllTechnician = new BllTechnician();
        message = bllTechnician.addTechnician(firstName, lastName, certification, labId);
        messageType = message.contains("successfully") ? "success" : "danger";
        
    } else if ("update".equals(action)) {
        int technicianId = Integer.parseInt(request.getParameter("technicianId"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String certification = request.getParameter("certification");
        int labId = Integer.parseInt(request.getParameter("lab"));
        
        BllTechnician bllTechnician = new BllTechnician();
        message = bllTechnician.updateTechnician(technicianId, firstName, lastName, certification, labId);
        messageType = message.contains("successfully") ? "success" : "danger";
        
    } else if ("delete".equals(action)) {
        int technicianId = Integer.parseInt(request.getParameter("technicianId"));
        
        BllTechnician bllTechnician = new BllTechnician();
        message = bllTechnician.deleteTechnician(technicianId);
        messageType = message.contains("successfully") ? "success" : "danger";
    }
    
    if (message != null) {
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("technicians.jsp").forward(request, response);
    }
%>

</body>
</html>