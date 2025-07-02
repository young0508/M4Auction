<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.auction.common.JDBCTemplate" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
	MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
	String alertMsg = (String)session.getAttribute("alertMsg");
	String idStr = request.getParameter("productId");
    if (idStr == null || idStr.trim().isEmpty()) {
        session.setAttribute("alertMsg", "잘못된 접근입니다.");
        response.sendRedirect("../index.jsp");
        return;
    }

    int productId = 0;
    try {
        productId = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        session.setAttribute("alertMsg", "상품 번호가 올바르지 않습니다.");
        response.sendRedirect("../index.jsp");
        return;
    }

    Connection conn = com.auction.common.JDBCTemplate.getConnection();
    ProductDAO dao = new ProductDAO();
    ProductDTO item = dao.selectProductById(conn, productId);
    com.auction.common.JDBCTemplate.close(conn);

    if (item == null) {
        session.setAttribute("alertMsg", "존재하지 않는 상품입니다.");
        response.sendRedirect("../index.jsp");
        return;
    }
    String memberId = (String)session.getAttribute("memberId");
%>
<html>
<head>
    <title>상품 상세</title>
</head>
<body>
<jsp:include page="/layout/header/header.jsp" />
    <h2><%= item.getProductName() %></h2>
    
    <p>작가 		<br><%= item.getArtistName() %></p>
    <p>설명 		<br><%= item.getProductDesc() %></p>
    <p>경매 시작가 <br><%=item.getStartPrice() %></p>
    <p>현재가 	<br><%= item.getCurrentPrice() %>원</p>
    <p>마감일  	<br><%= item.getEndTime() %>원</p>
	<p>등록일 	<br><%= item.getRegDate() %>원</p>

    <% if(loginUser == null){ %>
        <p style="color:red">로그인 후 입찰할 수 있습니다.</p>
    <% } else { %>
        <form action="bidAction.jsp" method="post">
            <input type="hidden" name="productId" value="<%= item.getProductId() %>">
            <input type="number" name="bidPrice" min="<%= item.getCurrentPrice() + 1 %>" required> 원
            <input type="submit" value="입찰">
        </form>
    <% } %>
</body>
</html>