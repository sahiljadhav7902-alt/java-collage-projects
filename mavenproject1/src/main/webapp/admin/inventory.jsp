<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.pathology.BllInventory" %>
<%@ page import="com.mycompany.pathology.BllLaboratory" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Management - Pathology Lab System</title>

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

        .badge-expiring {
            background: var(--warning);
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
        <h2 class="mb-0">Inventory Management</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addInventoryModal">
            <i class="bi bi-plus-lg me-2"></i>Add Inventory Item
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

    <!-- Inventory Table -->
    <div class="card">
        <div class="card-header">Inventory List</div>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Item</th>
                        <th>Lot</th>
                        <th>Expiry</th>
                        <th>Qty</th>
                        <th>Lab</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        BllInventory bllInventory = new BllInventory();
                        List<BllInventory> inventoryItems = bllInventory.getAllInventory();
                        
                        if (inventoryItems.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="8" class="text-center text-muted">No inventory items found</td>
                    </tr>
                    <%
                        } else {
                            for (BllInventory item : inventoryItems) {
                                boolean isExpiring = item.getExpiryDate() != null && 
                                    item.getExpiryDate().compareTo(java.time.LocalDate.now().plusDays(30).toString()) <= 0;
                    %>
                    <tr>
                        <td><%= item.getInventoryId() %></td>
                        <td><strong><%= item.getItemName() %></strong></td>
                        <td><%= item.getLotNumber() != null ? item.getLotNumber() : "-" %></td>
                        <td><%= item.getExpiryDate() != null ? item.getExpiryDate() : "-" %></td>
                        <td><%= item.getQuantity() %></td>
                        <td><%= item.getLabName() != null ? item.getLabName() : "-" %></td>
                        <td>
                            <span class="badge <%= isExpiring ? "badge-expiring" : (item.isActive() ? "badge-active" : "badge-inactive") %>">
                                <%= isExpiring ? "Expiring Soon" : (item.isActive() ? "Active" : "Inactive") %>
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#editInventoryModal<%= item.getInventoryId() %>">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="confirmDelete(<%= item.getInventoryId() %>, '<%= item.getItemName() %>')">
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

    <!-- Add Inventory Modal -->
    <div class="modal fade" id="addInventoryModal" tabindex="-1" aria-labelledby="addInventoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addInventoryModalLabel">Add New Inventory Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="inventory.jsp" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="itemName" class="form-label">Item Name *</label>
                            <input type="text" class="form-control" id="itemName" name="itemName" required>
                        </div>
                        <div class="mb-3">
                            <label for="lotNumber" class="form-label">Lot Number</label>
                            <input type="text" class="form-control" id="lotNumber" name="lotNumber">
                        </div>
                        <div class="mb-3">
                            <label for="expiryDate" class="form-label">Expiry Date</label>
                            <input type="date" class="form-control" id="expiryDate" name="expiryDate">
                        </div>
                        <div class="mb-3">
                            <label for="quantity" class="form-label">Quantity *</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" required min="0">
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
                        <button type="submit" class="btn btn-primary">Add Item</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Inventory Modals (one for each item) -->
    <%
        if (!inventoryItems.isEmpty()) {
            for (BllInventory item : inventoryItems) {
    %>
    <div class="modal fade" id="editInventoryModal<%= item.getInventoryId() %>" tabindex="-1" aria-labelledby="editInventoryModalLabel<%= item.getInventoryId() %>" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editInventoryModalLabel<%= item.getInventoryId() %>">Edit Inventory Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="inventory.jsp" method="post">
                    <input type="hidden" name="inventoryId" value="<%= item.getInventoryId() %>">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editItemName<%= item.getInventoryId() %>" class="form-label">Item Name *</label>
                            <input type="text" class="form-control" id="editItemName<%= item.getInventoryId() %>" name="itemName" value="<%= item.getItemName() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="editLotNumber<%= item.getInventoryId() %>" class="form-label">Lot Number</label>
                            <input type="text" class="form-control" id="editLotNumber<%= item.getInventoryId() %>" name="lotNumber" value="<%= item.getLotNumber() != null ? item.getLotNumber() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label for="editExpiryDate<%= item.getInventoryId() %>" class="form-label">Expiry Date</label>
                            <input type="date" class="form-control" id="editExpiryDate<%= item.getInventoryId() %>" name="expiryDate" value="<%= item.getExpiryDate() != null ? item.getExpiryDate() : "" %>">
                        </div>
                        <div class="mb-3">
                            <label for="editQuantity<%= item.getInventoryId() %>" class="form-label">Quantity *</label>
                            <input type="number" class="form-control" id="editQuantity<%= item.getInventoryId() %>" name="quantity" value="<%= item.getQuantity() %>" required min="0">
                        </div>
                        <div class="mb-3">
                            <label for="editLab<%= item.getInventoryId() %>" class="form-label">Lab *</label>
                            <select class="form-control" id="editLab<%= item.getInventoryId() %>" name="lab" required>
                                <%
                                    List<BllLaboratory> labs = bllLab.getAllLaboratories();
                                    for (BllLaboratory lab : labs) {
                                %>
                                <option value="<%= lab.getLabId() %>" <%= lab.getLabId() == item.getLabId() ? "selected" : "" %>><%= lab.getLabName() %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Item</button>
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
    function confirmDelete(inventoryId, itemName) {
        if (confirm('Are you sure you want to delete inventory item "' + itemName + '"?')) {
            window.location.href = 'inventory.jsp?action=delete&inventoryId=' + inventoryId;
        }
    }
</script>

<%
    // Handle form submissions
    String action = request.getParameter("action");
    String message = null;
    String messageType = null;
    
    if ("add".equals(action)) {
        String itemName = request.getParameter("itemName");
        String lotNumber = request.getParameter("lotNumber");
        String expiryDate = request.getParameter("expiryDate");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int labId = Integer.parseInt(request.getParameter("lab"));
        
        BllInventory bllInventory = new BllInventory();
        message = bllInventory.addInventory(itemName, lotNumber, expiryDate, quantity, labId);
        messageType = message.contains("successfully") ? "success" : "danger";
        
    } else if ("update".equals(action)) {
        int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
        String itemName = request.getParameter("itemName");
        String lotNumber = request.getParameter("lotNumber");
        String expiryDate = request.getParameter("expiryDate");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int labId = Integer.parseInt(request.getParameter("lab"));
        
        BllInventory bllInventory = new BllInventory();
        message = bllInventory.updateInventory(inventoryId, itemName, lotNumber, expiryDate, quantity, labId);
        messageType = message.contains("successfully") ? "success" : "danger";
        
    } else if ("delete".equals(action)) {
        int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
        
        BllInventory bllInventory = new BllInventory();
        message = bllInventory.deleteInventory(inventoryId);
        messageType = message.contains("successfully") ? "success" : "danger";
    }
    
    if (message != null) {
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("inventory.jsp").forward(request, response);
    }
%>

</body>
</html>