import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import util.DBConnection;

@WebServlet("/ExportServlet")
public class ExportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=transactions.csv");

        PrintWriter out = response.getWriter();

        out.println("Type,Category,Amount,Description,Date");

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM transactions WHERE email=? ORDER BY date DESC");

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                out.println(
                        rs.getString("type") + "," +
                        rs.getString("category") + "," +
                        rs.getDouble("amount") + "," +
                        rs.getString("description") + "," +
                        rs.getDate("date")
                );
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        out.close();
    }
}