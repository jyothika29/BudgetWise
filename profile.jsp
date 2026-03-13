<%@ page session="true" %>
<%
String username = (String) session.getAttribute("username");

if(username == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>

<head>

<title>Profile - BudgetWise</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
background:linear-gradient(120deg,#1e3c72,#2a5298);
height:100vh;
display:flex;
justify-content:center;
align-items:center;
font-family:Arial;
}

.profile-card{
width:450px;
background:white;
padding:30px;
border-radius:12px;
box-shadow:0px 10px 25px rgba(0,0,0,0.2);
}

.title{
text-align:center;
margin-bottom:25px;
font-weight:bold;
}

</style>

</head>

<body>

<div class="profile-card">

<h3 class="title">Profile Details</h3>

<form action="ProfileServlet" method="post">

<div class="mb-3">

<label class="form-label">Monthly Income</label>

<input type="number" name="income" class="form-control" required>

</div>

<div class="mb-3">

<label class="form-label">Monthly Savings</label>

<input type="number" name="savings" class="form-control" required>

</div>

<div class="mb-3">

<label class="form-label">Target Expenses</label>

<input type="number" name="expenses" class="form-control" required>

</div>

<button class="btn btn-primary w-100">

Save Profile

</button>

</form>

<div class="text-center mt-3">

<a href="home.jsp">Back to Dashboard</a>

</div>

</div>

</body>

</html>