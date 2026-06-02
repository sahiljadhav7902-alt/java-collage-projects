<%-- 
    Document   : exportData
    Created on : 18-Feb-2026, 5:43:23 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllReportGenerator" %>
<%@ page import="java.util.List" %>
<%
    // 1. Determine Report Type
    String type = request.getParameter("type");
    if (type == null) type = "";

    BllReportGenerator bll = new BllReportGenerator();
    List<String[]> data = null;
    String filename = "report.csv";

    // 2. Fetch Data based on type
    switch (type) {
        case "patients":
            data = bll.getPatientData();
            filename = "patients_export.csv";
            break;
        case "orders":
            data = bll.getOrderData();
            filename = "orders_export.csv";
            break;
        case "billing":
            data = bll.getBillingData();
            filename = "billing_export.csv";
            break;
        case "inventory":
            data = bll.getInventoryData();
            filename = "inventory_export.csv";
            break;
        default:
            out.println("Invalid report type.");
            return;
    }

    // 3. Set Response Headers for Download
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

    // 4. Write Data to Output Stream
    if (data != null) {
        for (String[] row : data) {
            // Construct CSV line
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < row.length; i++) {
                // Escape quotes if necessary
                String cell = row[i];
                if (cell == null) cell = "";
                if (cell.contains(",") || cell.contains("\"")) {
                    cell = "\"" + cell.replace("\"", "\"\"") + "\"";
                }
                sb.append(cell);
                if (i < row.length - 1) {
                    sb.append(",");
                }
            }
            out.println(sb.toString());
        }
    }
%>