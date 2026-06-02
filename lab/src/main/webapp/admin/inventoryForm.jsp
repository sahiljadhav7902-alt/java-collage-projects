<%-- 
    Document   : inventoryForm
    Created on : 18-Feb-2026, 5:39:54 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllInventory" %>
<%@ page import="java.util.List" %>

<%
    String message = "";
    BllInventory bll = new BllInventory();
    BllInventory.InventoryItem item = null;
    boolean isEdit = false;

    // 1. Handle Form Submission (POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("itemId");
        
        String itemName = request.getParameter("itemName");
        int labId = Integer.parseInt(request.getParameter("labId"));
        String lotNumber = request.getParameter("lotNumber");
        String expiryDate = request.getParameter("expiryDate");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (idParam != null && !idParam.isEmpty()) {
            // UPDATE
            int id = Integer.parseInt(idParam);
            message = bll.updateInventory(id, itemName, labId, lotNumber, expiryDate, quantity);
            item = bll.getItemById(id);
            isEdit = true;
        } else {
            // ADD NEW
            message = bll.addInventory(itemName, labId, lotNumber, expiryDate, quantity);
        }
    } else {
        // 2. Load Data for Edit
        if (request.getParameter("editId") != null) {
            isEdit = true;
            try {
                int id = Integer.parseInt(request.getParameter("editId"));
                item = bll.getItemById(id);
            } catch (Exception e) {
                message = "Error loading item.";
            }
        }
    }
    
    // Fetch Labs for Dropdown
    List<BllInventory.LabOption> labs = bll.getAllLabs();
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit Inventory" : "Add Inventory" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">
    <jsp:include page="./adminNavbar.jsp" />

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0"><%= isEdit ? "Edit Inventory Item" : "Add New Stock" %></h4>
                </div>
                <div class="card-body">
                    
                    <% if (!message.isEmpty()) { %>
                        <div class="alert alert-info"><%= message %></div>
                    <% } %>

                    <form action="inventoryForm.jsp" method="POST">
                        <input type="hidden" name="itemId" value="<%= (item != null) ? item.itemId : "" %>">

                        <div class="mb-3">
                            <label class="form-label fw-bold">Item Name</label>
                            <input type="text" name="itemName" class="form-control" 
                                   placeholder="e.g. Reagent Kit A" 
                                   value="<%= (item != null) ? item.itemName : "" %>" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Laboratory</label>
                                <select name="labId" class="form-select" required>
                                    <option value="">Select Lab...</option>
                                    <% for(BllInventory.LabOption lab : labs) { 
                                        boolean selected = (item != null && item.labId == lab.labId);
                                    %>
                                        <option value="<%= lab.labId %>" <%= selected ? "selected" : "" %>>
                                            <%= lab.labName %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Lot Number</label>
                                <input type="text" name="lotNumber" class="form-control font-monospace" 
                                       placeholder="LOT-123" 
                                       value="<%= (item != null) ? item.lotNumber : "" %>" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Quantity</label>
                                <input type="number" name="quantity" class="form-control" 
                                       placeholder="0" 
                                       value="<%= (item != null) ? item.quantity : "" %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Expiry Date</label>
                                <input type="date" name="expiryDate" class="form-control" 
                                       value="<%= (item != null) ? item.expiryDate : "" %>" required>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="manageInventory.jsp" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-warning text-dark">
                                <%= isEdit ? "Update Item" : "Add Item" %>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

</body>
</html>