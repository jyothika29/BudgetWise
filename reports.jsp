<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page session="true" %>

<%

String email = (String) session.getAttribute("email");

if(email == null){
response.sendRedirect("login.jsp");
return;
}

/* PIE CHART DATA */

String categories="";
String amounts="";

/* MONTHLY CHART DATA */

String months="";
String incomeData="";
String expenseData="";

try{

Connection con = DBConnection.getConnection();

/* CATEGORY WISE EXPENSE */

PreparedStatement ps = con.prepareStatement(
"SELECT category, SUM(amount) total FROM transactions WHERE email=? AND type='expense' GROUP BY category"
);

ps.setString(1,email);

ResultSet rs = ps.executeQuery();

while(rs.next()){

categories += "'" + rs.getString("category") + "',";
amounts += rs.getDouble("total") + ",";

}


/* MONTHLY INCOME VS EXPENSE */

PreparedStatement ps2 = con.prepareStatement(
"SELECT MONTH(date) as month, " +
"SUM(CASE WHEN type='income' THEN amount ELSE 0 END) as income, " +
"SUM(CASE WHEN type='expense' THEN amount ELSE 0 END) as expense " +
"FROM transactions WHERE email=? GROUP BY MONTH(date)"
);

ps2.setString(1,email);

ResultSet rs2 = ps2.executeQuery();

while(rs2.next()){

months += "'" + rs2.getInt("month") + "',";
incomeData += rs2.getDouble("income") + ",";
expenseData += rs2.getDouble("expense") + ",";

}

con.close();

}catch(Exception e){
e.printStackTrace();
}

%>

<!DOCTYPE html>
<html>

<head>

<title>Reports - BudgetWise</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>

<body>

<div class="container mt-5">

<h2 class="mb-4">Expense Report</h2>

<div class="row">

<div class="col-md-6">
<h4>Category Wise Expense</h4>
<canvas id="expenseChart"></canvas>
</div>

<div class="col-md-6">
<h4>Monthly Income vs Expense</h4>
<canvas id="monthlyChart"></canvas>
</div>

</div>

<!-- STEP 4 : TOP SPENDING TABLE -->

<hr class="mt-5">

<h3>Top Spending Categories</h3>

<table class="table table-bordered table-striped">

<tr>
<th>Category</th>
<th>Total Spent</th>
</tr>

<%

try{

Connection con3 = DBConnection.getConnection();

PreparedStatement ps3 = con3.prepareStatement(
"SELECT category, SUM(amount) total FROM transactions WHERE email=? AND type='expense' GROUP BY category ORDER BY total DESC"
);

ps3.setString(1,email);

ResultSet rs3 = ps3.executeQuery();

while(rs3.next()){

%>

<tr>

<td><%=rs3.getString("category")%></td>

<td>₹ <%=rs3.getDouble("total")%></td>

</tr>

<%

}

con3.close();

}catch(Exception e){
e.printStackTrace();
}

%>

</table>

</div>

<!-- PIE CHART -->

<script>

const ctx = document.getElementById('expenseChart');

new Chart(ctx, {

type: 'pie',

data: {

labels: [<%=categories%>],

datasets: [{

label: 'Expenses',

data: [<%=amounts%>],

backgroundColor: [
'red',
'blue',
'green',
'orange',
'purple',
'yellow'
]

}]

}

});

</script>

<!-- MONTHLY BAR CHART -->

<script>

const ctx2 = document.getElementById('monthlyChart');

new Chart(ctx2, {

type: 'bar',

data: {

labels: [<%=months%>],

datasets: [

{
label: 'Income',
data: [<%=incomeData%>],
backgroundColor: 'green'
},

{
label: 'Expense',
data: [<%=expenseData%>],
backgroundColor: 'red'
}

]

}

});

</script>

</body>

</html>