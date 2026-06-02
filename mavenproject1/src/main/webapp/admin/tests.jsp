<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.pathology.BllTestMaster" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Catalog - Pathology Lab System</title>

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
        <h2 class="mb-0">Test Catalog</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addTestModal">
            <i class="bi bi-plus-lg me-2"></i>Add Test
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

    <!-- Tests Table -->
    <div class="card">
        <div class="card-header">Test List</div>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Test Name</th>
                        <th>LOINC Code</th>
                        <th>SNOMED Code</th>
                        <th>Specimen</th>
                        <th>Range</th>
                        <th>Unit</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        BllTestMaster bllTest = new BllTestMaster();
                        List<BllTestMaster> tests = bllTest.getAllTests();
                        
                        if (tests.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="9" class="text-center text-muted">No tests found</td>
                    </tr>
                    <%
                        } else {
                            for (BllTestMaster test : tests) {
                    %>
                    <tr>
                        <td><%= test.getTestId() %></td>
                        <td><strong><%= test.getTestName() %></strong></td>
                        <td><%= test.getLoincCode() != null ? test.getLoincCode() : "-" %></td>
                        <td><%= test.getSnomedCode() != null ? test.getSnomedCode() : "-" %></td>
                        <td><%= test.getSpecimenType() != null ? test.getSpecimenType() : "-" %></td>
                        <td><%= test.getNormalRange() != null ? test.getNormalRange() : "-" %></td>
                        <td><%= test.getUnit() != null ? test.getUnit() : "-" %></td>
                        <td>
                            <span class="badge <%= test.isActive() ? "badge-active" : "badge-inactive" %>">
                                <%= test.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#editTestModal<%= test.getTestId() %>">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete(<%= test.getTestId() %>, '<%= test.getTestName() %>')">
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

    <!-- Add Test Modal -->
    <div class="modal fade" id="addTestModal" tabindex="-1" aria-labelledby="addTestModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTestModalLabel">Add New Test</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="tests.jsp" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="testName" class="form-label">Test Name *</label>
                            <input type="text" class="form-control" id="testName" name="testName" required>
                        </div>
                        <div class="mb-3">
                            <label for="loincCode" class="form-label">LOINC Code</label>
                            <input type="text" class="form-control" id="loincCode" name="loincCode">
                        </div>
                        <div class="mb-3">
                            <label for="snomedCode" class="form-label">SNOMED Code</label>
                            <input type="text" class="form-control" id="snomedCode" name="snomedCode">
                        </div>
                        <div class="mb-3">
                            <label for="specimenType" class="form-label">Specimen Type</label>
                            <input type="text" class="form-control" id="specimenType" name="specimenType">
                        </div>
                        <div class="mb-3">
                            <label for="normalRange" class="form-label">Normal Range</label>
                            <input type="text" class="form-control" id="normalRange" name="normalRange">
                        </div>
                        <div class="mb-3">
                            <label for="unit" class="form-label">Unit</label>
                            <input type="text" class="form-control" id="unit" name="unit">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Test</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Test Modals (one for each test) -->
    <%
        if (!tests.isEmpty()) {
            for (BllTestMaster test : tests) {
    %>
    <div class="modal fade" id="editTestModal<%= test.getTestId() %>" tabindex="-1" aria-labelledby="editTestModalLabel<%= test.getTestId() %>" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editTestModalLabel<%= test.getTestId() %>">Edit Test</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="tests.jsp" method="post">
                    <input type="hidden" name="testId" value="<%= test.getTestId() %>">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editTestName<%= test.getTestId() %>" class="form-label">Test Name *</label>
                            <input type="text" class="form-control" id="editTestName<%= test.getTestId() %>" name="testName" value="<%= test.getTestName() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="editLoincCode<%= test.getTestId() %>" class="form-label">LOINC Code</label>
                            <input type="text" class="form-control" id="editLoincCode<%= test.getTestId() %>" name="loincCode" value="<%= test.getLoincCode() != null ? test.getLoincCode() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label for="editSnomedCode<%= test.getTestId() %>" class="form-label">SNOMED Code</label>
                            <input type="text" class="form-control" id="editSnomedCode<%= test.getTestId() %>" name="snomedCode" value="<%= test.getSnomedCode() != null ? test.getSnomedCode() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label for="editSpecimenType<%= test.getTestId() %>" class="form-label">Specimen Type</label>
                            <input type="text" class="form-control" id="editSpecimenType<%= test.getTestId() %>" name="specimenType" value="<%= test.getSpecimenType() != null ? test.getSpecimenType() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label for="editNormalRange<%= test.getTestId() %>" class="form-label">Normal Range</label>
                            <input type="text" class="form-control" id="editNormalRange<%= test.getTestId() %>" name="normalRange" value="<%= test.getNormalRange() != null ? test.getNormalRange() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label for="editUnit<%= test.getTestId() %>" class="form-label">Unit</label>
                            <input type="text" class="form-control" id="editUnit<%= test.getTestId() %>" name="unit" value="<%= test.getUnit() != null ? test.getUnit() : "" %>">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Test</button>
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
    function confirmDelete(testId, testName) {
        if (confirm('Are you sure you want to delete test "' + testName + '"?')) {
            window.location.href = 'tests.jsp?action=delete&testId=' + testId;
        }
    }
</script>

<%
    // Handle form submissions
    String action = request.getParameter("action");
    String message = null;
    String messageType = null;
    
    if ("add".equals(action)) {
        String testName = request.getParameter("testName");
        String loincCode = request.getParameter("loincCode");
        String snomedCode = request.getParameter("snomedCode");
        String specimenType = request.getParameter("specimenType");
        String normalRange = request.getParameter("normalRange");
        String unit = request.getParameter("unit");
        
        BllTestMaster bllTest = new BllTestMaster();
        message = bllTest.addTest(testName, loincCode, snomedCode, specimenType, normalRange, unit);
        messageType = message.contains("successfully") ? "success" : "danger";
        
    } else if ("update".equals(action)) {
        int testId = Integer.parseInt(request.getParameter("testId"));
        String testName = request.getParameter("testName");
        String loincCode = request.getParameter("loincCode");
        String snomedCode = request.getParameter("snomedCode");
        String specimenType = request.getParameter("specimenType");
        String normalRange = request.getParameter("normalRange");
        String unit = request.getParameter("unit");
        
        BllTestMaster bllTest = new BllTestMaster();
        message = bllTest.updateTest(testId, testName, loincCode, snomedCode, specimenType, normalRange, unit);
        messageType = message.contains("successfully") ? "success" : "danger";
        
    } else if ("delete".equals(action)) {
        int testId = Integer.parseInt(request.getParameter("testId"));
        
        BllTestMaster bllTest = new BllTestMaster();
        message = bllTest.deleteTest(testId);
        messageType = message.contains("successfully") ? "success" : "danger";
    }
    
    if (message != null) {
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("tests.jsp").forward(request, response);
    }
%>

</body>
</html>