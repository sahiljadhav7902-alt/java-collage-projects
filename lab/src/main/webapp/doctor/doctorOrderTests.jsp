<%-- 
    Document   : doctorOrderTests
    Created on : 18-Feb-2026, 9:45:12 pm
    Author     : sahil jadhav
--%>
<%@ page import="com.mycompany.lab.BllOrder" %>
<%@ page import="com.mycompany.lab.BllTestCatalog" %>
<%@ page import="com.mycompany.lab.DataAccess" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>

<%
    // --- START LOGIC PRESERVED ---
    String orderIdParam = request.getParameter("orderId");
    int orderId = 0;

    if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            orderId = 0;
        }
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        BllOrder bll = new BllOrder();
        String[] selectedTestIds = request.getParameterValues("testIds");
        message = bll.updateOrderTests(orderId, selectedTestIds);
        
        if (message.startsWith("Tests updated")) {
            response.sendRedirect("doctorMyOrders.jsp?msg=" + java.net.URLEncoder.encode("Order created successfully.", "UTF-8"));
            return;
        }
    }

    BllOrder bllOrder = new BllOrder();
    List<Integer> selectedIds = bllOrder.getTestIdsForOrder(orderId);
    List<BllTestCatalog> testList = new ArrayList<>();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = DataAccess.getConnection();
        String sql = "SELECT test_id, test_name, specimen_type, unit, normal_range FROM tests ORDER BY test_name ASC";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        while(rs.next()){
            BllTestCatalog t = new BllTestCatalog();
            t.testId = rs.getInt("test_id");
            t.testName = rs.getString("test_name");
            t.specimenType = rs.getString("specimen_type");
            t.unit = rs.getString("unit");
            t.normalRange = rs.getString("normal_range");
            testList.add(t);
        }
    } catch(Exception e) { 
        e.printStackTrace(); 
        message = "Error loading tests: " + e.getMessage();
    } finally { 
        try{if(rs!=null)rs.close();if(ps!=null)ps.close();if(con!=null)con.close();}catch(Exception e){} 
    }
    // --- END LOGIC PRESERVED ---
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Tests | Lab Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --doctor-green: #059669;
            --slate-bg: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--slate-bg);
            color: #334155;
        }

        .page-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 25px 0;
            margin-bottom: 30px;
        }

        .content-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            overflow: hidden;
        }

        .step-pill {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .step-active { background: var(--doctor-green); color: white; }
        .step-line { width: 40px; height: 2px; background: #e2e8f0; margin: 0 10px; }
        .step-complete { background: #dcfce7; color: #166534; }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            padding: 15px 20px;
        }

        .table tbody td { padding: 15px 20px; }

        .test-row:hover { background-color: #f0fdf4 !important; }

        .form-check-input:checked {
            background-color: var(--doctor-green);
            border-color: var(--doctor-green);
        }

        .sticky-action-bar {
            position: sticky;
            bottom: 0;
            background: white;
            padding: 1.5rem 2rem;
            border-top: 1px solid #e2e8f0;
            box-shadow: 0 -5px 15px rgba(0,0,0,0.02);
            z-index: 100;
        }

        .specimen-badge {
            font-size: 0.7rem;
            padding: 4px 8px;
            border-radius: 6px;
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
    </style>

    <script>
        function toggleSelectAll(source) {
            const checkboxes = document.getElementsByName('testIds');
            for(let i=0; i < checkboxes.length; i++) {
                checkboxes[i].checked = source.checked;
            }
        }
    </script>
</head>
<body>

    <jsp:include page="doctorNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5 d-flex justify-content-between align-items-center">
            <div>
                <h2 class="fw-bold m-0 text-dark">Select Laboratory Tests</h2>
                <p class="text-muted small mb-0">Order Requisition #<%= orderId %></p>
            </div>
            <div class="d-flex align-items-center">
                <div class="step-pill step-complete"><i class="bi bi-check-lg"></i> Info</div>
                <div class="step-line"></div>
                <div class="step-pill step-active">Step 2: Tests</div>
            </div>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">
        
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-warning border-0 shadow-sm rounded-3 mb-4">
                <i class="bi bi-info-circle-fill me-2"></i> <%= message %>
            </div>
        <% } %>

        <div class="content-card shadow-sm">
            <form action="doctorOrderTests.jsp?orderId=<%= orderId %>" method="POST">
                
                <div class="p-3 bg-white border-bottom d-flex justify-content-between align-items-center px-4">
                    <h5 class="fw-bold m-0 text-dark">Available Test Catalog</h5>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="selectAll" onclick="toggleSelectAll(this)">
                        <label class="form-check-label fw-semibold ms-2" for="selectAll">Select All Tests</label>
                    </div>
                </div>

                <div class="table-responsive" style="max-height: 60vh; overflow-y: auto;">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="sticky-top">
                            <tr>
                                <th class="text-center" style="width: 80px;">Order</th>
                                <th>Test Name / Description</th>
                                <th>Specimen Type</th>
                                <th>Unit</th>
                                <th>Reference Range</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (testList.isEmpty()) { %>
                                <tr><td colspan="5" class="text-center py-5 text-muted">No tests available in the catalog.</td></tr>
                            <% } else { 
                                for(BllTestCatalog test : testList) {
                                    boolean isSelected = selectedIds.contains(test.testId);
                            %>
                            <tr class="test-row">
                                <td class="text-center">
                                    <input class="form-check-input" type="checkbox" name="testIds" 
                                           value="<%= test.testId %>" <%= isSelected ? "checked" : "" %> style="width: 1.25rem; height: 1.25rem;">
                                </td>
                                <td>
                                    <div class="fw-bold text-dark"><%= test.testName %></div>
                                    <div class="small text-muted">Clinical Pathology</div>
                                </td>
                                <td><span class="specimen-badge"><i class="bi bi-droplet-fill me-1 text-danger"></i><%= test.specimenType %></span></td>
                                <td><code class="text-primary fw-medium"><%= test.unit %></code></td>
                                <td><small class="text-secondary"><%= test.normalRange %></small></td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>

                <div class="sticky-action-bar d-flex justify-content-between align-items-center">
                    <a href="doctorMyOrders.jsp" class="btn btn-link text-decoration-none text-muted fw-semibold">
                        <i class="bi bi-chevron-left"></i> Save as Draft
                    </a>
                    <div class="d-flex gap-3">
                        <a href="doctorDashboard.jsp" class="btn btn-outline-secondary rounded-pill px-4">Discard</a>
                        <button type="submit" class="btn btn-success px-5 rounded-pill fw-bold shadow-sm" style="background-color: var(--doctor-green);">
                            Finalize Requisition <i class="bi bi-send-fill ms-2"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>