<%-- 
    Document   : manageInventory
    Created on : 18-Feb-2026, 5:39:31 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllInventory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    // LOGIC PRESERVED
    BllInventory bll = new BllInventory();
    List<BllInventory.InventoryItem> items = bll.getAllInventory();
    
    String message = request.getParameter("message");
    
    // Current date for expiry comparison
    String todayStr = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Control | Lab Portal</title>
    
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

        .item-name {
            font-weight: 600;
            color: var(--dark-header);
        }

        .lot-tag {
            background: #f1f5f9;
            font-family: monospace;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.85rem;
            color: #475569;
        }

        /* Logic Styles */
        .qty-critical { color: #dc2626 !important; font-weight: 700; }
        .qty-warning { color: #d97706 !important; font-weight: 700; }
        .expiry-expired { color: #dc2626 !important; font-weight: 700; }

        .status-pill {
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.7rem;
            text-transform: uppercase;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold m-0">Inventory Control</h2>
                    <p class="text-muted small mb-0">Monitor stock levels and track expiration dates for reagents.</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="inventoryForm.jsp" class="btn btn-primary btn-sm px-3">
                        <i class="bi bi-plus-lg me-1"></i> Add Stock Item
                    </a>
                </div>
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
                            <th class="ps-4">ID</th>
                            <th>Resource Name</th>
                            <th>Laboratory</th>
                            <th>Lot Number</th>
                            <th>In Stock</th>
                            <th>Expiration</th>
                            <th class="text-end pe-4">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (items == null || items.isEmpty()) { %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-box-seam fs-1 d-block mb-2"></i>
                                    No inventory records available.
                                </td>
                            </tr>
                        <% } else { 
                            for(BllInventory.InventoryItem i : items) {
                                
                                // Visual Alert Logic
                                String qtyClass = "";
                                String qtyBadge = "";
                                if (i.quantity <= 0) {
                                    qtyClass = "qty-critical";
                                    qtyBadge = "Out of Stock";
                                } else if (i.quantity < 10) {
                                    qtyClass = "qty-warning";
                                    qtyBadge = "Low Stock";
                                }

                                String dateClass = "";
                                if (i.expiryDate != null && i.expiryDate.compareTo(todayStr) < 0) {
                                    dateClass = "expiry-expired";
                                }
                        %>
                        <tr>
                            <td class="ps-4 text-muted small">#<%= i.itemId %></td>
                            <td class="item-name"><%= i.itemName %></td>
                            <td>
                                <span class="badge bg-light text-dark fw-normal border"><%= i.labName %></span>
                            </td>
                            <td><span class="lot-tag"><%= i.lotNumber %></span></td>
                            <td class="<%= qtyClass %>">
                                <%= i.quantity %>
                                <% if (!qtyBadge.isEmpty()) { %>
                                    <span class="badge status-pill bg-danger-subtle text-danger ms-1"><%= qtyBadge %></span>
                                <% } %>
                            </td>
                            <td class="<%= dateClass %>">
                                <i class="bi bi-calendar3 me-1"></i><%= i.expiryDate %>
                            </td>
                            <td class="text-end pe-4">
                                <div class="btn-group">
                                    <a href="inventoryForm.jsp?editId=<%= i.itemId %>" class="btn btn-sm btn-light border px-3">
                                        <i class="bi bi-pencil me-1"></i> Edit
                                    </a>
                                    <a href="manageInventory.jsp?deleteId=<%= i.itemId %>" 
                                       class="btn btn-sm btn-outline-danger px-3"
                                       onclick="return confirm('Remove <%= i.itemName %> from inventory?')">
                                        <i class="bi bi-trash"></i>
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

    <% if(request.getParameter("deleteId") != null) { %>
        <%
            try {
                int id = Integer.parseInt(request.getParameter("deleteId"));
                String deleteMsg = bll.deleteInventory(id);
        %>
            <script>
                window.location.href = "manageInventory.jsp?message=" + encodeURIComponent("<%= deleteMsg %>");
            </script>
        <%
            } catch(Exception e) {}
        %>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>