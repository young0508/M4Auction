# 🔍 코드 읽는 방법: 초보자를 위한 완전 가이드

## 📚 코드 읽기 시작하기

### 🎯 코드 읽기의 기본 원칙
1. **위에서 아래로**: 코드는 위에서 아래로 순서대로 실행됩니다
2. **패키지부터 시작**: 가장 위의 `package`와 `import` 문부터 읽기
3. **클래스 이름 이해**: 클래스 이름을 보면 그 파일이 하는 일을 알 수 있습니다
4. **메서드별로 나누어 읽기**: 한 번에 하나의 메서드만 집중해서 읽기

### 📖 코드 읽는 순서

#### 1단계: 전체 구조 파악
```java
package com.auction.dao;                    // 이 파일이 속한 그룹
import java.sql.Connection;                 // 다른 파일에서 가져온 도구들
import java.sql.PreparedStatement;
import com.auction.dto.MemberDTO;

public class MemberDAO {                    // 클래스 이름 = 파일의 역할
    // 여기에 메서드들이 있음
}
```

#### 2단계: 각 메서드 분석
```java
public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
    // 메서드 이름: loginMember (로그인 처리)
    // 받는 것: conn(데이터베이스 연결), userId(아이디), userPwd(비밀번호)
    // 돌려주는 것: MemberDTO (회원 정보)
}
```

## 🔍 실제 코드 읽기 실습

### 예시 1: MemberDTO.java 읽기

```java
// File: src/main/java/com/auction/dto/MemberDTO.java
package com.auction.dto;        // 이 파일은 'dto' 그룹에 속함

import java.sql.Date;           // 날짜를 다루는 도구를 가져옴

public class MemberDTO {        // 회원 정보를 담는 틀
    // 회원 정보를 저장할 상자들
    private String memberId;      // 회원 아이디
    private String memberPwd;     // 회원 비밀번호
    private String memberName;    // 회원 이름
    private String email;         // 이메일 주소
    private long mileage;         // 마일리지 점수
    
    // 기본 생성자 (빈 회원 정보 상자를 만듦)
    public MemberDTO() {}
    
    // 회원 아이디를 가져오는 메서드
    public String getMemberId() { 
        return memberId; 
    }
    
    // 회원 아이디를 설정하는 메서드
    public void setMemberId(String memberId) { 
        this.memberId = memberId; 
    }
    
    // ... 다른 필드들의 getter/setter도 같은 방식
}
```

**한국어로 번역하면:**
- 이 파일은 "회원 정보를 담는 상자"입니다
- 상자 안에는 아이디, 비밀번호, 이름, 이메일, 마일리지가 들어갑니다
- 각 정보를 넣고 빼는 메서드들이 있습니다

### 예시 2: MemberDAO.java의 로그인 메서드 읽기

```java
public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
    MemberDTO loginUser = null;           // 결과를 담을 빈 상자 준비
    PreparedStatement pstmt = null;       // 데이터베이스에 보낼 편지 준비
    ResultSet rs = null;                  // 데이터베이스에서 받을 답장 준비
    
    // 데이터베이스에 보낼 질문 (SQL)
    String sql = "SELECT * FROM USERS WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";
    
    try {
        // 편지(SQL)를 준비하고
        pstmt = conn.prepareStatement(sql);
        
        // 물음표 자리에 실제 값을 넣고
        pstmt.setString(1, userId);       // 첫 번째 ?에 아이디
        pstmt.setString(2, userPwd);      // 두 번째 ?에 비밀번호
        
        // 데이터베이스에 편지를 보내고 답장을 받음
        rs = pstmt.executeQuery();
        
        // 답장에 내용이 있다면 (로그인 성공)
        if (rs.next()) {
            loginUser = new MemberDTO();   // 새로운 회원 정보 상자 생성
            
            // 데이터베이스에서 받은 정보를 상자에 담기
            loginUser.setMemberId(rs.getString("MEMBER_ID"));
            loginUser.setMemberName(rs.getString("MEMBER_NAME"));
            loginUser.setEmail(rs.getString("EMAIL"));
            // ... 기타 정보들
        }
    } catch (SQLException e) {
        e.printStackTrace();               // 문제가 생기면 에러 메시지 출력
    } finally {
        close(rs);                        // 사용한 도구들 정리
        close(pstmt);
    }
    
    return loginUser;                     // 결과 반환 (성공시 회원정보, 실패시 null)
}
```

**한국어로 번역하면:**
1. 빈 상자 3개를 준비합니다 (결과상자, 편지상자, 답장상자)
2. 데이터베이스에 보낼 질문을 준비합니다: "아이디가 XXX이고 비밀번호가 YYY인 사람을 찾아주세요"
3. 질문의 XXX와 YYY 자리에 실제 값을 넣습니다
4. 데이터베이스에 질문을 보내고 답장을 받습니다
5. 답장에 내용이 있으면 회원 정보를 상자에 담아서 반환합니다
6. 답장이 비어있으면 null을 반환합니다 (로그인 실패)

### 예시 3: JSP 파일 읽기 - loginForm.jsp

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 이 페이지는 자바를 사용하고, 한글이 깨지지 않게 UTF-8로 설정 -->

<%
    String ctx = request.getContextPath();
    // ctx = 이 웹사이트의 기본 주소 (예: /auction)
    
    String alertMsg = (String)session.getAttribute("alertMsg");
    // 세션에서 알림 메시지가 있는지 확인
    
    if(alertMsg != null) {
        session.removeAttribute("alertMsg");
        // 알림 메시지를 확인했으니 삭제
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - M4 Auction</title>
    <!-- 페이지의 제목 설정 -->
</head>
<body>
    <div class="login-container">
        <h1>로그인</h1>
        
        <% if(alertMsg != null) { %>
            <div class="alert">
                <%=alertMsg%>
                <!-- 알림 메시지가 있으면 화면에 표시 -->
            </div>
        <% } %>
        
        <form action="<%=ctx%>/member/loginAction.jsp" method="post">
            <!-- 폼의 내용을 loginAction.jsp로 전송 -->
            
            <input type="text" name="userId" placeholder="아이디" required>
            <!-- 아이디 입력 칸 -->
            
            <input type="password" name="userPwd" placeholder="비밀번호" required>
            <!-- 비밀번호 입력 칸 -->
            
            <button type="submit">로그인</button>
            <!-- 로그인 버튼 -->
        </form>
        
        <a href="enroll_step1.jsp">회원가입</a>
        <!-- 회원가입 페이지로 이동하는 링크 -->
    </div>
</body>
</html>
```

**한국어로 번역하면:**
1. 이 페이지는 한글이 깨지지 않게 설정되어 있습니다
2. 웹사이트의 기본 주소를 가져옵니다
3. 로그인 실패 등의 알림 메시지가 있는지 확인합니다
4. HTML로 로그인 화면을 만듭니다
5. 알림 메시지가 있으면 화면에 표시합니다
6. 사용자가 아이디와 비밀번호를 입력할 수 있는 폼을 만듭니다
7. 로그인 버튼을 누르면 loginAction.jsp로 정보를 전송합니다

### 예시 4: JSP 액션 파일 읽기 - loginAction.jsp

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dao.MemberDAO" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<!-- 필요한 도구들을 가져옴 -->

<%
    // 1. 로그인 폼에서 전송된 정보 받기
    String userId = request.getParameter("userId");
    String userPwd = request.getParameter("userPwd");
    
    // 2. 데이터베이스 연결 준비
    Connection conn = null;
    MemberDTO loginUser = null;
    
    try {
        // 3. 데이터베이스에 연결
        conn = getConnection();
        
        // 4. 회원 정보 조회 담당자 호출
        MemberDAO memberDAO = new MemberDAO();
        loginUser = memberDAO.loginMember(conn, userId, userPwd);
        
        // 5. 로그인 성공 여부 확인
        if(loginUser != null) {
            // 성공: 세션에 회원 정보 저장
            session.setAttribute("loginUser", loginUser);
            session.setAttribute("sid", loginUser.getMemberId());
            
            // 메인 페이지로 이동
            response.sendRedirect("../index.jsp");
        } else {
            // 실패: 에러 메시지 설정
            session.setAttribute("alertMsg", "아이디 또는 비밀번호가 잘못되었습니다.");
            
            // 로그인 페이지로 다시 이동
            response.sendRedirect("loginForm.jsp");
        }
    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("alertMsg", "로그인 처리 중 오류가 발생했습니다.");
        response.sendRedirect("loginForm.jsp");
    } finally {
        // 6. 데이터베이스 연결 종료
        close(conn);
    }
%>
```

**한국어로 번역하면:**
1. 로그인 폼에서 보낸 아이디와 비밀번호를 받습니다
2. 데이터베이스 연결을 준비합니다
3. 데이터베이스에 실제로 연결합니다
4. 회원 정보 조회 전문가(MemberDAO)를 호출해서 로그인 처리를 맡깁니다
5. 로그인 결과를 확인합니다:
   - 성공하면: 회원 정보를 세션에 저장하고 메인 페이지로 이동
   - 실패하면: 에러 메시지를 설정하고 로그인 페이지로 다시 이동
6. 문제가 생기면 에러 메시지를 표시합니다
7. 마지막에 데이터베이스 연결을 정리합니다

## 🎯 복잡한 코드 읽기 전략

### 1. 큰 메서드를 작은 단위로 나누어 읽기

```java
// 복잡해 보이는 경매 입찰 처리 메서드
public boolean processBid(int productId, String bidderId, int bidPrice) {
    Connection conn = null;
    boolean success = false;
    
    try {
        conn = getConnection();
        conn.setAutoCommit(false);  // 트랜잭션 시작
        
        // 【1단계】 입찰 가능 여부 확인
        if (!isValidBid(conn, productId, bidderId, bidPrice)) {
            return false;
        }
        
        // 【2단계】 입찰 정보 저장
        if (!saveBidInfo(conn, productId, bidderId, bidPrice)) {
            rollback(conn);
            return false;
        }
        
        // 【3단계】 상품 현재가 업데이트
        if (!updateProductPrice(conn, productId, bidPrice)) {
            rollback(conn);
            return false;
        }
        
        // 【4단계】 입찰자 마일리지 차감
        if (!deductMileage(conn, bidderId, bidPrice)) {
            rollback(conn);
            return false;
        }
        
        // 모든 단계가 성공하면 확정
        commit(conn);
        success = true;
        
    } catch (Exception e) {
        rollback(conn);
        e.printStackTrace();
    } finally {
        close(conn);
    }
    
    return success;
}
```

**읽기 전략:**
1. 전체 메서드를 4개의 단계로 나누어 이해
2. 각 단계별로 무엇을 하는지 파악
3. 성공/실패 처리 로직 이해
4. 예외 처리 방법 이해

### 2. 조건문과 반복문 읽기

```java
// 상품 목록 조회 메서드
public List<ProductDTO> selectProductList(Connection conn, PageInfo pi) {
    List<ProductDTO> list = new ArrayList<>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // 페이징을 위한 SQL 쿼리
    String sql = "SELECT * FROM (" +
                "SELECT ROWNUM AS RNUM, A.* FROM (" +
                "SELECT * FROM PRODUCT WHERE STATUS = 'A' " +
                "ORDER BY END_TIME ASC" +
                ") A" +
                ") WHERE RNUM BETWEEN ? AND ?";
    
    try {
        pstmt = conn.prepareStatement(sql);
        
        // 페이징 계산
        int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
        int endRow = startRow + pi.getBoardLimit() - 1;
        
        pstmt.setInt(1, startRow);
        pstmt.setInt(2, endRow);
        
        rs = pstmt.executeQuery();
        
        // 결과를 하나씩 처리
        while (rs.next()) {  // 데이터가 있는 동안 반복
            ProductDTO p = new ProductDTO();
            p.setProductId(rs.getInt("PRODUCT_ID"));
            p.setProductName(rs.getString("PRODUCT_NAME"));
            p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
            // ... 기타 정보 설정
            
            list.add(p);  // 리스트에 추가
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        close(rs);
        close(pstmt);
    }
    
    return list;
}
```

**읽기 전략:**
1. **페이징 계산 부분**: 몇 번째 데이터부터 몇 번째까지 가져올지 계산
2. **while 반복문**: 데이터베이스에서 받은 결과를 하나씩 처리
3. **각 반복마다**: 새로운 ProductDTO 객체를 만들고 정보를 채워넣음

### 3. 예외 처리 읽기

```java
public int updateMileage(Connection conn, String memberId, int delta) throws SQLException {
    String sql = "UPDATE USERS SET MILEAGE = MILEAGE + ? WHERE MEMBER_ID = ?";
    
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, delta);      // 증감할 마일리지 양
        pstmt.setString(2, memberId); // 대상 회원 ID
        
        int result = pstmt.executeUpdate();
        
        // 업데이트된 행이 0개라면 회원이 존재하지 않음
        if (result == 0) {
            throw new SQLException("회원을 찾을 수 없습니다: " + memberId);
        }
        
        return result;
    } catch (SQLException e) {
        System.err.println("마일리지 업데이트 실패: " + e.getMessage());
        throw e;  // 예외를 다시 던져서 상위 코드에서 처리하게 함
    }
}
```

**읽기 전략:**
1. **try-with-resources**: 자원을 자동으로 정리하는 문법
2. **업데이트 결과 확인**: 실제로 변경된 행의 개수 확인
3. **예외 던지기**: 문제가 생기면 상위 코드에 알리기

## 🔄 자주 나오는 패턴 설명

### 1. 데이터베이스 처리 패턴

```java
public [반환타입] [메서드명]([매개변수들]) {
    [반환타입] result = [기본값];        // 1. 결과 변수 초기화
    PreparedStatement pstmt = null;     // 2. 쿼리 실행 도구
    ResultSet rs = null;                // 3. 결과 저장 도구
    
    String sql = "[SQL 쿼리문]";        // 4. 실행할 쿼리
    
    try {
        pstmt = conn.prepareStatement(sql);  // 5. 쿼리 준비
        pstmt.setString(1, [값]);           // 6. 쿼리 값 설정
        
        rs = pstmt.executeQuery();          // 7. 쿼리 실행
        // 또는
        result = pstmt.executeUpdate();     // 7. 업데이트 실행
        
        if (rs.next()) {                    // 8. 결과 처리
            // 결과가 있을 때 처리
        }
        
    } catch (SQLException e) {              // 9. 예외 처리
        e.printStackTrace();
    } finally {
        close(rs);                          // 10. 자원 정리
        close(pstmt);
    }
    
    return result;                          // 11. 결과 반환
}
```

### 2. JSP 처리 패턴

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="[필요한 클래스들]" %>

<%
    // 1. 파라미터 받기
    String param1 = request.getParameter("param1");
    String param2 = request.getParameter("param2");
    
    // 2. 변수 초기화
    Connection conn = null;
    결과타입 result = null;
    
    try {
        // 3. 데이터베이스 연결
        conn = getConnection();
        
        // 4. DAO 호출
        DAO dao = new DAO();
        result = dao.someMethod(conn, param1, param2);
        
        // 5. 결과에 따른 처리
        if (result != null) {
            // 성공 처리
            session.setAttribute("key", result);
            response.sendRedirect("success.jsp");
        } else {
            // 실패 처리
            session.setAttribute("alertMsg", "처리 실패");
            response.sendRedirect("error.jsp");
        }
        
    } catch (Exception e) {
        // 6. 예외 처리
        e.printStackTrace();
        session.setAttribute("alertMsg", "오류 발생");
        response.sendRedirect("error.jsp");
    } finally {
        // 7. 자원 정리
        close(conn);
    }
%>
```

### 3. 폼 처리 패턴

```html
<!-- HTML 폼 -->
<form action="processAction.jsp" method="post">
    <input type="text" name="field1" required>
    <input type="email" name="field2" required>
    <button type="submit">제출</button>
</form>

<!-- JavaScript 검증 -->
<script>
function validateForm() {
    // 1. 입력값 가져오기
    const field1 = document.getElementById('field1').value;
    const field2 = document.getElementById('field2').value;
    
    // 2. 검증 로직
    if (!field1.trim()) {
        alert('필드1을 입력하세요.');
        return false;
    }
    
    if (!isValidEmail(field2)) {
        alert('올바른 이메일을 입력하세요.');
        return false;
    }
    
    // 3. 검증 통과
    return true;
}
</script>
```

## 🚀 실전 코드 읽기 연습

### 연습 1: 상품 등록 기능 따라 읽기

**1단계: 상품 등록 폼 (productEnrollForm.jsp)**
```jsp
<form action="productEnrollAction.jsp" method="post" enctype="multipart/form-data">
    <input type="text" name="productName" placeholder="상품명" required>
    <input type="text" name="artistName" placeholder="작가명" required>
    <input type="number" name="startPrice" placeholder="시작가" required>
    <input type="file" name="productImage" accept="image/*" required>
    <button type="submit">등록</button>
</form>
```

**2단계: 상품 등록 처리 (productEnrollAction.jsp)**
```jsp
<%
    // 파일 업로드 처리
    MultipartRequest mr = new MultipartRequest(request, uploadPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
    
    // 폼 데이터 받기
    String productName = mr.getParameter("productName");
    String artistName = mr.getParameter("artistName");
    int startPrice = Integer.parseInt(mr.getParameter("startPrice"));
    
    // 파일 정보 받기
    String originalName = mr.getOriginalFileName("productImage");
    String renamedName = mr.getFilesystemName("productImage");
    
    // DTO 객체 생성
    ProductDTO product = new ProductDTO();
    product.setProductName(productName);
    product.setArtistName(artistName);
    product.setStartPrice(startPrice);
    product.setImageOriginalName(originalName);
    product.setImageRenamedName(renamedName);
    
    // 데이터베이스 저장
    Connection conn = getConnection();
    ProductDAO dao = new ProductDAO();
    int result = dao.insertProduct(conn, product);
    
    if (result > 0) {
        session.setAttribute("alertMsg", "상품이 등록되었습니다.");
        response.sendRedirect("productList.jsp");
    } else {
        session.setAttribute("alertMsg", "상품 등록에 실패했습니다.");
        response.sendRedirect("productEnrollForm.jsp");
    }
%>
```

**3단계: 데이터베이스 저장 (ProductDAO.java)**
```java
public int insertProduct(Connection conn, ProductDTO p) {
    int result = 0;
    PreparedStatement pstmt = null;
    
    String sql = "INSERT INTO PRODUCT (" +
                "PRODUCT_ID, PRODUCT_NAME, ARTIST_NAME, START_PRICE, " +
                "IMAGE_ORIGINAL_NAME, IMAGE_RENAMED_NAME, SELLER_ID, STATUS" +
                ") VALUES (" +
                "SEQ_PRODUCT_ID.NEXTVAL, ?, ?, ?, ?, ?, ?, 'P'" +
                ")";
    
    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, p.getProductName());
        pstmt.setString(2, p.getArtistName());
        pstmt.setInt(3, p.getStartPrice());
        pstmt.setString(4, p.getImageOriginalName());
        pstmt.setString(5, p.getImageRenamedName());
        pstmt.setString(6, p.getSellerId());
        
        result = pstmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        close(pstmt);
    }
    
    return result;
}
```

**전체 흐름 이해:**
1. 사용자가 폼에서 상품 정보와 이미지를 입력
2. 서버에서 파일 업로드와 폼 데이터 처리
3. 받은 정보로 ProductDTO 객체 생성
4. DAO를 통해 데이터베이스에 저장
5. 결과에 따라 성공/실패 페이지로 이동

### 연습 2: 경매 입찰 기능 따라 읽기

**1단계: 입찰 버튼 클릭 (JavaScript)**
```javascript
function placeBid() {
    const bidAmount = document.getElementById('bidAmount').value;
    const productId = document.getElementById('productId').value;
    
    // 입찰 금액 검증
    if (bidAmount <= currentPrice) {
        alert('현재가보다 높은 금액을 입력하세요.');
        return;
    }
    
    // 서버로 전송
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'bidAction.jsp';
    
    const productIdInput = document.createElement('input');
    productIdInput.type = 'hidden';
    productIdInput.name = 'productId';
    productIdInput.value = productId;
    
    const bidAmountInput = document.createElement('input');
    bidAmountInput.type = 'hidden';
    bidAmountInput.name = 'bidAmount';
    bidAmountInput.value = bidAmount;
    
    form.appendChild(productIdInput);
    form.appendChild(bidAmountInput);
    document.body.appendChild(form);
    form.submit();
}
```

**2단계: 입찰 처리 (bidAction.jsp)**
```jsp
<%
    // 파라미터 받기
    int productId = Integer.parseInt(request.getParameter("productId"));
    int bidAmount = Integer.parseInt(request.getParameter("bidAmount"));
    String bidderId = (String) session.getAttribute("sid");
    
    // 로그인 확인
    if (bidderId == null) {
        session.setAttribute("alertMsg", "로그인이 필요합니다.");
        response.sendRedirect("../member/loginForm.jsp");
        return;
    }
    
    Connection conn = null;
    try {
        conn = getConnection();
        conn.setAutoCommit(false);  // 트랜잭션 시작
        
        // 입찰 정보 생성
        BidDTO bid = new BidDTO();
        bid.setProductId(productId);
        bid.setMemberId(bidderId);
        bid.setBidPrice(bidAmount);
        
        // 입찰 저장
        BidDAO bidDAO = new BidDAO();
        int bidResult = bidDAO.insertBid(conn, bid);
        
        // 상품 현재가 업데이트
        ProductDAO productDAO = new ProductDAO();
        int updateResult = productDAO.updateCurrentPrice(conn, productId, bidAmount);
        
        if (bidResult > 0 && updateResult > 0) {
            commit(conn);
            session.setAttribute("alertMsg", "입찰이 완료되었습니다.");
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "입찰에 실패했습니다.");
        }
        
    } catch (Exception e) {
        rollback(conn);
        session.setAttribute("alertMsg", "입찰 처리 중 오류가 발생했습니다.");
        e.printStackTrace();
    } finally {
        close(conn);
    }
    
    response.sendRedirect("auctionDetail.jsp?productId=" + productId);
%>
```

**전체 흐름 이해:**
1. 사용자가 입찰 금액을 입력하고 버튼 클릭
2. JavaScript에서 입력값 검증
3. 폼을 동적으로 생성해서 서버로 전송
4. 서버에서 로그인 상태 확인
5. 트랜잭션으로 입찰 정보 저장과 현재가 업데이트를 동시에 처리
6. 성공/실패에 따라 적절한 메시지와 함께 페이지 이동

## 💡 코드 읽기 팁

### 1. 모르는 메서드나 클래스 만났을 때
```java
// 모르는 메서드 예시
String hashedPassword = SHA256.encrypt(password);
```

**해결 방법:**
1. 메서드 이름으로 추측: `encrypt`는 "암호화"를 의미
2. 파라미터와 반환값으로 추측: `String`을 받아서 `String`을 반환
3. 실제 SHA256 클래스 찾아서 확인
4. 주석이나 문서 확인

### 2. 복잡한 SQL 쿼리 읽기
```sql
SELECT * FROM (
    SELECT ROWNUM AS RNUM, A.* FROM (
        SELECT P.PRODUCT_ID, P.PRODUCT_NAME, P.CURRENT_PRICE
        FROM PRODUCT P
        WHERE P.STATUS = 'A'
        ORDER BY P.END_TIME ASC
    ) A
) WHERE RNUM BETWEEN ? AND ?
```

**읽기 전략:**
1. **가장 안쪽부터**: `SELECT P.PRODUCT_ID...` 부터 읽기
2. **바깥쪽으로**: `SELECT ROWNUM...` 읽기
3. **전체 목적 파악**: 페이징을 위한 쿼리임을 이해

### 3. 조건문이 복잡할 때
```java
if (loginUser != null && 
    loginUser.getMemberType() == 2 && 
    System.currentTimeMillis() < auctionEndTime) {
    // VIP 회원이고 경매가 아직 진행 중일 때만 실행
}
```

**읽기 전략:**
1. **각 조건을 한국어로 번역**:
   - `loginUser != null`: 로그인한 사용자가 있고
   - `loginUser.getMemberType() == 2`: 그 사용자가 VIP 회원이고
   - `System.currentTimeMillis() < auctionEndTime`: 경매가 아직 끝나지 않았을 때
2. **전체 조건 이해**: 모든 조건이 참일 때만 실행

### 4. 반복문 읽기
```java
for (ProductDTO product : productList) {
    if (product.getStatus().equals("A")) {
        activeProducts.add(product);
    }
}
```

**읽기 전략:**
1. **반복 대상**: `productList`의 각 상품에 대해
2. **반복 변수**: 각 상품을 `product`라고 부름
3. **반복 내용**: 상품 상태가 "A"인 것만 `activeProducts`에 추가

## 🎯 마무리: 코드 읽기 실력 늘리기

### 1. 단계별 학습 방법
1. **1단계**: 한 줄씩 읽으면서 한국어로 번역
2. **2단계**: 메서드 단위로 읽으면서 전체 흐름 파악
3. **3단계**: 클래스 단위로 읽으면서 역할과 책임 이해
4. **4단계**: 여러 파일 간의 연결 관계 파악

### 2. 실습 방법
1. **따라 읽기**: 이 문서의 예시를 따라 읽어보기
2. **직접 읽기**: 프로젝트의 다른 파일들을 스스로 읽어보기
3. **설명하기**: 읽은 코드를 다른 사람에게 설명해보기
4. **수정하기**: 작은 기능을 추가하거나 수정해보기

### 3. 도움이 되는 도구들
- **IDE의 기능 활용**: 메서드 정의로 이동, 사용처 찾기
- **디버거 사용**: 실행 흐름을 단계별로 따라가기
- **주석 작성**: 이해한 내용을 주석으로 남기기
- **플로우차트 그리기**: 복잡한 로직을 그림으로 표현하기

기억하세요: 코드 읽기는 마치 외국어 책을 읽는 것과 같습니다. 처음에는 사전을 찾아가며 천천히 읽어야 하지만, 연습을 통해 점점 빠르고 정확하게 읽을 수 있게 됩니다! 🚀