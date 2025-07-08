<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %> 
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    // 로그인 검증
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/luxury-login.jsp");
        return;
    }

 // 삭제할 인덱스 파라미터
    String idxParam = request.getParameter("index");
    try {
        int index = Integer.parseInt(idxParam);

        // DB에서 삭제
        Connection conn = getConnection();
        PreparedStatement pstmt = null;
        
        String sql = "DELETE FROM INTEREST_PRODUCT WHERE MEMBER_ID = ? AND interest_name = (SELECT interest_name FROM INTEREST_PRODUCT WHERE MEMBER_ID = ? FETCH FIRST 1 ROWS ONLY)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, loginUser.getMemberId());
        pstmt.setString(2, loginUser.getMemberId());
        pstmt.executeUpdate();
        
        // 세션에서 리스트 로드
        List<String> interestItems = (List<String>) session.getAttribute("interestItems");
        if (interestItems != null && index >= 0 && index < interestItems.size()) {
            interestItems.remove(index);
            session.setAttribute("interestItems", interestItems);
        }

        close(pstmt);
        close(conn);
    } catch (NumberFormatException | SQLException e) {
        e.printStackTrace();
    }


    // 갱신된 페이지로 리다이렉트
    response.sendRedirect("interestPage.jsp");
%>
