<!DOCTYPE html>
<html>
<head>

<title>Signup - BudgetWise</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
background: linear-gradient(120deg,#1e3c72,#2a5298);
height:100vh;
display:flex;
justify-content:center;
align-items:center;
font-family:Arial;
}

.signup-card{
width:400px;
padding:30px;
border-radius:10px;
background:white;
box-shadow:0px 10px 25px rgba(0,0,0,0.2);
}

.title{
text-align:center;
margin-bottom:20px;
font-weight:bold;
}

</style>

</head>

<body>

<div class="signup-card">

<h3 class="title">Create Account</h3>

<form action="SignupServlet" method="post">

<div class="mb-3">
<label class="form-label">Username</label>
<input type="text" name="username" class="form-control" required>
</div>

<div class="mb-3">
<label class="form-label">Email</label>
<input type="email" name="email" class="form-control" required>
</div>

<div class="mb-3">
<label class="form-label">Password</label>
<input type="password" name="password" class="form-control" required>
</div>

<div class="mb-3">
<label class="form-label">Role</label>
<select name="role" class="form-select">
<option value="USER">USER</option>
<option value="ADMIN">ADMIN</option>
</select>
</div>

<button type="submit" class="btn btn-primary w-100">
Sign Up
</button>

</form>

<div class="text-center mt-3">

Already have an account?  
<a href="login.jsp">Login</a>

</div>

</div>

</body>
</html>