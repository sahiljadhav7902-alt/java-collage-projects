<%@ page contentType="text/html;charset=UTF-8" language="java" buffer="32kb" autoFlush="true" %>
<%@ page import="com.mycompany.lab.BllUserMaster" %>

<%
    String errorMessage = "";
    String email = "";

    // Handle POST login (LOGIC UNTOUCHED)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        email = request.getParameter("email");
        String password = request.getParameter("password");

        BllUserMaster bll = new BllUserMaster();
        BllUserMaster user = bll.loginUser(email, password);

        if (user != null) {
            HttpSession sessionObj = request.getSession();
            sessionObj.setAttribute("userId", user.getUserId());
            sessionObj.setAttribute("userRole", user.getUserType());
            sessionObj.setAttribute("userName", user.getFullName());

            String context = request.getContextPath();

            if ("PATIENT".equalsIgnoreCase(user.getUserType())) {
                response.sendRedirect(context + "/patient/patientDashboard.jsp");
                return;
            } 
            else if ("physician".equalsIgnoreCase(user.getUserType())) {
                response.sendRedirect(context + "/doctor/doctorDashboard.jsp");
                return;
            } 
            else if ("admin".equalsIgnoreCase(user.getUserType())) {
                response.sendRedirect(context + "/admin/adminDashboard.jsp");
                return;
            } 
            else {
                errorMessage = "Unknown user type.";
            }
        } else {
            errorMessage = "Invalid Email or Password!";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Pathology Lab System</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #0561FC;
            --secondary-teal: #00d2ff;
            --bg-gradient: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg-gradient);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .login-card {
            background: #ffffff;
            padding: 40px;
            border-radius: 24px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .brand-logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand-logo i {
            font-size: 2.5rem;
            background: linear-gradient(45deg, var(--primary-blue), var(--secondary-teal));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        h2 {
            font-weight: 700;
            color: #1e293b;
            text-align: center;
            margin-bottom: 8px;
        }

        .subtitle {
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 30px;
        }

        /* Form Controls */
        .form-label {
            font-weight: 500;
            font-size: 0.85rem;
            color: #475569;
        }

        .input-group-text {
            background: transparent;
            border-right: none;
            color: #94a3b8;
        }

        .form-control {
            border-left: none;
            padding: 12px;
            border-radius: 10px;
            font-size: 0.95rem;
        }

        .form-control:focus {
            box-shadow: none;
            border-color: #dee2e6;
        }

        .input-group:focus-within {
            box-shadow: 0 0 0 4px rgba(5, 97, 252, 0.1);
            border-radius: 10px;
        }

        .input-group:focus-within .input-group-text,
        .input-group:focus-within .form-control {
            border-color: var(--primary-blue);
            color: var(--primary-blue);
        }

        /* Button */
        .btn-login {
            background: var(--primary-blue);
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 600;
            width: 100%;
            margin-top: 10px;
            transition: 0.3s;
        }

        .btn-login:hover {
            background: #044ecb;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(5, 97, 252, 0.3);
        }

        .error-alert {
            font-size: 0.85rem;
            border-radius: 10px;
            border: none;
            background-color: #fef2f2;
            color: #dc2626;
            margin-bottom: 20px;
        }

        .footer-links {
            text-align: center;
            margin-top: 25px;
            font-size: 0.85rem;
        }

        .footer-links a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
        }

        .back-home {
            position: absolute;
            top: 20px;
            left: 20px;
            color: #64748b;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <a href="index.jsp" class="back-home">
        <i class="bi bi-arrow-left me-2"></i> Back to Home
    </a>

    <div class="login-card">
        <div class="brand-logo">
            <i class="bi bi-heart-pulse-fill"></i>
        </div>
        
        <h2>Welcome Back</h2>
        <p class="subtitle">Enter your credentials to access your account</p>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger error-alert d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <div><%= errorMessage %></div>
            </div>
        <% } %>

        <form method="post" action="login.jsp">
            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" 
                           placeholder="name@example.com" value="<%= email %>" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" class="form-control" 
                           placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-login text-white">
                Sign In
            </button>
        </form>

        <div class="footer-links">
            <p class="text-muted">Don't have an account? <a href="patient/register.jsp">Register Now</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>