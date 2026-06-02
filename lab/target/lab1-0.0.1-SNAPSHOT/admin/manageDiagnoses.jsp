<%-- 
    Document   : manageDiagnoses
    Created on : 18-Feb-2026, 4:57:02 pm
    Author     : sahil jadhav
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.lab.DataAccess" %>
<%@ page import="com.mycompany.lab.BllDiagnosis" %>

<%
    String message = "";

    // ? DELETE LOGIC
    if (request.getParameter("deleteId") != null) {
        try {
            int deleteId = Integer.parseInt(request.getParameter("deleteId"));
            BllDiagnosis bll = new BllDiagnosis();
            message = bll.deleteDiagnosis(deleteId);
        } catch (NumberFormatException e) {
            message = "Invalid ID.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Diagnoses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-2">
    
    <jsp:include page="./adminNavbar.jsp" />

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Diagnosis Master (ICD-10)</h2>
        <a href="diagnosisForm.jsp" class="btn btn-primary">Add Diagnosis</a>
    </div>

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th width="10%">ID</th>
                    <th width="15%">ICD-10 Code</th>
                    <th width="60%">Description</th>
                    <th width="15%" class="text-center">Action</th>
                </tr>
            </thead>
            <tbody>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DataAccess.getConnection();
        String sql = "SELECT diagnosis_id, icd10_code, description FROM diagnoses ORDER BY icd10_code ASC";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("diagnosis_id") %></td>
            <td><span class="fw-bold text-primary"><%= rs.getString("icd10_code") %></span></td>
            <td><%= rs.getString("description") %></td>
            <td class="text-center">
                <div class="btn-group" role="group">
                    <a href="diagnosisForm.jsp?editId=<%= rs.getInt("diagnosis_id") %>" 
                       class="btn btn-warning btn-sm" title="Edit">
                       <i class="bi bi-pencil"></i> Edit
                    </a>
                    <a href="manageDiagnoses.jsp?deleteId=<%= rs.getInt("diagnosis_id") %>"
                       class="btn btn-danger btn-sm" title="Delete"
                       onclick="return confirm('Are you sure you want to delete this diagnosis code?')">
                       Delete
                    </a>
                </div>
            </td>
        </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='4'>Error loading data: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
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

</body>
</html>