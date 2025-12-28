package servlet;

import dao.ReportDAO;
import model.Report;
import model.Seller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ReportServlet", urlPatterns = {"/dashboard/reports"})
public class ReportServlet extends HttpServlet {

    private final ReportDAO dao = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Seller sellerObj = (s == null) ? null : (Seller) s.getAttribute("seller");
        if (sellerObj == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=Please+login");
            return;
        }

        String sellerPortId = sellerObj.getPortId();

        String action = req.getParameter("action");
        if ("view".equals(action)) {
            view(req, resp, sellerPortId);
            return;
        }
        list(req, resp, sellerPortId);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Seller sellerObj = (s == null) ? null : (Seller) s.getAttribute("seller");
        if (sellerObj == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=Please+login");
            return;
        }

        String sellerPortId = sellerObj.getPortId();

        String action = req.getParameter("action");
        if ("resolve".equals(action)) {
            int id = parseInt(req.getParameter("report_id"), 0);
            try {
                boolean ok = dao.resolve(id, sellerPortId);
                req.getSession().setAttribute("flash",
                   ok ? ("Report #" + id + " marked resolved.") : "Unable to resolve report.");
                resp.sendRedirect(req.getContextPath() + "/dashboard/reports");
            } catch (SQLException e) {
                throw new ServletException(e);
            }
            return;
        }
        resp.sendError(400, "Unsupported action");
    }

    private void list(HttpServletRequest req, HttpServletResponse resp, String sellerPortId)
            throws ServletException, IOException {
        String status = defaultStr(req.getParameter("status"), "");
        String q = defaultStr(req.getParameter("q"), "");
        int page = parseInt(req.getParameter("page"), 1);
        int size = Math.min(50, parseInt(req.getParameter("size"), 10));
        String sort = defaultStr(req.getParameter("sort"), "reported_at");
        String dir = defaultStr(req.getParameter("dir"), "DESC");

        try {
            List<Report> reports = dao.listBySeller(sellerPortId, status, q, page, size, sort, dir);
            int total = dao.countBySeller(sellerPortId, status, q);
            req.setAttribute("reports", reports);
            req.setAttribute("total", total);
            req.setAttribute("page", page);
            req.setAttribute("size", size);
            req.setAttribute("status", status);
            req.setAttribute("q", q);
            req.setAttribute("sort", sort);
            req.setAttribute("dir", dir);
            req.getRequestDispatcher("/dashboard/reports.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void view(HttpServletRequest req, HttpServletResponse resp, String sellerPortId)
            throws ServletException, IOException {
        int id = parseInt(req.getParameter("id"), 0);
        try {
            Report r = dao.findOne(id, sellerPortId);
            if (r == null) { 
                resp.sendError(404); 
                return; 
            }
            req.setAttribute("report", r);
            req.getRequestDispatcher("/dashboard/report_view.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private static String defaultStr(String s, String d) { return (s == null) ? d : s; }
}
