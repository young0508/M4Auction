package com.auction.charge;
import com.auction.dao.AdminDAO;
import static com.auction.common.JDBCTemplate.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
@WebServlet("/admin/chargeAction")
public class AdminChargeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 파라미터 확인
        int reqId = Integer.parseInt(request.getParameter("reqId"));
        String action = request.getParameter("action");

        System.out.println("[Servlet 호출됨] reqId = " + reqId + ", action = " + action);  // << 이거 꼭 추가

        Connection conn = getConnection();
        AdminDAO dao = new AdminDAO();
        int result = 0;

        if("approve".equals(action)) {
            result = dao.approveCharge(conn, reqId);
            System.out.println("→ approveCharge() 결과: " + result); // ✅ 이것도
        } else if("reject".equals(action)) {
            result = dao.rejectCharge(conn, reqId);
            System.out.println("→ rejectCharge() 결과: " + result);
        }

        if(result > 0) {
            commit(conn);
            System.out.println("→ 커밋 완료");
        } else {
            rollback(conn);
            System.out.println("→ 롤백 발생");
        }

        close(conn);
        response.sendRedirect(request.getContextPath() + "/admin/adminPage.jsp");
    }
}