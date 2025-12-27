package servlet;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.SellerDAO;
import model.Seller;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String portId = request.getParameter("port_id");
        String password = request.getParameter("password");

        SellerDAO dao = new SellerDAO();
        Seller seller = dao.loginSeller(portId, password);

        if (seller != null) {
            request.getSession().setAttribute("seller", seller);
            response.sendRedirect(request.getContextPath() + "/product.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
        }
    }
}
