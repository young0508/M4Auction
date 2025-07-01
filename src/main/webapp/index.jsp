<%--
  File: WebContent/index.jsp
  역할: 페이징, 검색, 카테고리 기능이 적용된 최종 메인 페이지입니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="com.auction.common.PageInfo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
	MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    String alertMsg = (String)session.getAttribute("alertMsg");

    // --- 검색 및 카테고리 관련 로직 ---
    String keyword = request.getParameter("keyword");
    String category = request.getParameter("category");

    if(keyword == null) { keyword = ""; }
    if(category == null) { category = "all"; }

    // --- 페이징 처리 로직 ---
    int listCount;
    int currentPage = 1;
    int pageLimit = 5;
    int boardLimit = 8;
    
    Connection conn = getConnection();
    ProductDAO pDao = new ProductDAO();
    List<ProductDTO> productList;

    if(!keyword.equals("")) {
        listCount = pDao.searchProductCount(conn, keyword);
    } else if(!category.equals("all")) {
        listCount = pDao.selectProductCountByCategory(conn, category);
    } else {
        listCount = pDao.selectProductCount(conn);
    }

    if(request.getParameter("page") != null){
        currentPage = Integer.parseInt(request.getParameter("page"));
    }
    
    PageInfo pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);

    if(!keyword.equals("")) {
        productList = pDao.searchProductList(conn, keyword, pi);
    } else if(!category.equals("all")) {
        productList = pDao.selectProductListByCategory(conn, category, pi);
    } else {
        productList = pDao.selectProductList(conn, pi);
    }
    
    close(conn);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DecimalFormat df = new DecimalFormat("###,###,###");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - Premium Online Auction</title>
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
    .content-wrapper { display: flex; padding: 40px 50px; gap: 40px; }
    .main-container { flex-grow: 1; }
    .sidebar { width: 250px; flex-shrink: 0; background-color: #2b2b2b; padding: 20px; border-radius: 8px; height: fit-content; }
    .sidebar .search-form { display: flex; margin-bottom: 30px; }
    .sidebar .search-form input { width: 100%; padding: 10px 15px; border: 1px solid #555; border-right: none; background-color: #1a1a1a; color: #fff; border-radius: 5px 0 0 5px; outline: none; }
    .sidebar .search-form button { padding: 10px; border: 1px solid #d4af37; background-color: #d4af37; color: #1a1a1a; font-weight: bold; cursor: pointer; border-radius: 0 5px 5px 0; }
    .sidebar-title { font-size: 22px; font-weight: 700; color: #fff; border-bottom: 2px solid #d4af37; padding-bottom: 10px; margin: 0 0 20px 0; }
    .category-list { list-style: none; padding: 0; margin: 0; }
    .category-list li a { display: block; padding: 12px 15px; color: #ccc; border-radius: 5px; transition: background-color 0.3s, color 0.3s; }
    .category-list li a:hover, .category-list li a.active { background-color: rgba(212, 175, 55, 0.1); color: #d4af37; font-weight: bold; }
    .section-title { font-size: 32px; font-weight: 700; margin-bottom: 30px; color: #fff; border-left: 5px solid #d4af37; padding-left: 15px; }
    .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 30px; min-height: 500px; }
    .product-card { background-color: #2b2b2b; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.2); transition: transform 0.3s, box-shadow 0.3s; cursor: pointer; }
    .product-card:hover { transform: translateY(-10px); box-shadow: 0 10px 25px rgba(212, 175, 55, 0.2); }
    .product-card img { width: 100%; height: 250px; object-fit: cover; }
    .product-info { padding: 20px; }
    .product-info h3 { margin: 0 0 10px 0; font-size: 20px; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;}
    .product-info .artist { color: #aaa; margin-bottom: 20px; }
    .product-info .price-label { font-size: 14px; color: #aaa; }
    .product-info .price { font-size: 22px; font-weight: 700; color: #d4af37; }
    .product-info .timer { margin-top: 15px; padding: 10px; background-color: rgba(0,0,0,0.3); border-radius: 5px; text-align: center; font-size: 20px; color: #ff6b6b; }
    .product-info .ended { color: #777; }
    .footer { text-align: center; padding: 40px; margin-top: 50px; background-color: #000; color: #777; font-size: 14px; }
    .paging-area { display: flex; justify-content: center; margin-top: 50px; }
    .paging-area a { padding: 8px 15px; margin: 0 5px; border: 1px solid #555; border-radius: 5px; color: #ccc; transition: all 0.3s; }
    .paging-area a:hover, .paging-area a.current-page { background-color: #d4af37; color: #1a1a1a; border-color: #d4af37; font-weight: bold; }
</style>
</head>
<body>
<jsp:include page="/layout/header/header.jsp" />
    <% if(alertMsg != null) { %>
        <script>
            alert("<%= alertMsg %>");
        </script>
    <%
            session.removeAttribute("alertMsg");
       } 
    %>
    <header class="header">
    </header>
    <div class="content-wrapper">
        <main class="main-container">
            <h2 class="section-title">Now Bidding</h2>
            <div class="product-grid">
                <% if(productList.isEmpty()) { %>
                    <p>조회된 상품이 없습니다.</p>
                <% } else { %>
                    <% for(ProductDTO p : productList) { %>
                        <a href="<%= request.getContextPath() %>/product/productDetail.jsp?productId=<%= p.getProductId() %>">
                            <div class="product-card">
                                <% if(p.getImageRenamedName() != null) { %>
                                    <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>">
                                <% } else { %>
                                    <img src="https://placehold.co/600x400/2b2b2b/e0e0e0?text=<%= URLEncoder.encode(p.getProductName(), "UTF-8") %>" alt="<%= p.getProductName() %>">
                                <% } %>
                                <div class="product-info">
                                    <h3><%= p.getProductName() %></h3>
                                    <p class="artist"><%= p.getArtistName() %></p>
                                    <span class="price-label">현재가</span>
                                    <p class="price">₩ <%= df.format(p.getCurrentPrice() == 0 ? p.getStartPrice() : p.getCurrentPrice()) %></p>
                                    <div class="timer" data-endtime="<%= sdf.format(p.getEndTime()) %>"></div>
                                </div>
                            </div>
                        </a>
                    <% } %>
                <% } %>
            </div>
            <div class="paging-area">
                <% String urlParams = "&keyword=" + keyword + "&category=" + category; %>
                <% if(pi.getCurrentPage() > 1) { %>
                    <a href="<%= request.getContextPath() %>/index.jsp?page=<%= pi.getCurrentPage() - 1 %><%= urlParams %>">&lt;</a>
                <% } %>
                <% for(int i = pi.getStartPage(); i <= pi.getEndPage(); i++) { %>
                    <% if(i == pi.getCurrentPage()) { %>
                        <a href="#" class="current-page"><%= i %></a>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/index.jsp?page=<%= i %><%= urlParams %>"><%= i %></a>
                    <% } %>
                <% } %>
                <% if(pi.getCurrentPage() < pi.getMaxPage()) { %>
                    <a href="<%= request.getContextPath() %>/index.jsp?page=<%= pi.getCurrentPage() + 1 %><%= urlParams %>">&gt;</a>
                <% } %>
            </div>
        </main>
        <aside class="sidebar">
            <form action="<%= request.getContextPath() %>/index.jsp" method="get" class="search-form">
                <input type="text" name="keyword" placeholder="작품/작가명 검색" value="<%= keyword %>">
                <button type="submit">&#128269;</button>
            </form>
            <h3 class="sidebar-title">Category</h3>
            <ul class="category-list">
                <li><a href="index.jsp?category=all" class="<%= category.equals("all") ? "active" : "" %>">전체보기</a></li>
                <li><a href="index.jsp?category=서양화" class="<%= category.equals("서양화") ? "active" : "" %>">서양화</a></li>
                <li><a href="index.jsp?category=동양화" class="<%= category.equals("동양화") ? "active" : "" %>">동양화</a></li>
                <li><a href="index.jsp?category=조각" class="<%= category.equals("조각") ? "active" : "" %>">조각</a></li>
                <li><a href="index.jsp?category=판화" class="<%= category.equals("판화") ? "active" : "" %>">판화</a></li>
                <li><a href="index.jsp?category=사진" class="<%= category.equals("사진") ? "active" : "" %>">사진</a></li>
                <li><a href="index.jsp?category=고미술" class="<%= category.equals("고미술") ? "active" : "" %>">고미술</a></li>
            </ul>
        </aside>
    </div>
    <footer class="footer">
        <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
    </footer>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const timers = document.querySelectorAll('.timer');
            timers.forEach(timer => {
                const endTimeString = timer.dataset.endtime;
                if(!endTimeString) return;

                const endTime = new Date(endTimeString).getTime();

                const interval = setInterval(function() {
                    const now = new Date().getTime();
                    const distance = endTime - now;

                    if (distance > 0) {
                        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                        const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                        
                        let timerHTML = "";
                        if(days > 0) timerHTML += days + "일 ";
                        timerHTML += String(hours).padStart(2, '0') + ":" 
                                   + String(minutes).padStart(2, '0') + ":" 
                                   + String(seconds).padStart(2, '0');
                        timer.innerHTML = timerHTML;
                    } else {
                        clearInterval(interval);
                        timer.innerHTML = "경매 마감";
                        timer.classList.add('ended');
                    }
                }, 1000);
            });
        });
    </script>
<jsp:include page="/layout/footer/footer.jsp" />

</body>
</html>
