<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - BudgetWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(to right, #1d2b64, #f8cdda);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .card {
            width: 400px;
            padding: 25px;
            border-radius: 15px;
        }
    </style>
</head>
<body>

<div class="card shadow">

    <h3 class="text-center mb-4">BudgetWise</h3>

    <!-- LOGIN FORM -->
    <form action="LoginServlet" method="post">
        <div class="mb-3">
            <input type="email" name="email" class="form-control" placeholder="Email" required>
        </div>

        <div class="mb-3">
            <input type="password" name="password" class="form-control" placeholder="Password" required>
        </div>

        <button class="btn btn-primary w-100">Login</button>
    </form>

    <hr>

    <p class="text-center">
        Don't have an account?
        <a href="signup.jsp">Create New Account</a>
    </p>

</div>

</body>
</html>