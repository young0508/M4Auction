<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 페이지 렌더링 전에 만료된 경매가 있으면 닫아버리기
    Connection conn2 = getConnection();
    ScheduleDAO sd = new ScheduleDAO();
    ProductDAO pd = new ProductDAO();
    List<ScheduleDTO> all = sd.selectAllSchedules(conn2);
    for(ScheduleDTO s : all) {
        if ( now.after(s.getEndTime()) && !"종료됨".equals(s.getStatus()) ) {
            pd.closeAuction(conn2, s.getProductId(), s.getScheduleId());
        }
    }
    commit(conn2);
    close(conn2);
%>
<%
    // 1) 로그인 유저, 파라미터, 상품 조회
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String productIdStr = request.getParameter("productId");
    int productId = productIdStr != null ? Integer.parseInt(productIdStr) : 0;

    ProductDTO p = null;
    if (productId > 0) {
        Connection conn = getConnection();
        p = new ProductDAO().selectProductById(conn, productId);
        close(conn);
    }

    // 2) 상품이 없거나 상태가 'A'가 아닐 경우 즉시 경고 후 뒤로
    if (p == null || !"A".equals(p.getStatus())) {
%>
<script>
    alert("현재 진행중인 경매가 아닙니다.");
    history.back();
</script>
<%
        return;
    }

    // 3) 이후에만 변수를 계산
    boolean isEnded  = new java.util.Date().after(p.getEndTime());
    boolean isSeller = loginUser != null && loginUser.getMemberId().equals(p.getSellerId());
    boolean isWinner = loginUser != null && p.getWinnerId() != null && loginUser.getMemberId().equals(p.getWinnerId());

    java.text.DecimalFormat df = new java.text.DecimalFormat("###,###,###");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");
    int currentPrice = p.getCurrentPrice() == 0 ? p.getStartPrice() : p.getCurrentPrice();
    Long mileage      = loginUser != null ? loginUser.getMileage() : 0;
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Art Auction - 작품 상세</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<style>
    body { margin: 0; background-color: #1a1a1a; color: #e0e0e0; font-family: 'Noto Sans KR', sans-serif; }
    a { text-decoration: none; color: inherit; }
    .header { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; background-color: rgba(0,0,0,0.3); border-bottom: 1px solid #333; }
    .header .logo { font-family: 'Playfair Display', serif; font-size: 28px; color: #d4af37; }
    .header .nav a { margin-left: 25px; font-size: 16px; transition: color 0.3s; }
    .header .nav a:hover { color: #d4af37; }
    .footer { text-align: center; padding: 40px; margin-top: 50px; background-color: #000; color: #777; font-size: 14px; }
    .detail-container { display: flex; gap: 50px; max-width: 1200px; margin: 50px auto; padding: 50px; background-color: #2b2b2b; border-radius: 10px; }
    .product-image-section { flex-basis: 50%; }
    .product-image-section img { width: 100%; border-radius: 8px; }
    .product-details-section { flex-basis: 50%; display: flex; flex-direction: column; }
    .product-details-section .artist-name { font-size: 20px; color: #aaa; }
    .product-details-section .product-title { font-size: 42px; font-family: 'Playfair Display', serif; color: #fff; margin: 10px 0; }
    .product-details-section .description { margin-top: 30px; line-height: 1.8; flex-grow: 1; }
    .price-info { margin-top: 20px; padding: 20px; background-color: rgba(0,0,0,0.3); border-radius: 8px; }
    .price-info .label { font-size: 16px; color: #aaa; }
    .price-info .price { font-size: 32px; font-weight: 700; color: #d4af37; }
    .bid-actions { margin-top: 30px; }
    .bid-form { margin-top: 15px; }
    .bid-input-group { display: flex; gap: 10px; }
    .bid-input-group input { flex-grow: 1; padding: 15px; font-size: 18px; background-color: #1a1a1a; border: 1px solid #555; color: #fff; border-radius: 8px; -moz-appearance: textfield; }
    .bid-input-group input::-webkit-outer-spin-button, .bid-input-group input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
    .bid-button { display: block; width: 100%; padding: 15px; margin-top: 15px; font-size: 20px; font-weight: bold; color: #1a1a1a; background-color: #d4af37; border: none; border-radius: 8px; cursor: pointer; transition: background-color 0.3s; text-align:center; }
    .bid-button:hover { background-color: #e6c567; }
    .bid-button.buy-now { background-color: #c82333; color: white; }
    .bid-button.buy-now:hover { background-color: #a71d2a; }
    .bid-button:disabled { background-color: #555; color: #999; cursor: not-allowed; }
    .product-meta { margin-top: 20px; color: #aaa; }
</style>
</head>
<body>
    <%
    // … (p 조회 직후)
    // 1) 상품이 없거나 상태가 'A'가 아니면 경고 후 이전 페이지로
    if (p == null || ! "A".equals(p.getStatus())) {
%>
<script>
    alert("현재 진행중인 경매가 아닙니다.");
    history.back();
</script>
<%
        return;
    }
%>
    <header>
    <jsp:include page="/layout/header/header.jsp" />
    </head>
  <div class="detail-container">
    <!-- 이미지 섹션 생략 -->
    <div class="product-details-section">
      <p class="artist-name"><%= p.getArtistName() %></p>
      <h1 class="product-title"><%= p.getProductName() %></h1>

      <div class="bid-actions">
        <div class="price-info">
          <span class="label">현재가</span>
          <p class="price">₩ <%= df.format(currentPrice) %></p>
        </div>

        <% if (isEnded) { %>
          <% if (isSeller) { %>
            <a href="processWinnerAction.jsp?productId=<%= p.getProductId() %>" class="bid-button">낙찰 처리하기</a>
          <% } else { %>
            <button class="bid-button" disabled>경매 마감 (낙찰 처리중)</button>
          <% } %>
        <% } else { %>
          <form id="bidForm" action="bidAction.jsp" method="post" onsubmit="return validateBid();">
            <input type="hidden" name="productId"    value="<%= p.getProductId() %>">
            <input type="hidden" name="currentPrice" value="<%= currentPrice %>">
            <div class="bid-input-group">
              <input type="number" name="bidPrice" id="bidPriceInput" placeholder="입찰 금액" required>
              <button type="submit" class="bid-button">입찰하기</button>
            </div>
          </form>
          <% if (p.getBuyNowPrice() > 0 && !isSeller) { %>
            <a href="paymentAction.jsp?productId=<%= p.getProductId() %>"
               class="bid-button buy-now"
               onclick="return confirm('즉시 구매가(<%= df.format(p.getBuyNowPrice()) %>원)로 구매하시겠습니까?');">
              즉시 구매
            </a>
          <% } %>
        <% } %>
      </div>

      <p class="description"><%= p.getProductDesc() %></p>
      <div class="product-meta">
        <p>판매자: <%= p.getSellerId() %></p>
        <p>경매 마감: <%= sdf.format(p.getEndTime()) %></p>
        <% if (p.getWinnerId() != null) { 
        	%>
          <p style="color:#d4af37; font-weight:bold;">낙찰자: <%= p.getWinnerId() %></p>
        <% } %>
      </div>
    </div>
  </div>

  <footer class="footer">
    <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
  </footer>

  <script>
    function validateBid() {
      const bidPrice     = parseInt(document.getElementById('bidPriceInput').value, 10);
      const currentPrice = <%= currentPrice %>;
      const myMoney      = <%= mileage %>;

      if (isNaN(bidPrice) || bidPrice <= 0) {
        alert("올바른 입찰 금액을 입력해주세요.");
        return false;
      }
      if (bidPrice > myMoney) {
        alert("입찰가는 현재 마일리지를 초과할 수 없습니다.");
        return false;
      }
      if (bidPrice <= currentPrice) {
        alert("입찰가는 현재가보다 높아야 합니다.");
        return false;
      }
      if (bidPrice > currentPrice * 5) {
        alert("입찰가는 현재가의 500%를 초과할 수 없습니다.");
        return false;
      }
      return true;
    }
  </script>
</body>
</html>
