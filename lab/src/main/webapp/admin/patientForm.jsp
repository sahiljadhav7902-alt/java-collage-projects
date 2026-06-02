<%@ page import="com.mycompany.lab.BllPatient" %>

<%
    // LOGIC PRESERVED 100%
    String message = "";
    BllPatient bll = new BllPatient();
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idParam = request.getParameter("userId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String mrn = request.getParameter("mrn");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");

        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            message = bll.updatePatient(id, firstName, lastName, email, phone, address, mrn, dob, gender);
        } else {
            message = bll.registerPatient(firstName, lastName, email, password, phone, address, mrn, dob, gender);
        }
    }

    BllPatient patient = null;
    boolean isEdit = false;
    
    if (request.getParameter("editId") != null) {
        isEdit = true;
        try {
            int editId = Integer.parseInt(request.getParameter("editId"));
            patient = bll.getPatientById(editId);
        } catch (Exception e) {
            message = "Error loading patient data.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit" : "New" %> Patient | PathLab</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #0561FC;
            --slate-bg: #f8fafc;
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
            padding: 30px;
            margin-bottom: 30px;
        }

        .section-header {
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 10px;
            margin-bottom: 25px;
            font-weight: 700;
            color: #1e293b;
            display: flex;
            align-items: center;
        }

        .form-label {
            font-weight: 600;
            color: #475569;
            font-size: 0.9rem;
            margin-top: 8px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 10px 15px;
            border: 1px solid #cbd5e1;
        }

        .btn-save {
            background-color: var(--primary-blue);
            padding: 12px 40px;
            font-weight: 600;
            border-radius: 8px;
        }

        .action-bar {
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
            padding: 20px;
            margin-top: 20px;
            border-radius: 0 0 12px 12px;
        }
    </style>
</head>

<body>
    <jsp:include page="./adminNavbar.jsp" />

    <div class="container-fluid px-5 py-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold m-0"><%= isEdit ? "Edit Patient Record" : "Register New Patient" %></h2>
            <a href="managePatients.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-x-lg"></i>
            </a>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info border-0 shadow-sm"><%= message %></div>
        <% } %>

        <form action="patientForm.jsp" method="POST">
            <input type="hidden" name="userId" value="<%= (patient != null) ? patient.userId : "" %>">

            <div class="horizontal-card">
                <div class="section-header">
                    <i class="bi bi-person-vcard me-2 text-primary"></i> Personal Details
                </div>

                <div class="row mb-3">
                    <label class="col-sm-2 form-label text-sm-end">Full Name</label>
                    <div class="col-sm-4">
                        <input type="text" name="firstName" class="form-control" placeholder="First Name" 
                               value="<%= (patient != null) ? patient.firstName : "" %>" required>
                    </div>
                    <div class="col-sm-4">
                        <input type="text" name="lastName" class="form-control" placeholder="Last Name" 
                               value="<%= (patient != null) ? patient.lastName : "" %>" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-2 form-label text-sm-end">Birth & Gender</label>
                    <div class="col-sm-4">
                        <input type="date" name="dob" class="form-control" 
                               value="<%= (patient != null) ? patient.dateOfBirth : "" %>" required>
                    </div>
                    <div class="col-sm-4">
                        <select name="gender" class="form-select" required>
                            <option value="">Select Gender</option>
                            <option value="Male" <%= (patient != null && "Male".equals(patient.gender)) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= (patient != null && "Female".equals(patient.gender)) ? "selected" : "" %>>Female</option>
                        </select>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-2 form-label text-sm-end">Record ID (MRN)</label>
                    <div class="col-sm-8">
                        <input type="text" name="mrn" class="form-control" 
                               value="<%= (patient != null) ? patient.mrn : "" %>" required>
                    </div>
                </div>
            </div>

            <div class="horizontal-card">
                <div class="section-header">
                    <i class="bi bi-telephone me-2 text-primary"></i> Contact & Security
                </div>

                <div class="row mb-3">
                    <label class="col-sm-2 form-label text-sm-end">Email Address</label>
                    <div class="col-sm-8">
                        <input type="email" name="email" class="form-control" 
                               value="<%= (patient != null) ? patient.email : "" %>" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-2 form-label text-sm-end">Phone Number</label>
                    <div class="col-sm-8">
                        <input type="text" name="phone" class="form-control" 
                               value="<%= (patient != null) ? patient.phone : "" %>">
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-2 form-label text-sm-end">Account Security</label>
                    <div class="col-sm-8">
                        <% if (!isEdit) { %>
                            <input type="password" name="password" class="form-control" placeholder="Set Password" required>
                        <% } else { %>
                            <input type="password" class="form-control bg-light" disabled placeholder="Password cannot be edited here">
                        <% } %>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-2 form-label text-sm-end">Full Address</label>
                    <div class="col-sm-8">
                        <input type="text" name="address" class="form-control" 
                               value="<%= (patient != null) ? patient.address : "" %>">
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2 mb-5">
                <a href="managePatients.jsp" class="btn btn-light px-4 border">Cancel</a>
                <button type="submit" class="btn btn-primary btn-save text-white">
                    <i class="bi bi-save me-2"></i> <%= isEdit ? "Update Patient" : "Save Patient" %>
                </button>
            </div>
        </form>
    </div>

</body>
</html>