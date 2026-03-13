<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String username = (String) session.getAttribute("username");
String email = (String) session.getAttribute("email");

if(username == null){
    response.sendRedirect("login.jsp");
    return;
}

double totalIncome = 0;
double totalExpense = 0;
double remaining = 0;
double budget = 0;


double monthlyIncome = 0;
double monthlyExpense = 0;

String categories = "";
String amounts = "";

try{

Connection con = DBConnection.getConnection();

/* TOTAL INCOME & EXPENSE */

PreparedStatement psTotals = con.prepareStatement(
"SELECT type, SUM(amount) as total FROM transactions WHERE email=? GROUP BY type");

psTotals.setString(1,email);

ResultSet rsTotals = psTotals.executeQuery();

while(rsTotals.next()){

String type = rsTotals.getString("type");

if(type.equalsIgnoreCase("income")){
totalIncome = rsTotals.getDouble("total");
}else{
totalExpense = rsTotals.getDouble("total");
}

}

remaining = totalIncome - totalExpense;
/* MONTHLY INCOME */

PreparedStatement psMonthlyIncome = con.prepareStatement(
"SELECT SUM(amount) FROM transactions WHERE email=? AND type='income' AND MONTH(date)=MONTH(CURDATE()) AND YEAR(date)=YEAR(CURDATE())");

psMonthlyIncome.setString(1,email);

ResultSet rsMonthlyIncome = psMonthlyIncome.executeQuery();

if(rsMonthlyIncome.next()){
monthlyIncome = rsMonthlyIncome.getDouble(1);
}


/* MONTHLY EXPENSE */

PreparedStatement psMonthlyExpense = con.prepareStatement(
"SELECT SUM(amount) FROM transactions WHERE email=? AND type='expense' AND MONTH(date)=MONTH(CURDATE()) AND YEAR(date)=YEAR(CURDATE())");

psMonthlyExpense.setString(1,email);

ResultSet rsMonthlyExpense = psMonthlyExpense.executeQuery();

if(rsMonthlyExpense.next()){
monthlyExpense = rsMonthlyExpense.getDouble(1);
}

/* GET BUDGET */

PreparedStatement psBudget = con.prepareStatement(
"SELECT monthly_budget FROM budget WHERE email=? ORDER BY id DESC LIMIT 1");

psBudget.setString(1,email);

ResultSet rsBudget = psBudget.executeQuery();

if(rsBudget.next()){
budget = rsBudget.getDouble("monthly_budget");
}

/* CATEGORY EXPENSE ANALYSIS */

PreparedStatement psCategory = con.prepareStatement(
"SELECT category, SUM(amount) as total FROM transactions WHERE email=? AND type='expense' GROUP BY category");

psCategory.setString(1,email);

ResultSet rsCategory = psCategory.executeQuery();

while(rsCategory.next()){

categories += "'" + rsCategory.getString("category") + "',";
amounts += rsCategory.getDouble("total") + ",";

}

con.close();

}catch(Exception e){
e.printStackTrace();
}

%>

<!DOCTYPE html>
<html>

<head>

<title>Dashboard - BudgetWise</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
background:#f4f6f9;
}

.sidebar{
height:100vh;
background:#1e1e2f;
color:white;
padding:20px;
}

.sidebar a{
color:#cfcfcf;
display:block;
padding:10px;
text-decoration:none;
}

.sidebar a:hover{
background:#343a40;
color:white;
}

.card-box{
border-radius:12px;
padding:20px;
color:white;
}

</style>

</head>

<body>

<div class="container-fluid">
<div class="row">

<div class="col-md-2 sidebar">

<h4>BudgetWise</h4>
<hr>

<a href="#">Dashboard</a>
<a href="profile.jsp">Profile</a>
<a href="LogoutServlet">Logout</a>

</div>

<div class="col-md-10 p-4">

<h2>Welcome, <%=username%></h2>

<p class="text-muted">Financial Overview</p>

<div class="row mt-4">

<div class="col-md-4">

<div class="card-box bg-success">

<h5>Total Income</h5>

<h3>₹ <%=totalIncome%></h3>

</div>

</div>

<div class="col-md-4">

<div class="card-box bg-danger">

<h5>Total Expense</h5>

<h3>₹ <%=totalExpense%></h3>

</div>

</div>

<div class="col-md-4">

<div class="card-box bg-primary">

<h5>Remaining</h5>

<h3>₹ <%=remaining%></h3>

</div>

</div>

</div>

<hr class="mt-4">
<h4>Monthly Summary</h4>

<div class="row mb-4">

<div class="col-md-4">

<div class="card-box bg-info">

<h6>This Month Income</h6>

<h4>₹ <%=monthlyIncome%></h4>

</div>

</div>

<div class="col-md-4">

<div class="card-box bg-warning">

<h6>This Month Expense</h6>

<h4>₹ <%=monthlyExpense%></h4>

</div>

</div>

<div class="col-md-4">

<div class="card-box bg-dark">

<h6>This Month Balance</h6>

<h4>₹ <%=monthlyIncome - monthlyExpense%></h4>

</div>

</div>

</div>

<!-- BUDGET WARNING -->

<% if(totalExpense > budget && budget > 0){ %>

<div class="alert alert-danger">
⚠ Warning: You have exceeded your monthly budget!
</div>

<% } %>

<!-- ADD INCOME -->

<h4>Add Income</h4>

<form action="AddIncomeServlet" method="post" class="mb-4">

<div class="row">

<div class="col-md-3">
<input type="text" name="category" class="form-control" placeholder="Category" required>
</div>

<div class="col-md-2">
<input type="number" name="amount" class="form-control" placeholder="Amount" required>
</div>

<div class="col-md-3">
<input type="text" name="description" class="form-control" placeholder="Description">
</div>

<div class="col-md-2">
<input type="date" name="date" class="form-control" required>
</div>

<div class="col-md-2">
<button class="btn btn-success w-100">Add Income</button>
</div>

</div>

</form>

<!-- ADD EXPENSE -->

<h4>Add Expense</h4>

<form action="AddExpenseServlet" method="post" class="mb-4">

<div class="row">

<div class="col-md-3">
<input type="text" name="category" class="form-control" placeholder="Category" required>
</div>

<div class="col-md-2">
<input type="number" name="amount" class="form-control" placeholder="Amount" required>
</div>

<div class="col-md-3">
<input type="text" name="description" class="form-control" placeholder="Description">
</div>

<div class="col-md-2">
<input type="date" name="date" class="form-control" required>
</div>

<div class="col-md-2">
<button class="btn btn-danger w-100">Add Expense</button>
</div>

</div>

</form>

<!-- SET BUDGET -->

<h4>Set Monthly Budget</h4>

<form action="SetBudgetServlet" method="post" class="mb-4">

<div class="row">

<div class="col-md-4">
<input type="number" name="budget" class="form-control" placeholder="Enter Monthly Budget" required>
</div>

<div class="col-md-2">
<button class="btn btn-primary">Save Budget</button>
</div>

</div>

</form>

<hr>

<!-- EXPENSE ANALYSIS CHART -->

<h4>Expense Analysis</h4>

<canvas id="expenseChart" width="400" height="200"></canvas>

<hr>

<!-- RECENT TRANSACTIONS -->

<h4>Recent Transactions</h4>

<table class="table table-bordered">

<tr>

<th>Type</th>
<th>Category</th>
<th>Amount</th>
<th>Description</th>
<th>Date</th>
<th>Action</th>

</tr>

<%

try{

Connection con2 = DBConnection.getConnection();

PreparedStatement ps = con2.prepareStatement(
"SELECT * FROM transactions WHERE email=? ORDER BY date DESC LIMIT 5");

ps.setString(1,email);

ResultSet rs = ps.executeQuery();

while(rs.next()){

%>

<tr>

<td><%=rs.getString("type")%></td>

<td><%=rs.getString("category")%></td>

<td>₹ <%=rs.getDouble("amount")%></td>

<td><%=rs.getString("description")%></td>

<td><%=rs.getDate("date")%></td>

<td>

<a href="DeleteTransactionServlet?id=<%=rs.getInt("id")%>" class="btn btn-danger btn-sm">
Delete
</a>

</td>

</tr>

<%

}

con2.close();

}catch(Exception e){
e.printStackTrace();
}

%>

</table>

</div>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

var ctx = document.getElementById('expenseChart');

new Chart(ctx, {

type: 'pie',

data: {

labels: [<%=categories%>],

datasets: [{

data: [<%=amounts%>],

backgroundColor: [

'#ff6384',
'#36a2eb',
'#ffce56',
'#4caf50',
'#9c27b0',
'#ff9800'

]

}]

}

});

</script>

</body>

</html>