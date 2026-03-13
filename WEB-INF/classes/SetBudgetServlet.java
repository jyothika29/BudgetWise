import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/SetBudgetServlet")
public class SetBudgetServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        double budget = Double.parseDouble(request.getParameter("budget"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO budget(email, monthly_budget) VALUES(?, ?)"
            );

            ps.setString(1, email);
            ps.setDouble(2, budget);

            ps.executeUpdate();

            con.close();

            response.sendRedirect("home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}