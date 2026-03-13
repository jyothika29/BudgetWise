import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String income = request.getParameter("income");
        String savings = request.getParameter("savings");
        String expenses = request.getParameter("expenses");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        try {
            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO profile (email, monthly_income, monthly_savings, target_expenses) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, email);
            ps.setDouble(2, Double.parseDouble(income));
            ps.setDouble(3, Double.parseDouble(savings));
            ps.setDouble(4, Double.parseDouble(expenses));

            ps.executeUpdate();

            response.sendRedirect("home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}