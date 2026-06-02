<%-- 
    Document   : doctorOrderForm
    Created on : 18-Feb-2026, 8:50:45 pm
    Author     : sahil jadhav
--%>
<%@ page import="com.mycompany.lab.BllOrder" %>
<%@ page import="java.util.Map" %>

<%
    // --- LOGIC PRESERVED ---
    Integer physicianIdObj = (Integer) session.getAttribute("userId");
    if (physicianIdObj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int physicianId = physicianIdObj;

    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int diagnosisId = Integer.parseInt(request.getParameter("diagnosisId"));
            
            BllOrder bll = new BllOrder();
            int newOrderId = bll.createOrder(patientId, physicianId, diagnosisId);
            
            if (newOrderId > 0) {
                response.sendRedirect("doctorOrderTests.jsp?orderId=" + newOrderId);
                return;
            } else {
                message = "Failed to create order.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        }
    }

    BllOrder bll = new BllOrder();
    Map<Integer, String> diagnoses = bll.getAllDiagnoses();
    
    String patientIdParam = request.getParameter("patientId");
    String patientName = "";
    
    if (patientIdParam != null && !patientIdParam.isEmpty()) {
        try {
            int pId = Integer.parseInt(patientIdParam);
            // Note: Keeping your method call exactly as requested
            patientName = bll.getPhysicianName(pId);
        } catch (Exception e) {
            message = "Invalid Patient ID.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Lab Order | Lab Portal</title>
    
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
            padding: 30px 0;
            margin-bottom: 30px;
        }

        .form-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0,0,0,0.05);
            box-shadow: 0 10px 25px rgba(0,0,0,0.02);
            overflow: hidden;
        }

        .card-header-custom {
            background-color: #f8fafc;
            padding: 1.25rem 2rem;
            border-bottom: 1px solid #e2e8f0;
            font-weight: 600;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.85rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control, .form-select {
            padding: 0.75rem 1rem;
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--doctor-green);
            box-shadow: 0 0 0 4px rgba(5, 150, 105, 0.1);
        }

        .btn-success-custom {
            background-color: var(--doctor-green);
            border-color: var(--doctor-green);
            padding: 0.8rem;
            font-weight: 600;
            border-radius: 10px;
        }

        .btn-success-custom:hover {
            background-color: #047857;
            transform: translateY(-1px);
        }

        .step-indicator {
            display: flex;
            align-items: center;
            margin-bottom: 2rem;
            justify-content: center;
        }
        .step-pill {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .step-active { background: var(--doctor-green); color: white; }
        .step-line { width: 40px; height: 2px; background: #e2e8f0; margin: 0 10px; }
        .step-inactive { background: #e2e8f0; color: #94a3b8; }
    </style>
</head>
<body>

    <jsp:include page="doctorNavbar.jsp" />

    <header class="page-header">
        <div class="container-fluid px-5 d-flex justify-content-between align-items-center">
            <div>
                <h2 class="fw-bold m-0 text-dark">Create Lab Order</h2>
                <p class="text-muted small mb-0">New Clinical Requisition</p>
            </div>
            <a href="doctorDashboard.jsp" class="btn btn-outline-secondary btn-sm rounded-pill px-4">
                <i class="bi bi-x-lg me-1"></i> Cancel
            </a>
        </div>
    </header>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-danger border-0 shadow-sm rounded-3 mb-4">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= message %>
                    </div>
                <% } %>

                <% if (patientName.isEmpty()) { %>
                    <div class="form-card text-center py-5 px-4 shadow-sm">
                        <div class="mb-4">
                            <i class="bi bi-person-bounding-box text-muted opacity-25" style="font-size: 4rem;"></i>
                        </div>
                        <h4 class="fw-bold">No Patient Selected</h4>
                        <p class="text-muted">You must select a patient from the database before initiating an order.</p>
                        <a href="doctorPatients.jsp" class="btn btn-success-custom px-4 mt-3">
                            <i class="bi bi-search me-2"></i> Find Patient
                        </a>
                    </div>
                <% } else { %>

                    <div class="step-indicator">
                        <div class="step-pill step-active">1. Patient & Diagnosis</div>
                        <div class="step-line"></div>
                        <div class="step-pill step-inactive">2. Select Tests</div>
                    </div>

                    <div class="form-card shadow-sm">
                        <div class="card-header-custom">
                            Requisition Details
                        </div>
                        <div class="card-body p-4 p-md-5">
                            <form action="doctorOrderForm.jsp" method="POST">
                                <input type="hidden" name="patientId" value="<%= patientIdParam %>">

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label class="form-label">Patient</label>
                                        <input type="text" class="form-control bg-light fw-semibold" value="<%= patientName %>" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Requesting Physician</label>
                                        <input type="text" class="form-control bg-light" value="Dr. <%= session.getAttribute("firstName") %>" readonly>
                                    </div>
                                </div>

                                <div class="mb-5">
                                    <label for="diagnosisId" class="form-label">Diagnosis (ICD-10)</label>
                                    <select class="form-select" id="diagnosisId" name="diagnosisId" required>
                                        <option value="" selected disabled>-- Choose Primary Diagnosis --</option>
                                        <% 
                                            for (Map.Entry<Integer, String> entry : diagnoses.entrySet()) { 
                                        %>
                                            <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
                                        <% } %>
                                    </select>
                                    <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i> Specify the clinical reason for this requisition.</div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-success-custom btn-lg">
                                        Next: Select Tests <i class="bi bi-arrow-right ms-2"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                <% } %>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>