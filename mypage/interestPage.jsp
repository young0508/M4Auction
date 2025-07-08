<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %> 
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
    // 로그인된 사용자 정보 가져오기
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/luxury-login.jsp");
        return;
    }

 	// 관심 상품 목록 DB에서 불러오기
    List<String> interestItems = new ArrayList<>();
    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        String sql = "SELECT interest_name FROM INTEREST_PRODUCT WHERE MEMBER_ID = ? ORDER BY created_at DESC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, loginUser.getMemberId());
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            interestItems.add(rs.getString("interest_name"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        close(rs);
        close(pstmt);
        close(conn);
    }
    
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관심 상품</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: 50px auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
        }

        h2 {
            font-size: 24px;
            color: #444;
            margin-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
            color: #555;
        }

        .form-group input[type="text"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .form-group button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }

        .form-group button:hover {
            background-color: #45a049;
        }

        hr {
            border-top: 1px solid #eee;
            margin: 20px 0;
        }

        ul {
            padding: 0;
            list-style-type: none;
        }

        ul li {
            background-color: #f9f9f9;
            margin: 10px 0;
            padding: 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        ul li button {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 4px;
        }

        ul li button:hover {
            background-color: #c0392b;
        }

        .btn-back {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 25px;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            display: block;
            margin: 30px auto;
            text-align: center;
        }

        .btn-back:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>관심 상품</h1>

        <!-- 관심 상품 등록 폼 -->
        <form action="addInterestItem.jsp" method="post" class="form-group">
            <label for="itemName">상품명:</label>
            <input type="text" id="itemName" name="itemName" required>
            <button type="submit">등록</button>
        </form>

        <hr>

        <!-- 등록된 관심 상품 목록 -->
        <h2>내 관심 상품</h2>
        <ul>
            <% if (!interestItems.isEmpty()) {
                   for (int i = 0; i < interestItems.size(); i++) {
                       String item = interestItems.get(i);
            %>
            <li>
                <%= item %>
                <!-- 삭제 버튼 -->
                <form action="deleteInterestItem.jsp" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                    <input type="hidden" name="index" value="<%= i %>">
                    <button type="submit">삭제</button>
                </form>
            </li>
            <%   }
               } else { %>
            <li>등록된 관심 상품이 없습니다.</li>
            <% } %>
        </ul>

        <!-- 내 페이지로 돌아가기 버튼 -->
        <button type="button" class="btn-back" onclick="location.href='myPage.jsp'">내 페이지로 돌아가기</button>
    </div>

</body>
</html>
