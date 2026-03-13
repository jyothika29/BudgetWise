import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import util.DBConnection;

@WebServlet("/SignupServlet")

public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        try {

            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
            "INSERT INTO users(username,email,password,role) VALUES(?,?,?,?)");

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);

            ps.executeUpdate();

            con.close();

            response.sendRedirect("login.jsp");

        } 
        catch(Exception e){
            e.printStackTrace();
        }

    }

}