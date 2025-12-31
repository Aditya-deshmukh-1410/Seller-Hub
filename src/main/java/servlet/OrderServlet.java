package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.OrdersDAO;
import model.Order;
import model.Seller;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Seller seller = (Seller) req.getSession().getAttribute("seller");
        if (seller == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String sellerPortId = seller.getPortId();

        try {
            OrdersDAO ordersDAO = new OrdersDAO();
            List<Order> orders = ordersDAO.getOrdersBySeller(sellerPortId);

            req.setAttribute("orders", orders);
            req.getRequestDispatcher("order.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error loading orders", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Seller seller = (Seller) req.getSession().getAttribute("seller");
        if (seller == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String orderIdStr = req.getParameter("order_id");
        String status = req.getParameter("status");

        if (orderIdStr == null || status == null || status.isBlank()) {
            resp.sendRedirect("OrderServlet?error=Invalid request");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("OrderServlet?error=Invalid order id");
            return;
        }

        try {
            OrdersDAO ordersDAO = new OrdersDAO();
            boolean updated = ordersDAO.updateStatus(
                    orderId,
                    seller.getPortId(),
                    status
            );

            if (updated) {
                resp.sendRedirect("OrderServlet?msg=Order updated successfully");
            } else {
                resp.sendRedirect("OrderServlet?error=Order not found or unauthorized");
            }

        } catch (SQLException e) {
            throw new ServletException("Error updating order", e);
        }
    }
}
