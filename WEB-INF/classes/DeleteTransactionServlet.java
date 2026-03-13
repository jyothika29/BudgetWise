import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/DeleteTransactionServlet")
public class DeleteTransactionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM transactions WHERE id=?"
            );

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();

            response.sendRedirect("home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}