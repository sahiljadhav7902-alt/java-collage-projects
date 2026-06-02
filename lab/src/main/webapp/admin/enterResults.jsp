<%@ page import="com.mycompany.lab.BllResult" %>
<%@ page import="java.util.List" %>

<%
    // SECURITY & PARAMETER CHECK PRESERVED
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    BllResult bllResult = new BllResult();
    String message = "";
    String orderIdParam = request.getParameter("orderId");
    
    if (orderIdParam == null) {
        response.sendRedirect("manageSpecimens.jsp");
        return;
    }
    int orderId = Integer.parseInt(orderIdParam);

    // POST HANDLING LOGIC PRESERVED 100%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String[] resultIds = request.getParameterValues("resultId");
        String[] orderTestIds = request.getParameterValues("orderTestId");
        String[] values = request.getParameterValues("resultValue");
        String[] units = request.getParameterValues("unit");
        String[] referenceRanges = request.getParameterValues("reference_range");
        String[] flags = request.getParameterValues("abnormalFlag");
        String[] statuses = request.getParameterValues("resultStatus");

        if (orderTestIds != null) {
            for (int i = 0; i < orderTestIds.length; i++) {
                try {
                    String resultId = resultIds[i];
                    int orderTestId = Integer.parseInt(orderTestIds[i]);
                    String val = values[i];
                    String unitVal = units[i];
                    String refRangeVal = referenceRanges[i];
                    String flagVal = flags[i];
                    String statusVal = statuses[i];

                    boolean isNew = (resultId == null || resultId.trim().isEmpty());
                    String resultMsg;

                    if (isNew) {
                        resultMsg = bllResult.insertResult(orderId, orderTestId, val, unitVal, refRangeVal, flagVal, statusVal);
                    } else {
                        resultMsg = bllResult.verifyResult(Integer.parseInt(resultId), val, unitVal, refRangeVal, flagVal, statusVal);
                    }

                    if (!resultMsg.startsWith("SUCCESS")) {
                        message = resultMsg;
                        break;
                    }
                } catch (Exception e) {
                    message = "System Error: " + e.getMessage();
                    break;
                }
            }
            if (message.isEmpty()) message = "Diagnostic results validated and saved successfully.";
        }
    }

    List<BllResult.ResultInfo> resultList = bllResult.getResultsByOrder(orderId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Result Verification | PathLab</title>
    
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
            padding: 25px 0;
            margin-bottom: 30px;
        }

        .result-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

        .test-name-cell {
            font-weight: 600;
            color: var(--dark-header);
            background: #fdfeff;
        }

        .form-control-result {
            border: 1px solid #cbd5e1;
            font-weight: 600;
            color: var(--primary-blue);
            text-align: center;
        }

        /* Flag Specific Styles */
        .flag-select {
            font-weight: 600;
            font-size: 0.85rem;
        }
        
        .status-badge-pre { color: #f59e0b; background: #fffbeb; border: 1px solid #fef3c7; }
        .status-badge-fin { color: #10b981; background: #ecfdf5; border: 1px solid #d1fae5; }

        .btn-save-all {
            background: var(--primary-blue);
            padding: 15px 40px;
            font-weight: 700;
            border-radius: 10px;
            box-shadow: 0 10px 15px -3px rgba(5, 97, 252, 0.3);
        }
    </style>
</head>

<body>
    <jsp:include page="adminNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <nav aria-label="breadcrumb">
                      <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="manageSpecimens.jsp" class="text-decoration-none">Specimens</a></li>
                        <li class="breadcrumb-item active">Order #<%= orderId %></li>
                      </ol>
                    </nav>
                    <h2 class="fw-bold m-0">Diagnostic Verification Terminal</h2>
                </div>
                <div class="text-end">
                    <span class="badge bg-dark px-3 py-2 rounded-pill">Batch #<%= orderId %>-<%= System.currentTimeMillis()/1000000 %></span>
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid px-5 pb-5">

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-success border-0 shadow-sm rounded-3 mb-4 d-flex align-items-center">
                <i class="bi bi-check2-all fs-4 me-3"></i>
                <div class="fw-medium"><%= message %></div>
            </div>
        <% } %>

        <div class="result-card overflow-hidden">
            <form method="POST">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4" style="width: 25%;">Analytical Test</th>
                                <th style="width: 15%;">Observed Value</th>
                                <th style="width: 12%;">Unit</th>
                                <th style="width: 15%;">Reference Range</th>
                                <th style="width: 15%;">Clinical Flag</th>
                                <th style="width: 18%;">Validation Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (BllResult.ResultInfo r : resultList) {
                                String resultIdVal = (r.resultId > 0) ? String.valueOf(r.resultId) : "";
                                String resultVal = (r.resultValue != null) ? r.resultValue : "";
                                String unitVal = (r.unit != null) ? r.unit : "";
                                String rangeVal = (r.referenceRange != null) ? r.referenceRange : "";
                                String flagVal = (r.abnormalFlag != null) ? r.abnormalFlag : "Normal";
                                String statusVal = (r.resultStatus != null) ? r.resultStatus : "Preliminary";
                            %>
                            <tr>
                                <input type="hidden" name="orderTestId" value="<%= r.orderTestId %>">
                                <input type="hidden" name="resultId" value="<%= resultIdVal %>">

                                <td class="ps-4 test-name-cell">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-heptagon-fill text-primary me-2 small"></i>
                                        <%= r.testName %>
                                    </div>
                                </td>

                                <td>
                                    <input type="text" name="resultValue" class="form-control form-control-result" 
                                           value="<%= resultVal %>" required placeholder="0.00">
                                </td>

                                <td>
                                    <input type="text" name="unit" class="form-control form-control-sm text-center bg-light" 
                                           value="<%= unitVal %>" placeholder="unit">
                                </td>

                                <td>
                                    <input type="text" name="reference_range" class="form-control form-control-sm text-center" 
                                           value="<%= rangeVal %>" placeholder="70 - 110">
                                </td>

                                <td>
                                    <select name="abnormalFlag" class="form-select form-select-sm flag-select">
                                        <option value="Normal" <%= "Normal".equals(flagVal) ? "selected" : "" %>>? Normal</option>
                                        <option value="High" <%= "High".equals(flagVal) ? "selected" : "" %>>?? High</option>
                                        <option value="Low" <%= "Low".equals(flagVal) ? "selected" : "" %>>?? Low</option>
                                        <option value="Critical" <%= "Critical".equals(flagVal) ? "selected" : "" %>>? Critical</option>
                                    </select>
                                </td>

                                <td>
                                    <div class="input-group input-group-sm">
                                        <label class="input-group-text bg-white"><i class="bi bi-shield-check"></i></label>
                                        <select name="resultStatus" class="form-select fw-bold <%= "Final".equals(statusVal) ? "text-success" : "text-warning" %>">
                                            <option value="Preliminary" <%= "Preliminary".equals(statusVal) ? "selected" : "" %>>Preliminary</option>
                                            <option value="Final" <%= "Final".equals(statusVal) ? "selected" : "" %>>Final (Verified)</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="bg-light p-4 d-flex justify-content-between align-items-center border-top">
                    <p class="text-muted small mb-0">
                        <i class="bi bi-info-circle me-1"></i> 
                        Setting status to <strong>Final</strong> will lock the result for patient reporting.
                    </p>
                    <button type="submit" class="btn btn-primary btn-save-all">
                        <i class="bi bi-cloud-check-fill me-2"></i> Commit Diagnostic Data
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>