<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.lab.BllSpecimen" %>

<%
    // LOGIC PRESERVED 100%
    String message = "";
    BllSpecimen bll = new BllSpecimen();
    BllSpecimen.SpecimenInfo specimen = null;
    boolean isEdit = false;

    List<BllSpecimen.SpecimenInfo> orderList = bll.getAvailableOrders();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("specimenId");
        String orderId = request.getParameter("orderId");
        String barcode = request.getParameter("barcode");
        String type = request.getParameter("type");
        String collectionTime = request.getParameter("collectionTime");
        String status = request.getParameter("status");
        String receivedTime = request.getParameter("receivedTime");
        String technicianId = request.getParameter("technicianId");

        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            message = bll.updateSpecimen(id, status, receivedTime, technicianId);
            specimen = bll.getSpecimenById(id);
            isEdit = true;
        } else {
            message = bll.addSpecimen(
                    Integer.parseInt(orderId),
                    barcode,
                    type,
                    collectionTime
            );
        }
    } else {
        if (request.getParameter("editId") != null) {
            isEdit = true;
            int id = Integer.parseInt(request.getParameter("editId"));
            specimen = bll.getSpecimenById(id);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Update Chain of Custody" : "New Specimen Intake" %> | PathLab</title>
    
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
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 10px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #cbd5e1;
        }

        .readonly-box {
            background-color: #f1f5f9;
            border: 1px dashed #cbd5e1;
            padding: 10px 15px;
            border-radius: 8px;
            color: #475569;
            font-weight: 500;
        }

        .mode-indicator {
            font-size: 0.75rem;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 700;
            text-transform: uppercase;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <div class="container-fluid px-5 py-4">
        
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="mode-indicator <%= isEdit ? "bg-warning-subtle text-warning-emphasis border border-warning" : "bg-primary-subtle text-primary border border-primary" %>">
                    <%= isEdit ? "Logistics Update" : "Clinical Intake" %>
                </span>
                <h2 class="fw-bold text-dark mt-2 mb-0">
                    <%= isEdit ? "Track Chain of Custody" : "Register New Specimen" %>
                </h2>
            </div>
            <a href="manageSpecimens.jsp" class="btn btn-outline-secondary px-4">
                <i class="bi bi-arrow-left me-2"></i>Back to Tracker
            </a>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4"><%= message %></div>
        <% } %>

        <form method="POST">
            <input type="hidden" name="specimenId" value="<%= (specimen != null) ? specimen.specimenId : "" %>">

            <% if (!isEdit) { %>
                <div class="horizontal-card">
                    <div class="section-header">
                        <i class="bi bi-box-seam me-2 text-primary"></i> Primary Identification
                    </div>

                    <div class="row mb-4">
                        <label class="col-sm-2 form-label text-sm-end">Patient Order</label>
                        <div class="col-sm-8">
                            <select name="orderId" class="form-select shadow-sm" required>
                                <option value="">-- Search and Select Order --</option>
                                <% for (BllSpecimen.SpecimenInfo o : orderList) { %>
                                    <option value="<%= o.orderId %>">Order #<%= o.orderId %> - <%= o.patientName %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <label class="col-sm-2 form-label text-sm-end">Accession Barcode</label>
                        <div class="col-sm-8">
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-upc-scan"></i></span>
                                <input type="text" name="barcode" class="form-control" placeholder="Scan or type barcode" required>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="horizontal-card">
                    <div class="section-header">
                        <i class="bi bi-droplet me-2 text-danger"></i> Specimen Details
                    </div>

                    <div class="row mb-4">
                        <label class="col-sm-2 form-label text-sm-end">Biological Type</label>
                        <div class="col-sm-8">
                            <select name="type" class="form-select">
                                <option value="Blood">Blood (Whole/Serum/Plasma)</option>
                                <option value="Urine">Urine</option>
                                <option value="Swab">Swab (Nasal/Oral)</option>
                                <option value="Tissue">Tissue Biopsy</option>
                                <option value="Fluid">Cerebrospinal / Pleural Fluid</option>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-0">
                        <label class="col-sm-2 form-label text-sm-end">Collection Datetime</label>
                        <div class="col-sm-8">
                            <input type="datetime-local" name="collectionTime" class="form-control" required>
                            <div class="form-text mt-2">Required for timestamping the clinical lifecycle.</div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end mb-5">
                    <button type="submit" class="btn btn-primary px-5 py-3 fw-bold shadow">
                        <i class="bi bi-plus-circle me-2"></i> Register and Track
                    </button>
                </div>

            <% } else { %>
                <div class="horizontal-card border-warning">
                    <div class="section-header">
                        <i class="bi bi-info-circle me-2 text-warning"></i> Locked Reference Info
                    </div>
                    
                    <div class="row mb-4">
                        <label class="col-sm-2 form-label text-sm-end">Specimen / Order</label>
                        <div class="col-sm-4">
                            <div class="readonly-box">SID: <%= specimen.specimenId %></div>
                        </div>
                        <div class="col-sm-4">
                            <div class="readonly-box">OID: <%= specimen.orderId %></div>
                        </div>
                    </div>
                </div>

                <div class="horizontal-card">
                    <div class="section-header">
                        <i class="bi bi-truck me-2 text-primary"></i> Lifecycle Status Update
                    </div>

                    <div class="row mb-4">
                        <label class="col-sm-2 form-label text-sm-end">Processing Stage</label>
                        <div class="col-sm-8">
                            <select name="status" class="form-select border-primary bg-primary-subtle" required>
                                <% 
                                    String[] stages = {"Collected", "In Transit", "Received", "Processing", "Completed", "Rejected"};
                                    for(String s : stages) {
                                        String selected = (specimen != null && s.equals(specimen.status)) ? "selected" : "";
                                %>
                                    <option value="<%=s%>" <%=selected%>><%=s%></option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <label class="col-sm-2 form-label text-sm-end">Logistics Data</label>
                        <div class="col-sm-4">
                            <label class="small text-muted mb-1">Receipt Datetime</label>
                            <input type="datetime-local" name="receivedTime" class="form-control"
                                   value="<%= (specimen.receivedTime != null) ? specimen.receivedTime : "" %>">
                        </div>
<!--                        <div class="col-sm-4">
                            <label class="small text-muted mb-1">Assigned Technician ID</label>
                            <input type="number" name="technicianId" class="form-control"
                                   value="<%= (specimen.technicianId != null) ? specimen.technicianId : "" %>">
                        </div>-->
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-3 mb-5">
                    <a href="manageSpecimens.jsp" class="btn btn-light border px-5">Discard Changes</a>
                    <button type="submit" class="btn btn-success px-5 fw-bold shadow">
                        <i class="bi bi-arrow-repeat me-2"></i> Commit Status Update
                    </button>
                </div>
            <% } %>

        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>