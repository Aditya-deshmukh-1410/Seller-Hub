package servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Product_pojo;
import model.Seller;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");

        HttpSession session = req.getSession(false);

        // ✅ Get seller from session
        Seller seller = (session != null) ? (Seller) session.getAttribute("seller") : null;
        if (seller == null) {
            resp.sendRedirect("login.jsp?error=Please login first");
            return;
        }

        String sellerPortId = seller.getPortId(); // <-- use your Seller model's getter

        // ✅ Identify action
        String action = req.getParameter("action");
        Product_pojo pojo = new Product_pojo();
        pojo.setSeller_port_id(sellerPortId);

        // ✅ Corrected parameter names and trimming
        pojo.setProductname(req.getParameter("product_name").trim());
        pojo.setDescription(req.getParameter("description").trim());

        try {
            pojo.setQuantity(Integer.parseInt(req.getParameter("quantity")));
            pojo.setPrice(Double.parseDouble(req.getParameter("price"))); 
        } catch (NumberFormatException e) {
            resp.sendRedirect("product.jsp?error=Invalid number format");
            return;
        }

        try {
            if ("add".equals(action)) {
                pojo.addProduct();
                resp.sendRedirect("product.jsp?msg=Product Added Successfully");
            } else if ("update".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("product_id"));
                pojo.setProductId(productId);
                pojo.updateProduct();
                resp.sendRedirect("product.jsp?msg=Product Updated Successfully");
            } else if ("delete".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("product_id"));
                pojo.setProductId(productId);
                pojo.deleteProduct();
                resp.sendRedirect("product.jsp?msg=Product Deleted Successfully");
            } else {
                resp.sendRedirect("product.jsp?error=Unknown action");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // log in server
            resp.sendRedirect("product.jsp?error=Something went wrong, please try again");
        }
    }
}
