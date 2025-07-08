<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.BidDTO" %>
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

    // 3. 유효성 검증: 입찰가 > 현재가
    if (bidPrice <= currentPrice) {
%>
<script>
    alert("입찰가는 현재가보다 높아야 합니다.");
    history.back();
</script>
<%
    close(conn);
    return;
}

// 마일리지 보유 여부 확인
if (bidPrice > loginUser.getMileage()) {
    rollback(conn);
%>
<script>
    alert("보유 마일리지가 부족합니다.");
    history.back();
</script>
<%
    close(conn);
    return;
}

	//1) 현재가 업데이트
   int resultPrice = dao.updateCurrentPrice(conn, productId, (Long)bidPrice);
   // 2) 마일리지 차감
   int resultMileage = dao.reduceMileage(conn, loginUser.getMemberId(), bidPrice);

   if(resultPrice > 0 && resultMileage > 0) {
     commit(conn);
     
   if(resultPrice > 0) {
    	    commit(conn);
    	    session.setAttribute("alertMsg", "입찰 성공!");
    	    
    	    // --- 거래내역 기록 ---
    	    new TransactionLogDAO()
    	        .insertLog(conn,
    	                   loginUser.getMemberId(),
    	                   "B",               // 입찰
    	                   bidPrice,
    	                   productId);
    	} else {
    	    rollback(conn);
    	    session.setAttribute("alertMsg", "입찰 실패");
    	}
%>

<script>
 alert("입찰 성공");
 location.href = "productDetail.jsp?productId=<%= productId %>";
</script>
<%
       // 세션에 남은 마일리지 반영
       loginUser.setMileage(loginUser.getMileage() - bidPrice);
       session.setAttribute("loginUser", loginUser);
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