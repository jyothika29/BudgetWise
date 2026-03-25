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

/* FILTER PARAMETERS */
String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
String categoryFilter = request.getParameter("category");

try{

Connection con = DBConnection.getConnection();

/* TOTALS */
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
"SELECT SUM(amount) FROM transactions WHERE email=? AND type='income' AND MONTH(date)=MONTH(CURDATE())");

psMonthlyIncome.setString(1,email);
ResultSet rsMonthlyIncome = psMonthlyIncome.executeQuery();

if(rsMonthlyIncome.next()){
monthlyIncome = rsMonthlyIncome.getDouble(1);
}

/* MONTHLY EXPENSE */
PreparedStatement psMonthlyExpense = con.prepareStatement(
"SELECT SUM(amount) FROM transactions WHERE email=? AND type='expense' AND MONTH(date)=MONTH(CURDATE())");

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

/* CATEGORY CHART */
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
body{background:#f4f6f9;}
.sidebar{height:100vh;background:#1e1e2f;color:white;padding:20px;}
.sidebar a{color:#cfcfcf;display:block;padding:10px;text-decoration:none;}
.sidebar a:hover{background:#343a40;color:white;}
.card-box{border-radius:12px;padding:20px;color:white;}
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
<a href="reports.jsp">Reports</a>
<a href="LogoutServlet">Logout</a>
</div>

<div class="col-md-10 p-4">

<h2>Welcome, <%=username%></h2>

<!-- FILTER SECTION -->

<h4>Filter Transactions</h4>

<form method="get" class="mb-4">
<div class="row">

<div class="col-md-3">
<input type="date" name="fromDate" class="form-control">
</div>

<div class="col-md-3">
<input type="date" name="toDate" class="form-control">
</div>

<div class="col-md-3">
<input type="text" name="category" class="form-control" placeholder="Category">
</div>

<div class="col-md-3">
<button class="btn btn-primary w-100">Filter</button>
</div>

</div>
</form>

<hr>

<!-- ✅ STEP 2.3 BUTTON ADDED -->

<a href="ExportServlet" class="btn btn-success mb-3">
Download CSV
</a>

<!-- TRANSACTIONS -->

<h4>Transactions</h4>

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

/* DYNAMIC QUERY */

String query = "SELECT * FROM transactions WHERE email=?";

if(fromDate != null && !fromDate.equals("")){
query += " AND date >= '" + fromDate + "'";
}

if(toDate != null && !toDate.equals("")){
query += " AND date <= '" + toDate + "'";
}

if(categoryFilter != null && !categoryFilter.equals("")){
query += " AND category LIKE '%" + categoryFilter + "%'";
}

query += " ORDER BY date DESC";

PreparedStatement ps = con2.prepareStatement(query);
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
<a href="DeleteTransactionServlet?id=<%=rs.getInt("id")%>" class="btn btn-danger btn-sm">Delete</a>
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

</body>
</html>