<%@ page import="com.mycompany.lab.BllLaboratory" %>

<%
    // LOGIC PRESERVED 100%
    String message = "";
    BllLaboratory bll = new BllLaboratory();
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("labId");
        String labName = request.getParameter("labName");
        String location = request.getParameter("location");
        String accreditation = request.getParameter("accreditation");

        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            message = bll.updateLaboratory(id, labName, location, accreditation);
        } else {
            message = bll.addLaboratory(labName, location, accreditation);
        }
    }

    BllLaboratory lab = null;
    boolean isEdit = false;
    
    if (request.getParameter("editId") != null) {
        isEdit = true;
        try {
            int editId = Integer.parseInt(request.getParameter("editId"));
            lab = bll.getLaboratoryById(editId);
        } catch (Exception e) {
            message = "Error loading laboratory data.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit" : "Add" %> Laboratory | PathLab Admin</title>
    
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
            padding: 40px;
            margin-bottom: 25px;
        }

        .section-header {
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-weight: 700;
            color: var(--dark-header);
            display: flex;
            align-items: center;
            font-size: 1.1rem;
        }

        .form-label {
            font-weight: 600;
            color: #64748b;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 12px;
        }

        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #cbd5e1;
            background-color: #fcfdfe;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            background-color: #fff;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px rgba(5, 97, 252, 0.1);
        }

        .btn-save {
            background-color: var(--primary-blue);
            padding: 12px 40px;
            font-weight: 600;
            border-radius: 8px;
            border: none;
            transition: all 0.3s;
        }

        .btn-save:hover {
            background-color: #044ecb;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(5, 97, 252, 0.2);
        }

        .btn-cancel {
            color: #64748b;
            font-weight: 500;
            text-decoration: none;
            padding: 12px 25px;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <div class="container-fluid px-5 py-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="manageLabs.jsp" class="text-decoration-none">Laboratories</a></li>
                        <li class="breadcrumb-item active"><%= isEdit ? "Update" : "Register" %></li>
                    </ol>
                </nav>
                <h2 class="fw-bold text-dark m-0"><%= isEdit ? "Edit Laboratory Branch" : "Add New Laboratory" %></h2>
            </div>
            <i class="bi bi-building fs-1 text-primary opacity-25"></i>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4 text-center">
                <i class="bi bi-info-circle-fill me-2"></i> <%= message %>
            </div>
        <% } %>

        <form action="labForm.jsp" method="POST">
            <input type="hidden" name="labId" value="<%= (lab != null) ? lab.labId : "" %>">

            <div class="horizontal-card">
                <div class="section-header">
                    <i class="bi bi-info-square me-2 text-primary"></i> Facility Specifications
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Laboratory Name</label>
                    <div class="col-sm-8">
                        <input type="text" name="labName" class="form-control" 
                               placeholder="e.g. Central Diagnostic Center" 
                               value="<%= (lab != null) ? lab.labName : "" %>" required>
                    </div>
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Full Location</label>
                    <div class="col-sm-8">
                        <input type="text" name="location" class="form-control" 
                               placeholder="Street Address, City, State"
                               value="<%= (lab != null) ? lab.location : "" %>">
                    </div>
                </div>

                <div class="row mb-0">
                    <label class="col-sm-2 form-label text-sm-end">Accreditation</label>
                    <div class="col-sm-8">
                        <input type="text" name="accreditation" class="form-control" 
                               placeholder="e.g. ISO 15189, NABL Certified"
                               value="<%= (lab != null) ? lab.accreditation : "" %>">
                        <div class="form-text mt-2 small text-muted">Enter official certification codes or names.</div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end align-items-center gap-3 mb-5">
                <a href="manageLabs.jsp" class="btn btn-cancel">Discard Changes</a>
                <button type="submit" class="btn btn-primary btn-save text-white">
                    <i class="bi bi-check2-circle me-2"></i>
                    <%= isEdit ? "Update Laboratory" : "Register Facility" %>
                </button>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>