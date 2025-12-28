package servlet;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.SellerDAO;
import model.Seller;


@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        String portId = request.getParameter("port_id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String location = request.getParameter("location");
        String password = request.getParameter("password");

        Seller seller = new Seller(portId, name, email, location, password);
        SellerDAO dao = new SellerDAO();
        dao.updateSeller(seller);

        request.getSession().setAttribute("seller", seller);
        response.sendRedirect("dashboard.jsp");
    }
}
