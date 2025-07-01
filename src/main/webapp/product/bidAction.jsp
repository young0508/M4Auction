<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.vo.BidDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.lang.Exception" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // 1) 로그인 체크
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    // 2) 파라미터 파싱
    int productId   = Integer.parseInt(request.getParameter("productId"));
    int bidPrice    = Integer.parseInt(request.getParameter("bidPrice"));
    int currentPrice= Integer.parseInt(request.getParameter("currentPrice"));

    if (bidPrice <= currentPrice) {
%>
<script>
    alert("입찰가는 현재가보다 높아야 합니다.");
    history.back();
</script>
<%
        return;
    }

    Connection conn = getConnection();
    ProductDAO dao = new ProductDAO();

    // 3) 상품 존재 여부 확인 (외래키 위반 방지)
    ProductDTO prod = dao.selectProductById(conn, productId);
    if (prod == null) {
        close(conn);
%>
<script>
    alert("해당 상품이 존재하지 않습니다.");
    history.back();
</script>
<%
        return;
    }

    // 4) 입찰 DTO 준비
    BidDTO b = new BidDTO();
    b.setProductId(productId);
    b.setMemberId(loginUser.getMemberId());
    b.setBidPrice(bidPrice);

    int result1 = 0, result2 = 0;
    try {
        // 5-1) 입찰 기록 추가
        result1 = dao.insertBid(conn, b);

        // 5-2) 현재가 업데이트
        result2 = dao.updateCurrentPrice(conn, productId, bidPrice);

        if (result1 > 0 && result2 > 0) {
            commit(conn);
        } else {
            rollback(conn);
        }
    } catch (SQLException e) {
        rollback(conn);

        // ORA-02291 외래키 위반: 부모 키가 없음
        if (e.getErrorCode() == 2291) {
%>
<script>
    alert("입찰할 수 없는 상품입니다. 다시 확인해 주세요.");
    history.back();
</script>
<%
        } else {
            // 그 외의 SQL 오류
            e.printStackTrace();
%>
<script>
    alert("입찰 처리 중 오류가 발생했습니다. 관리자에게 문의하세요.");
    history.back();
</script>
<%
        }
        return;
    } finally {
        close(conn);
    }
%>

<!— 성공/실패 후 이동 로직 —>
<script>
<% if (result1 > 0 && result2 > 0) { %>
    alert("입찰에 성공했습니다.");
    location.replace("productDetail.jsp?productId=<%= productId %>");
<% } %>
</script>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>입찰 처리</title>
</head>
<body>
<script>
<% if (result1 > 0 && result2 > 0) { %>
    alert("입찰에 성공했습니다.");
    location.replace("productDetail.jsp?productId=<%= productId %>");
<% } else { %>
    alert("입찰 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
    history.back();
<% } %>
</script>
</body>
</html>
