<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.Bid" %>
<%@ page import="com.auction.dao.MemberDAO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // 1. 로그인 여부 확인
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    // 2. 파라미터 받기
    int productId    = Integer.parseInt(request.getParameter("productId"));
    int bidPrice     = Integer.parseInt(request.getParameter("bidPrice"));
    int currentPrice = Integer.parseInt(request.getParameter("currentPrice"));
    Long mileage = loginUser.getMileage();

    // 3. 유효성 검증: 입찰가 > 현재가
      if (bidPrice <= currentPrice || bidPrice > mileage) {
%>
<script>
    alert("입찰가는 현재가보다 높아야 합니다.");
    history.back();
</script>
<%
        return;
    }

    // 4. Bid 객체에 정보 세팅
    Bid b = new Bid();
    b.setProductId(productId);                      // 상품 ID
    b.setBidderId(loginUser.getMemberId());           // MemberDTO의 사용자 아이디
    b.setBidPrice(bidPrice);

    // 5. 트랜잭션 처리
    Connection conn = getConnection();
    ProductDAO dao = new ProductDAO();
    MemberDAO daom	= new MemberDAO();
    int result1 = 0, result2 = 0, result3 = 0;
    try {
        // 5-1) BID 테이블에 입찰 내역 저장
        result1 = dao.insertBid(conn, b);
        // 5-2) PRODUCT 테이블의 현재가 갱신
        result2 = dao.updateCurrentPrice(conn, productId, bidPrice);
        // 5-3) USERS 테이블의 마일리지 차감
        result3 = daom.deductMileage(conn, loginUser.getMemberId(), bidPrice);

        // 3가지 모두 성공해야 커밋
        if (result1 > 0 && result2 > 0 && result3 > 0) {
            commit(conn);
            // 세션의 마일리지도 차감 후 업데이트
            loginUser.setMileage(loginUser.getMileage() - bidPrice);
            session.setAttribute("loginUser", loginUser);
        } else {
            rollback(conn);
        }
    } catch (Exception e) {
        rollback(conn);
        e.printStackTrace();
    } finally {
        close(conn);
    }
%>
<%
    int productId = Integer.parseInt(request.getParameter("productId"));
    int bidAmount = Integer.parseInt(request.getParameter("bidAmount"));
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
    int memberId = user.getMemberId();

    Connection conn = getConnection();
    ProductDAO dao = new ProductDAO();
    boolean ok = false;
    try {
        ok = dao.placeBid(conn, memberId, productId, bidAmount);
        if(ok) commit(conn);
        else      rollback(conn);
    } catch(Exception e) {
        rollback(conn);
        e.printStackTrace();
    } finally {
        close(conn);
    }

    if(ok) {
        session.setAttribute("alertMsg","입찰 성공!");
    } else {
        session.setAttribute("alertMsg","입찰 실패: 마일리지가 부족하거나 오류 발생");
    }
    response.sendRedirect("productDetail.jsp?productId=" + productId);
%>
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
    // 상품 상세페이지로 리다이렉트
    location.replace("productDetail.jsp?productId=<%= productId %>");
<% } else { %>
    alert("입찰 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
    history.back();
<% } %>
</script>
</body>
</html>
