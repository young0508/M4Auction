<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO, com.auction.vo.ProductDTO, com.auction.vo.Bid" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
if(loginUser == null){
    response.sendRedirect("../member/loginForm.jsp");
    return;
}

int productId = Integer.parseInt(request.getParameter("productId"));
int bidPrice = Integer.parseInt(request.getParameter("bidPrice"));

Connection conn = getConnection();
ProductDAO dao = new ProductDAO();
ProductDTO p = dao.selectProductById(conn, productId);

// 상품이 존재하지 않으면 중단
if (p == null) {
    rollback(conn);
%>
<script>
    alert("존재하지 않는 상품입니다.");
    location.href = "productList.jsp";
</script>
<%
    close(conn);
    return;
}

if (bidPrice <= p.getCurrentPrice()) {
    rollback(conn);
%>
<script>
    alert("입찰가는 현재가보다 높아야 합니다.");
    history.back();
</script>
<%
    close(conn);
    return;
}

Bid b = new Bid();
b.setProductId(productId);
b.setMemberId(loginUser.getMemberId());
b.setBidPrice(bidPrice);

int result1 = dao.insertBid(conn, b);
int result2 = dao.updateCurrentPrice(conn, productId, bidPrice);

if(result1 > 0 && result2 > 0){
    commit(conn);
%>
<script>
    alert("입찰 성공");
    location.href = "productDetail.jsp?productId=<%= productId %>";
</script>
<%
} else {
    rollback(conn);
%>
<script>
    alert("입찰 실패");
    history.back();
</script>
<%
}
close(conn);
%>
