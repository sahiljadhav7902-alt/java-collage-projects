<%@ page import="com.mycompany.lab.BllTestCatalog" %>

<%
    // LOGIC PRESERVED 100%
    String message = "";
    BllTestCatalog bll = new BllTestCatalog();
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("testId");
        String testName = request.getParameter("testName");
        String loincCode = request.getParameter("loincCode");
        String snomedCode = request.getParameter("snomedCode");
        String specimenType = request.getParameter("specimenType");
        String normalRange = request.getParameter("normalRange");
        String unit = request.getParameter("unit");

        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            message = bll.updateTest(id, testName, loincCode, snomedCode, specimenType, normalRange, unit);
        } else {
            message = bll.addTest(testName, loincCode, snomedCode, specimenType, normalRange, unit);
        }
    }

    BllTestCatalog test = null;
    boolean isEdit = false;
    
    if (request.getParameter("editId") != null) {
        isEdit = true;
        try {
            int editId = Integer.parseInt(request.getParameter("editId"));
            test = bll.getTestById(editId);
        } catch (Exception e) {
            message = "Error loading test data.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit" : "New" %> Test Parameter | PathLab</title>
    
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
        }

        .horizontal-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            padding: 35px;
            margin-bottom: 25px;
        }

        .section-header {
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 12px;
            margin-bottom: 25px;
            font-weight: 700;
            color: var(--dark-header);
            display: flex;
            align-items: center;
        }

        .form-label {
            font-weight: 600;
            color: #64748b;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 10px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #cbd5e1;
            background-color: #fcfdfe;
        }

        .form-control:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(5, 97, 252, 0.1);
        }

        .btn-save {
            background-color: var(--primary-blue);
            padding: 12px 40px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <div class="container-fluid px-5 py-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark m-0"><%= isEdit ? "Modify Test Parameter" : "New Catalog Entry" %></h2>
                <p class="text-muted small mb-0">Define clinical reference ranges and diagnostic coding</p>
            </div>
            <a href="manageTests.jsp" class="btn btn-outline-secondary px-4">
                <i class="bi bi-x-lg me-2"></i>Close
            </a>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info border-0 shadow-sm rounded-3"><%= message %></div>
        <% } %>

        <form action="testForm.jsp" method="POST">
            <input type="hidden" name="testId" value="<%= (test != null) ? test.testId : "" %>">

            <div class="horizontal-card">
                <div class="section-header">
                    <i class="bi bi-microscope me-2 text-primary"></i> Test Identification
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Formal Name</label>
                    <div class="col-sm-8">
                        <input type="text" name="testName" class="form-control" 
                               placeholder="e.g. Hemoglobin A1c"
                               value="<%= (test != null) ? test.testName : "" %>" required>
                    </div>
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Coding Standards</label>
                    <div class="col-sm-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted small">LOINC</span>
                            <input type="text" name="loincCode" class="form-control" placeholder="e.g. 4548-4"
                                   value="<%= (test != null) ? test.loincCode : "" %>">
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted small">SNOMED</span>
                            <input type="text" name="snomedCode" class="form-control" placeholder="e.g. 123456"
                                   value="<%= (test != null) ? test.snomedCode : "" %>">
                        </div>
                    </div>
                </div>
            </div>

            <div class="horizontal-card">
                <div class="section-header">
                    <i class="bi bi-activity me-2 text-primary"></i> Clinical Specifications
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Specimen Logic</label>
                    <div class="col-sm-8">
                        <select name="specimenType" class="form-select">
                            <option value="">Choose primary specimen...</option>
                            <% 
                                String[] types = {"Blood", "Urine", "Serum", "Plasma", "Swab", "Tissue", "Other"};
                                for(String t : types) {
                                    String selected = (test != null && t.equals(test.specimenType)) ? "selected" : "";
                            %>
                                <option value="<%=t%>" <%=selected%>><%=t%></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="row mb-0">
                    <label class="col-sm-2 form-label text-sm-end">Reference Range</label>
                    <div class="col-sm-4">
                        <input type="text" name="normalRange" class="form-control" placeholder="Range (e.g. 70 - 100)"
                               value="<%= (test != null) ? test.normalRange : "" %>">
                    </div>
                    <div class="col-sm-4">
                        <input type="text" name="unit" class="form-control" placeholder="Unit (e.g. mg/dL)"
                               value="<%= (test != null) ? test.unit : "" %>">
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-3 mb-5">
                <a href="manageTests.jsp" class="btn btn-light px-5 border">Cancel</a>
                <button type="submit" class="btn btn-primary btn-save text-white shadow-sm">
                    <i class="bi bi-save2 me-2"></i> <%= isEdit ? "Update Catalog Entry" : "Save to Catalog" %>
                </button>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>