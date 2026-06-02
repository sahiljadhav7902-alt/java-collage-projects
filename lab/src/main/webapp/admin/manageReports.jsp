<%-- 
    Document   : manageReports
    Created on : 18-Feb-2026, 5:43:00 pm
    Author     : sahil jadhav
--%>

<%@ page import="com.mycompany.lab.BllReportGenerator" %>
<%@ page import="com.mycompany.lab.DataAccess" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.itextpdf.text.Document" %>
<%@ page import="com.itextpdf.text.Paragraph" %>
<%@ page import="com.itextpdf.text.Phrase" %>
<%@ page import="com.itextpdf.text.Font" %>
<%@ page import="com.itextpdf.text.PageSize" %>
<%@ page import="com.itextpdf.text.pdf.PdfPTable" %>
<%@ page import="com.itextpdf.text.pdf.PdfPCell" %>
<%@ page import="com.itextpdf.text.pdf.PdfWriter" %>

<%
    BllReportGenerator bll = new BllReportGenerator();
    BllReportGenerator.DashboardStats stats = bll.getDashboardStats();
    DecimalFormat df = new DecimalFormat("#,###.00");

    String range = request.getParameter("range");
    if (range == null || range.trim().isEmpty()) {
        range = "month";
    }

    String reportType = request.getParameter("reportType");
    if (reportType == null || reportType.trim().isEmpty()) {
        reportType = "patients";
    }

    String fromDateInput = request.getParameter("fromDate");
    String toDateInput = request.getParameter("toDate");
    String errorMessage = "";

    LocalDate today = LocalDate.now();
    LocalDate startDate = today.withDayOfMonth(1);
    LocalDate endDate = today;
    DateTimeFormatter displayFmt = DateTimeFormatter.ofPattern("dd-MMM-yyyy");

    if ("day".equalsIgnoreCase(range)) {
        startDate = today;
        endDate = today;
    } else if ("week".equalsIgnoreCase(range)) {
        startDate = today.minusDays(6);
        endDate = today;
    } else if ("month".equalsIgnoreCase(range)) {
        startDate = today.withDayOfMonth(1);
        endDate = today;
    } else if ("year".equalsIgnoreCase(range)) {
        startDate = today.withDayOfYear(1);
        endDate = today;
    } else if ("custom".equalsIgnoreCase(range)) {
        try {
            if (fromDateInput != null && !fromDateInput.trim().isEmpty()) {
                startDate = LocalDate.parse(fromDateInput);
            }
            if (toDateInput != null && !toDateInput.trim().isEmpty()) {
                endDate = LocalDate.parse(toDateInput);
            }
            if (endDate.isBefore(startDate)) {
                LocalDate temp = startDate;
                startDate = endDate;
                endDate = temp;
            }
        } catch (Exception e) {
            range = "month";
            startDate = today.withDayOfMonth(1);
            endDate = today;
            errorMessage = "Invalid custom date format. Showing monthly report.";
        }
    } else {
        range = "month";
        startDate = today.withDayOfMonth(1);
        endDate = today;
    }

    String rangeLabel;
    if ("day".equalsIgnoreCase(range)) {
        rangeLabel = "Day-wise";
    } else if ("week".equalsIgnoreCase(range)) {
        rangeLabel = "Week-wise";
    } else if ("month".equalsIgnoreCase(range)) {
        rangeLabel = "Month-wise";
    } else if ("year".equalsIgnoreCase(range)) {
        rangeLabel = "Year-wise";
    } else {
        rangeLabel = "Custom Date Range";
    }

    String reportTypeLabel;
    if ("patients".equalsIgnoreCase(reportType)) {
        reportTypeLabel = "Patient Master";
    } else if ("orders".equalsIgnoreCase(reportType)) {
        reportTypeLabel = "Order Report";
    } else if ("payment".equalsIgnoreCase(reportType)) {
        reportTypeLabel = "Payment Reports";
    } else if ("inventory".equalsIgnoreCase(reportType)) {
        reportTypeLabel = "Inventory Reports";
    } else if ("specimens".equalsIgnoreCase(reportType)) {
        reportTypeLabel = "Specimens Reports";
    } else {
        reportType = "patients";
        reportTypeLabel = "Patient Master";
    }

    int filteredTotalOrders = 0;
    int filteredCompletedOrders = 0;
    int filteredPendingOrders = 0;
    int filteredPatients = 0;
    double filteredBilled = 0.0;
    double filteredPaid = 0.0;

    List<String[]> reportRows = new ArrayList<String[]>();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DataAccess.getConnection();

        String summarySql =
            "SELECT " +
            "COUNT(DISTINCT o.order_id) AS total_orders, " +
            "SUM(CASE WHEN o.status='Final' OR o.status='Completed' THEN 1 ELSE 0 END) AS completed_orders, " +
            "SUM(CASE WHEN o.status='Ordered' OR o.status='In Progress' THEN 1 ELSE 0 END) AS pending_orders, " +
            "COUNT(DISTINCT o.patient_id) AS total_patients, " +
            "COALESCE(SUM(b.amount), 0) AS total_billed, " +
            "COALESCE(SUM(CASE WHEN b.payment_status='Paid' THEN b.amount ELSE 0 END), 0) AS total_paid " +
            "FROM orders o " +
            "LEFT JOIN billing b ON b.order_id = o.order_id " +
            "WHERE DATE(o.order_date) BETWEEN ? AND ?";

        ps = con.prepareStatement(summarySql);
        ps.setString(1, startDate.toString());
        ps.setString(2, endDate.toString());
        rs = ps.executeQuery();

        if (rs.next()) {
            filteredTotalOrders = rs.getInt("total_orders");
            filteredCompletedOrders = rs.getInt("completed_orders");
            filteredPendingOrders = rs.getInt("pending_orders");
            filteredPatients = rs.getInt("total_patients");
            filteredBilled = rs.getDouble("total_billed");
            filteredPaid = rs.getDouble("total_paid");
        }

        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}

        String detailSql =
            "SELECT o.order_id, o.order_date, o.status, " +
            "CONCAT(u.first_name, ' ', u.last_name) AS patient_name, " +
            "COALESCE(b.amount, 0) AS amount " +
            "FROM orders o " +
            "JOIN users u ON u.user_id = o.patient_id " +
            "LEFT JOIN billing b ON b.order_id = o.order_id " +
            "WHERE DATE(o.order_date) BETWEEN ? AND ? " +
            "ORDER BY o.order_date DESC LIMIT 40";

        ps = con.prepareStatement(detailSql);
        ps.setString(1, startDate.toString());
        ps.setString(2, endDate.toString());
        rs = ps.executeQuery();

        while (rs.next()) {
            reportRows.add(new String[]{
                rs.getString("order_id"),
                rs.getString("order_date"),
                rs.getString("patient_name"),
                rs.getString("status"),
                df.format(rs.getDouble("amount"))
            });
        }
    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "Unable to generate date-wise report: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }

    if ("pdf".equalsIgnoreCase(request.getParameter("download"))) {
        try {
            response.reset();
            response.setContentType("application/pdf");
            response.setHeader(
                "Content-Disposition",
                "attachment; filename=lab_" + reportType + "_report_" + range + "_" + startDate + "_to_" + endDate + ".pdf"
            );

            Document document = new Document(PageSize.A4.rotate(), 24, 24, 20, 20);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Font headingFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
            Font bodyFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);

            document.add(new Paragraph("Pathology Lab - " + reportTypeLabel + " (Date-wise)", titleFont));
            document.add(new Paragraph("Generated On: " + java.time.LocalDateTime.now().toString(), bodyFont));
            document.add(new Paragraph("Report Type: " + reportTypeLabel, bodyFont));
            document.add(new Paragraph("Filter: " + rangeLabel + " (" + startDate.format(displayFmt) + " to " + endDate.format(displayFmt) + ")", bodyFont));
            document.add(new Paragraph(" "));

            PdfPTable summaryTable = new PdfPTable(4);
            summaryTable.setWidthPercentage(100);
            summaryTable.addCell(new Phrase("Total Orders", headingFont));
            summaryTable.addCell(new Phrase(String.valueOf(filteredTotalOrders), bodyFont));
            summaryTable.addCell(new Phrase("Completed Orders", headingFont));
            summaryTable.addCell(new Phrase(String.valueOf(filteredCompletedOrders), bodyFont));

            summaryTable.addCell(new Phrase("Pending Orders", headingFont));
            summaryTable.addCell(new Phrase(String.valueOf(filteredPendingOrders), bodyFont));
            summaryTable.addCell(new Phrase("Unique Patients", headingFont));
            summaryTable.addCell(new Phrase(String.valueOf(filteredPatients), bodyFont));

            summaryTable.addCell(new Phrase("Total Billed", headingFont));
            summaryTable.addCell(new Phrase(df.format(filteredBilled), bodyFont));
            summaryTable.addCell(new Phrase("Total Paid", headingFont));
            summaryTable.addCell(new Phrase(df.format(filteredPaid), bodyFont));
            document.add(summaryTable);

            document.add(new Paragraph(" "));
            document.add(new Paragraph("Recent Orders in Selected Range", headingFont));

            PdfPTable detailTable = new PdfPTable(5);
            detailTable.setWidthPercentage(100);
            detailTable.setWidths(new float[]{1.2f, 1.7f, 2.8f, 1.4f, 1.2f});

            String[] headers = {"Order ID", "Order Date", "Patient", "Status", "Amount"};
            for (int i = 0; i < headers.length; i++) {
                PdfPCell cell = new PdfPCell(new Phrase(headers[i], headingFont));
                detailTable.addCell(cell);
            }

            if (reportRows.isEmpty()) {
                PdfPCell noDataCell = new PdfPCell(new Phrase("No records found for selected date filter.", bodyFont));
                noDataCell.setColspan(5);
                detailTable.addCell(noDataCell);
            } else {
                for (String[] row : reportRows) {
                    detailTable.addCell(new Phrase(row[0], bodyFont));
                    detailTable.addCell(new Phrase(row[1], bodyFont));
                    detailTable.addCell(new Phrase(row[2], bodyFont));
                    detailTable.addCell(new Phrase(row[3], bodyFont));
                    detailTable.addCell(new Phrase(row[4], bodyFont));
                }
            }

            document.add(detailTable);
            document.close();
            return;
        } catch (Exception e) {
            e.printStackTrace();
            if (errorMessage == null || errorMessage.isEmpty()) {
                errorMessage = "PDF generation failed: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics | Lab Portal</title>
    
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

        /* Analytics Card Styling */
        .stats-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            padding: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 100%;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        }

        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }

        .stats-label {
            font-size: 0.85rem;
            font-weight: 500;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stats-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--dark-header);
            margin: 0.25rem 0;
        }

        /* Export Card Styling */
        .content-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            overflow: hidden;
            padding: 2rem;
        }

        .export-btn {
            border: 1px solid #e2e8f0;
            background: #fff;
            padding: 1.5rem;
            border-radius: 12px;
            text-align: center;
            transition: all 0.2s;
            text-decoration: none;
            color: var(--dark-header);
            display: block;
        }

        .export-btn:hover {
            background: #f8fafc;
            border-color: var(--primary-blue);
            color: var(--primary-blue);
        }

        .export-btn i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .pill-badge {
            display: inline-block;
            background: #e2e8f0;
            color: #1e293b;
            padding: 0.35rem 0.7rem;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 600;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

  

    <div class="container-fluid px-5 pb-5">

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-warning border-0 shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i><%= errorMessage %>
            </div>
        <% } %>
        
       

        <div class="content-card mb-4">
            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                <div>
                    <h5 class="fw-bold mb-1">Date-wise Jasper Report</h5>
                    <p class="text-muted small mb-1">Generate PDF analytics by day, week, month, year, or custom range</p>
                    <span class="pill-badge"><%= rangeLabel %>: <%= startDate.format(displayFmt) %> to <%= endDate.format(displayFmt) %></span>
                </div>
            </div>

            <form method="get" action="manageReports.jsp" class="row g-3 align-items-end mb-4">
                <div class="col-md-3">
                    <label class="form-label small text-muted">Report Type</label>
                    <select class="form-select" name="reportType">
                        <option value="patients" <%= "patients".equalsIgnoreCase(reportType) ? "selected" : "" %>>Patient Master</option>
                        <option value="orders" <%= "orders".equalsIgnoreCase(reportType) ? "selected" : "" %>>Order Report</option>
                        <option value="payment" <%= "payment".equalsIgnoreCase(reportType) ? "selected" : "" %>>Payment Reports</option>
                        <option value="inventory" <%= "inventory".equalsIgnoreCase(reportType) ? "selected" : "" %>>Inventory Reports</option>
                        <option value="specimens" <%= "specimens".equalsIgnoreCase(reportType) ? "selected" : "" %>>Specimens Reports</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label small text-muted">Date Filter</label>
                    <select class="form-select" name="range" id="rangeSelect" onchange="toggleCustomDateFields()">
                        <option value="day" <%= "day".equalsIgnoreCase(range) ? "selected" : "" %>>Day-wise</option>
                        <option value="week" <%= "week".equalsIgnoreCase(range) ? "selected" : "" %>>Week-wise</option>
                        <option value="month" <%= "month".equalsIgnoreCase(range) ? "selected" : "" %>>Month-wise</option>
                        <option value="year" <%= "year".equalsIgnoreCase(range) ? "selected" : "" %>>Year-wise</option>
                        <option value="custom" <%= "custom".equalsIgnoreCase(range) ? "selected" : "" %>>Custom Range</option>
                    </select>
                </div>

                <div class="col-md-2 custom-date-field">
                    <label class="form-label small text-muted">From Date</label>
                    <input type="date" class="form-control" name="fromDate" value="<%= (fromDateInput != null) ? fromDateInput : "" %>">
                </div>

                <div class="col-md-2 custom-date-field">
                    <label class="form-label small text-muted">To Date</label>
                    <input type="date" class="form-control" name="toDate" value="<%= (toDateInput != null) ? toDateInput : "" %>">
                </div>

                <div class="col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-funnel me-1"></i>Apply Filter
                    </button>
                    <button type="submit" name="download" value="pdf" class="btn btn-outline-danger">
                        <i class="bi bi-file-earmark-pdf me-1"></i>Download iText PDF
                    </button>
                </div>
            </form>

            <div class="row g-3 mb-4">
                <div class="col-md-2">
                    <div class="border rounded p-3 bg-light h-100">
                        <div class="text-muted small">Orders</div>
                        <div class="fw-bold fs-5"><%= filteredTotalOrders %></div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="border rounded p-3 bg-light h-100">
                        <div class="text-muted small">Completed</div>
                        <div class="fw-bold fs-5 text-success"><%= filteredCompletedOrders %></div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="border rounded p-3 bg-light h-100">
                        <div class="text-muted small">Pending</div>
                        <div class="fw-bold fs-5 text-warning"><%= filteredPendingOrders %></div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="border rounded p-3 bg-light h-100">
                        <div class="text-muted small">Patients</div>
                        <div class="fw-bold fs-5"><%= filteredPatients %></div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="border rounded p-3 bg-light h-100">
                        <div class="text-muted small">Billed</div>
                        <div class="fw-bold fs-6 text-primary"><%= df.format(filteredBilled) %></div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="border rounded p-3 bg-light h-100">
                        <div class="text-muted small">Paid</div>
                        <div class="fw-bold fs-6 text-success"><%= df.format(filteredPaid) %></div>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-sm table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Order ID</th>
                            <th>Order Date</th>
                            <th>Patient</th>
                            <th>Status</th>
                            <th class="text-end">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (reportRows.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">No records found for selected date filter.</td>
                            </tr>
                        <% } else {
                            for (String[] row : reportRows) { %>
                            <tr>
                                <td><%= row[0] %></td>
                                <td><%= row[1] %></td>
                                <td><%= row[2] %></td>
                                <td><span class="badge bg-secondary"><%= row[3] %></span></td>
                                <td class="text-end"><%= row[4] %></td>
                            </tr>
                        <% }
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleCustomDateFields() {
            var range = document.getElementById('rangeSelect').value;
            var customFields = document.querySelectorAll('.custom-date-field');
            for (var i = 0; i < customFields.length; i++) {
                customFields[i].style.display = (range === 'custom') ? 'block' : 'none';
            }
        }
        toggleCustomDateFields();
    </script>
</body>
</html>