package servlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.OrdersDAO;
import model.Order;
import model.Seller;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private OrdersDAO ordersDAO;
    
    @Override
    public void init() throws ServletException {
        try {
			ordersDAO = new OrdersDAO();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  // ✅ now initialized
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        // ✅ Ensure seller is logged in
        Seller seller = (Seller) req.getSession().getAttribute("seller");
        if (seller == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String sellerPortId = seller.getPortId();

        try {
            // ✅ Fetch orders from DB
            List<Order> orders = ordersDAO.getOrdersBySeller(sellerPortId);

            // ✅ Send to JSP
            req.setAttribute("orders", orders);
            RequestDispatcher rd = req.getRequestDispatcher("order.jsp");
            rd.forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error loading orders", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // ✅ Read params safely
        int orderId = Integer.parseInt(req.getParameter("order_id"));
        String status = req.getParameter("status");

        // ✅ Ensure seller is logged in
        Seller seller = (Seller) req.getSession().getAttribute("seller");
        if (seller == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            // ✅ Update order status
            ordersDAO.updateStatus(orderId, status);

            // ✅ Redirect back to orders list
            resp.sendRedirect("OrderServlet?msg=Order Updated Successfully");


        } catch (SQLException e) {
            throw new ServletException("Error updating order", e);
        }
    }
}
