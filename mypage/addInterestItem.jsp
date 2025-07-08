<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.auction.common.JDBCTemplate" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %> 

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인된 사용자 정보 가져오기
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/luxury-login.jsp");
        return;
    }

 // 사용자가 입력한 관심 상품 이름 받기
    String itemName = request.getParameter("itemName");

    // DB 연결
    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    
    try {
        // 관심 상품 DB에 저장
        String sql = "INSERT INTO INTEREST_PRODUCT (interest_id, MEMBER_ID, interest_name, created_at) "
                   + "VALUES (SEQ_INTEREST_PRODUCT_ID.NEXTVAL, ?, ?, SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, loginUser.getMemberId());
        pstmt.setString(2, itemName);
        pstmt.executeUpdate();
        
        // 세션에서 관심 상품 목록 갱신 (DB에 반영 후 세션 업데이트)
        List<String> interestItems = (List<String>) session.getAttribute("interestItems");
        if (interestItems == null) {
            interestItems = new ArrayList<>();
        }
        interestItems.add(itemName);
        session.setAttribute("interestItems", interestItems);
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        close(pstmt);
        close(conn);
    }

    // 등록 후 interestPage.jsp로 리다이렉트
    response.sendRedirect("interestPage.jsp");
%>
