package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.SellerDAO;
import model.Seller;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        Seller seller = (Seller) request.getSession().getAttribute("seller");
        
        if (seller != null) {
            SellerDAO dao = new SellerDAO();
            dao.deleteSeller(seller.getPortId());
            
            // End session
            request.getSession().invalidate();

            // Redirect with message
            response.sendRedirect("login.jsp?deleted=1");
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
