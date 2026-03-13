import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import util.DBConnection;

@WebServlet("/AddIncomeServlet")
public class AddIncomeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) request.getSession().getAttribute("email");
        String category = request.getParameter("category");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String description = request.getParameter("description");
        String date = request.getParameter("date");

        try {
            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO transactions (email, type, category, amount, description, date) VALUES (?, 'income', ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, email);
            ps.setString(2, category);
            ps.setDouble(3, amount);
            ps.setString(4, description);
            ps.setString(5, date);

            ps.executeUpdate();

            response.sendRedirect("transactions.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}