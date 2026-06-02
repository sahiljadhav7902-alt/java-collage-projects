<%@ page import="com.mycompany.lab.BllPhysician" %>

<%
    // LOGIC PRESERVED 100%
    String message = "";
    BllPhysician bll = new BllPhysician();
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("userId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String licenseNumber = request.getParameter("licenseNumber");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");

        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            message = bll.updatePhysician(id, firstName, lastName, email, phone, address, licenseNumber, dob, gender);
        } else {
            message = bll.registerPhysician(firstName, lastName, email, password, phone, address, licenseNumber, dob, gender);
        }
    }

    BllPhysician physician = null;
    boolean isEdit = false;
    
    if (request.getParameter("editId") != null) {
        isEdit = true;
        try {
            int editId = Integer.parseInt(request.getParameter("editId"));
            physician = bll.getPhysicianById(editId);
        } catch (Exception e) {
            message = "Error loading physician data.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit" : "Add" %> Physician | PathLab</title>
    
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
            padding: 30px;
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

        .btn-save:hover {
            background-color: #044ecb;
            transform: translateY(-1px);
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <div class="container-fluid px-5 py-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark m-0"><%= isEdit ? "Update Staff Profile" : "Register Physician" %></h2>
                <p class="text-muted small mb-0">Manage professional credentials and contact details</p>
            </div>
            <a href="managePhysicians.jsp" class="btn btn-outline-secondary px-4">
                <i class="bi bi-arrow-left me-2"></i>Back
            </a>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info border-0 shadow-sm rounded-3"><%= message %></div>
        <% } %>

        <form action="physicianForm.jsp" method="POST">
            <input type="hidden" name="userId" value="<%= (physician != null) ? physician.userId : "" %>">

            <div class="horizontal-card">
                <div class="section-header">
                    <i class="bi bi-person-badge me-2 text-primary"></i> Professional Identity
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Full Name</label>
                    <div class="col-sm-4">
                        <input type="text" name="firstName" class="form-control" placeholder="First Name" 
                               value="<%= (physician != null) ? physician.firstName : "" %>" required>
                    </div>
                    <div class="col-sm-4">
                        <input type="text" name="lastName" class="form-control" placeholder="Last Name" 
                               value="<%= (physician != null) ? physician.lastName : "" %>" required>
                    </div>
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Credentials</label>
                    <div class="col-sm-8">
                        <input type="text" name="licenseNumber" class="form-control" placeholder="Medical License Number"
                               value="<%= (physician != null) ? physician.licenseNumber : "" %>">
                    </div>
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Demographics</label>
                    <div class="col-sm-4">
                        <input type="date" name="dob" class="form-control" 
                               value="<%= (physician != null) ? physician.dateOfBirth : "" %>">
                    </div>
                    <div class="col-sm-4">
                        <select name="gender" class="form-select">
                            <option value="Male" <%= (physician != null && "Male".equals(physician.gender)) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= (physician != null && "Female".equals(physician.gender)) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= (physician != null && "Other".equals(physician.gender)) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="horizontal-card">
                <div class="section-header">
                    <i class="bi bi-shield-lock me-2 text-primary"></i> Contact & System Access
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Email Address</label>
                    <div class="col-sm-8">
                        <input type="email" name="email" class="form-control" 
                               value="<%= (physician != null) ? physician.email : "" %>" required>
                    </div>
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Phone Number</label>
                    <div class="col-sm-8">
                        <input type="text" name="phone" class="form-control" 
                               value="<%= (physician != null) ? physician.phone : "" %>">
                    </div>
                </div>

                <div class="row mb-4">
                    <label class="col-sm-2 form-label text-sm-end">Portal Access</label>
                    <div class="col-sm-8">
                        <% if (!isEdit) { %>
                            <input type="password" name="password" class="form-control" placeholder="Set Initial Password" required>
                        <% } else { %>
                            <input type="password" class="form-control bg-light" disabled placeholder="Password updates restricted to Security module">
                        <% } %>
                    </div>
                </div>

                <div class="row mb-0">
                    <label class="col-sm-2 form-label text-sm-end">Clinic Address</label>
                    <div class="col-sm-8">
                        <input type="text" name="address" class="form-control" 
                               value="<%= (physician != null) ? physician.address : "" %>">
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-3 mb-5">
                <a href="managePhysicians.jsp" class="btn btn-light px-5 border">Discard Changes</a>
                <button type="submit" class="btn btn-primary btn-save text-white shadow-sm">
                    <i class="bi bi-check2-circle me-2"></i> <%= isEdit ? "Update Staff Member" : "Register Physician" %>
                </button>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>