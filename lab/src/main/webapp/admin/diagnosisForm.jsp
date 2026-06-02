<%-- 
    Document   : diagnosisForm
    Created on : 18-Feb-2026, 4:57:21 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllDiagnosis" %>

<%
    String message = "";
    BllDiagnosis bll = new BllDiagnosis();
    
    // 1. Handle Form Submission (POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("diagnosisId");
        String icd10Code = request.getParameter("icd10Code");
        String description = request.getParameter("description");

        if (idParam != null && !idParam.isEmpty()) {
            // UPDATE EXISTING
            int id = Integer.parseInt(idParam);
            message = bll.updateDiagnosis(id, icd10Code, description);
        } else {
            // ADD NEW
            message = bll.addDiagnosis(icd10Code, description);
        }
    }

    // 2. Check if we are Editing
    BllDiagnosis diagnosis = null;
    boolean isEdit = false;
    
    if (request.getParameter("editId") != null) {
        isEdit = true;
        try {
            int editId = Integer.parseInt(request.getParameter("editId"));
            diagnosis = bll.getDiagnosisById(editId);
        } catch (Exception e) {
            message = "Error loading diagnosis data.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit Diagnosis" : "Add Diagnosis" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons for visual flair -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="container mt-5">
    <jsp:include page="./adminNavbar.jsp" />

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><%= isEdit ? "Edit Diagnosis" : "Add New Diagnosis" %></h4>
                </div>
                <div class="card-body">
                    
                    <% if (!message.isEmpty()) { %>
                        <div class="alert alert-info"><%= message %></div>
                    <% } %>

                    <form action="diagnosisForm.jsp" method="POST">
                        <!-- Hidden ID Field -->
                        <input type="hidden" name="diagnosisId" value="<%= (diagnosis != null) ? diagnosis.diagnosisId : "" %>">

                        <div class="mb-3">
                            <label for="icd10Code" class="form-label fw-bold">ICD-10 Code</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-hash"></i></span>
                                <input type="text" class="form-control text-uppercase" id="icd10Code" name="icd10Code" 
                                       placeholder="e.g. E11.9"
                                       value="<%= (diagnosis != null) ? diagnosis.icd10Code : "" %>" 
                                       style="max-width: 200px;" required>
                            </div>
                            <div class="form-text">Enter the standard ICD-10 code (e.g., J01, I10).</div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required><%= (diagnosis != null) ? diagnosis.description : "" %></textarea>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="manageDiagnoses.jsp" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-lg"></i> <%= isEdit ? "Update Diagnosis" : "Save Diagnosis" %>
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

</body>
</html>