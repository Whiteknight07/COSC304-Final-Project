<!DOCTYPE html>
<html>
<head>
    <title>Login - YOUR NAME Grocery</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .login-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            width: 90%;
            max-width: 400px;
            margin: 2rem auto;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-header h1 {
            color: #333;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .error-message {
            background-color: #ffe6e6;
            color: #d63031;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 1rem;
            text-align: center;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-control:focus {
            border-color: #28a745;
            outline: none;
            box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.2);
        }

        .btn-login {
            width: 100%;
            padding: 0.75rem;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-login:hover {
            background-color: #218838;
        }

        .additional-links {
            text-align: center;
            margin-top: 1.5rem;
        }

        .additional-links a {
            color: #666;
            text-decoration: none;
            font-size: 0.9rem;
        }

        .additional-links a:hover {
            color: #28a745;
        }

        @media (max-width: 480px) {
            .login-container {
                margin: 1rem auto;
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="login-container">
    <div class="login-header">
        <h1>Welcome Back</h1>
        <p>Please login to your account</p>
    </div>

    <%
    if (session.getAttribute("loginMessage") != null) {
        out.println("<div class='error-message'>" + session.getAttribute("loginMessage").toString() + "</div>");
    }
    %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-control" maxlength="10" required>
        </div>
        
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" class="form-control" maxlength="10" required>
        </div>

        <button type="submit" class="btn-login">Log In</button>
    </form>

    <div class="additional-links">
        <a href="register.jsp">Create Account</a>
    </div>
</div>


</body>
</html>
