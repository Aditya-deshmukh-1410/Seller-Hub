package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.SellerDAO;
import model.Seller;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String portId = request.getParameter("port_id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String location = request.getParameter("location");
        String password = request.getParameter("password");

        Seller seller = new Seller(portId, name, email, location, password);

        SellerDAO dao = new SellerDAO();
        String result = dao.registerSeller(seller);

        switch (result) {
            case "SUCCESS":
                response.sendRedirect("login.jsp?success=true");
                break;

            case "DUPLICATE":
                request.setAttribute("errorMsg", "❌ Port ID already exists. Please choose another one.");
                request.setAttribute("seller", seller);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                break;

            default:
                request.setAttribute("errorMsg", "⚠️ Something went wrong. Please try again later.");
                request.setAttribute("seller", seller);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                break;
        }
    }
}
