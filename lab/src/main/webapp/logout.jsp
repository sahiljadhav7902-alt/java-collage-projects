<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout - Pathology Lab System</title>
    <style>
        body {
            background: linear-gradient(135deg, #dfe9f3, #ffffff);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
        }
        .logout-container {
            text-align: center;
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .logout-icon {
            font-size: 4rem;
            color: #3498db;
            margin-bottom: 1rem;
        }
        .logout-title {
            font-size: 1.5rem;
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        .logout-message {
            color: #7f8c8d;
            margin-bottom: 1.5rem;
        }
        .btn-login {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
        }
        .btn-login:hover {
            background-color: #2980b9;
            color: white;
        }
    </style>
</head>
<body>

<div class="logout-container">
    <div class="logout-icon">
        <i class="bi bi-box-arrow-right"></i>
    </div>
    <div class="logout-title">You have been logged out</div>
    <div class="logout-message">Thank you for using Pathology Lab System</div>
    <a href="login.jsp" class="btn btn-login">Login Again</a>
</div>

<%
    // Invalidate the session
    session.invalidate();
    

    // Redirect to login page
    response.sendRedirect("login.jsp");
%>

</body>
</html>