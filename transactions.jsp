<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" %>


<%
    String email = (String) session.getAttribute("email");

    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Transactions - BudgetWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="container mt-4">

<h2 class="mb-4">Transactions</h2>

<!-- ================== ADD INCOME ================== -->
<h4>Add Income</h4>
<form action="AddIncomeServlet" method="post" class="mb-4">
    <input type="text" name="category" class="form-control mb-2" placeholder="Category (Salary, Bonus...)" required>
    <input type="number" step="0.01" name="amount" class="form-control mb-2" placeholder="Amount" required>
    <input type="text" name="description" class="form-control mb-2" placeholder="Description">
    <input type="date" name="date" class="form-control mb-2" required>
    <button class="btn btn-success">Add Income</button>
</form>

<hr>

<!-- ================== ADD EXPENSE ================== -->
<h4>Add Expense</h4>
<form action="AddExpenseServlet" method="post" class="mb-4">
    <input type="text" name="category" class="form-control mb-2" placeholder="Category (Food, Travel...)" required>
    <input type="number" step="0.01" name="amount" class="form-control mb-2" placeholder="Amount" required>
    <input type="text" name="description" class="form-control mb-2" placeholder="Description">
    <input type="date" name="date" class="form-control mb-2" required>
    <button class="btn btn-danger">Add Expense</button>
</form>

<hr>

<!-- ================== TRANSACTION LIST ================== -->
<h4>Your Transactions</h4>

<table class="table table-bordered table-striped">
    <tr>
        <th>Type</th>
        <th>Category</th>
        <th>Amount</th>
        <th>Description</th>
        <th>Date</th>
    </tr>

<%
    try {
        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM transactions WHERE email=? ORDER BY date DESC"
        );

        ps.setString(1, email);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
%>

<tr>
    <td><%= rs.getString("type") %></td>
    <td><%= rs.getString("category") %></td>
    <td>₹ <%= rs.getDouble("amount") %></td>
    <td><%= rs.getString("description") %></td>
    <td><%= rs.getDate("date") %></td>
</tr>

<%
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

</table>

<br>
<a href="home.jsp" class="btn btn-primary">Back to Dashboard</a>

</body>
</html>