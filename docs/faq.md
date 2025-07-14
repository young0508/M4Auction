# ❓ 초보자 FAQ: 자주 묻는 질문과 답변

## 🚀 프로젝트 설정 및 실행 관련

### Q1: 이 프로젝트를 실행하려면 무엇이 필요한가요?
**A:** 필요한 것들:
1. **Java 8 이상** - 프로그래밍 언어
2. **Eclipse 또는 IntelliJ** - 코드 편집기
3. **Oracle Database** - 데이터 저장소
4. **Apache Tomcat** - 웹 서버
5. **웹 브라우저** - 크롬, 파이어폭스 등

**실생활 비유**: 요리를 하려면 가스레인지, 냄비, 재료가 필요한 것처럼!

### Q2: 프로젝트를 처음 실행했는데 에러가 나요!
**A:** 가장 흔한 원인들:

**1. 데이터베이스 연결 실패**
```
에러 메시지: SQLException: Connection refused
해결방법: 
1. Oracle 데이터베이스가 실행 중인지 확인
2. driver.properties 파일의 DB 정보 확인
3. 포트 번호와 서비스명 확인
```

**2. 라이브러리 없음**
```
에러 메시지: ClassNotFoundException
해결방법:
1. WEB-INF/lib 폴더에 필요한 jar 파일들 확인
2. ojdbc17.jar (Oracle 연결용)
3. gson-2.10.1.jar (JSON 처리용)
4. cos.jar (파일 업로드용)
```

**3. 포트 충돌**
```
에러 메시지: Port 8080 already in use
해결방법:
1. 다른 프로그램이 8080 포트를 사용 중
2. Tomcat 서버 포트를 8081로 변경
3. 또는 다른 프로그램 종료
```

### Q3: 데이터베이스 테이블이 없다고 나와요!
**A:** 테이블을 만들어야 합니다:

**1. 기본 테이블 생성**
```sql
-- 1. 회원 테이블
CREATE TABLE USERS (
    MEMBER_ID VARCHAR2(50) PRIMARY KEY,
    MEMBER_PWD VARCHAR2(100) NOT NULL,
    MEMBER_NAME VARCHAR2(100) NOT NULL,
    EMAIL VARCHAR2(200) NOT NULL,
    MILEAGE NUMBER DEFAULT 0,
    MEMBER_TYPE NUMBER DEFAULT 1
);

-- 2. 상품 테이블
CREATE TABLE PRODUCT (
    PRODUCT_ID NUMBER PRIMARY KEY,
    PRODUCT_NAME VARCHAR2(500) NOT NULL,
    START_PRICE NUMBER NOT NULL,
    CURRENT_PRICE NUMBER DEFAULT 0,
    STATUS VARCHAR2(1) DEFAULT 'P'
);

-- 3. 시퀀스 생성
CREATE SEQUENCE SEQ_PRODUCT_ID START WITH 1 INCREMENT BY 1;
```

**2. database 폴더의 SQL 파일들 실행**
- `create_vip_tables.sql`
- `create_wishlist_table.sql`
- `create_transaction_log_table.sql`

## 💻 코드 이해 관련

### Q4: DTO, DAO가 뭔가요? 너무 헷갈려요!
**A:** 간단하게 기억하세요:

**DTO (Data Transfer Object)**
```java
// 데이터를 담는 상자
public class MemberDTO {
    private String memberId;    // 아이디 담는 칸
    private String memberName;  // 이름 담는 칸
    private String email;       // 이메일 담는 칸
}
```
**실생활 비유**: 택배 상자 (물건을 담아서 전달)

**DAO (Data Access Object)**
```java
// 데이터베이스와 일하는 직원
public class MemberDAO {
    public MemberDTO loginMember(...) {
        // 데이터베이스에서 회원 정보 찾기
    }
    
    public int enrollMember(...) {
        // 데이터베이스에 회원 정보 저장
    }
}
```
**실생활 비유**: 은행 창구 직원 (고객 요청을 처리)

### Q5: JSP 파일에서 <% %> 이게 뭔가요?
**A:** 이것은 **스크립틀릿(Scriptlet)**입니다:

```jsp
<html>
<body>
    <h1>안녕하세요!</h1>
    
    <%
        // 이 안은 자바 코드 영역
        String name = "홍길동";
        int age = 25;
        
        if (age >= 20) {
            out.println("성인입니다.");
        }
    %>
    
    <p>이름: <%= name %></p>  <!-- 변수 값 출력 -->
    <p>나이: <%= age %>세</p>
</body>
</html>
```

**기억하기 쉬운 방법:**
- `<% %>` : 자바 코드 실행
- `<%= %>` : 변수 값 출력
- 나머지는 HTML

### Q6: SQL 쿼리문이 너무 어려워요!
**A:** 자주 사용하는 패턴만 기억하세요:

**1. 데이터 조회 (SELECT)**
```sql
-- 기본 형태
SELECT [원하는 칼럼] FROM [테이블명] WHERE [조건];

-- 예시
SELECT * FROM USERS WHERE MEMBER_ID = 'hong123';
-- 해석: USERS 테이블에서 MEMBER_ID가 'hong123'인 모든 정보 가져오기
```

**2. 데이터 추가 (INSERT)**
```sql
-- 기본 형태
INSERT INTO [테이블명] ([칼럼들]) VALUES ([값들]);

-- 예시
INSERT INTO USERS (MEMBER_ID, MEMBER_NAME, EMAIL) 
VALUES ('hong123', '홍길동', 'hong@email.com');
-- 해석: USERS 테이블에 새로운 회원 정보 추가
```

**3. 데이터 수정 (UPDATE)**
```sql
-- 기본 형태
UPDATE [테이블명] SET [칼럼] = [새값] WHERE [조건];

-- 예시
UPDATE USERS SET MEMBER_NAME = '홍길순' WHERE MEMBER_ID = 'hong123';
-- 해석: hong123 회원의 이름을 '홍길순'으로 변경
```

### Q7: 왜 이렇게 파일이 많아요? 하나로 합칠 수 없나요?
**A:** 파일을 나누는 이유:

**1. 역할 분담**
```
index.jsp → 메인 페이지 담당
loginForm.jsp → 로그인 화면 담당
MemberDAO.java → 회원 관련 DB 작업 담당
```

**2. 유지보수 편의성**
```
로그인 기능 수정 → loginForm.jsp, loginAction.jsp만 수정
회원 DB 구조 변경 → MemberDAO.java만 수정
```

**3. 팀 작업 효율성**
```
A팀원 → 화면 디자인 (JSP)
B팀원 → 데이터베이스 로직 (DAO)
C팀원 → 비즈니스 로직 (Service)
```

**실생활 비유**: 식당에서 홀 직원, 주방 직원, 계산 직원을 나누는 것과 같음

## 🐛 자주 발생하는 에러와 해결법

### Q8: "java.lang.NullPointerException"가 계속 나와요!
**A:** 가장 흔한 초보자 에러입니다:

**원인:** 변수가 null인 상태에서 메서드를 호출
```java
// 에러 발생 코드
String name = null;
int length = name.length(); // NullPointerException 발생!
```

**해결 방법:**
```java
// 방법 1: null 체크
String name = getUserName();
if (name != null) {
    int length = name.length(); // 안전
}

// 방법 2: 기본값 설정
String name = getUserName();
if (name == null) {
    name = "기본값";
}
int length = name.length(); // 안전
```

**경매 프로젝트에서 자주 발생하는 경우:**
```java
// 로그인하지 않은 상태에서 세션 접근
MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
String memberId = loginUser.getMemberId(); // 에러!

// 해결
MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
if (loginUser != null) {
    String memberId = loginUser.getMemberId(); // 안전
}
```

### Q9: 한글이 깨져서 나와요!
**A:** 인코딩 문제입니다:

**1. JSP 파일 상단에 추가**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
```

**2. HTML meta 태그 추가**
```html
<meta charset="UTF-8">
```

**3. 데이터베이스 연결 시 인코딩 지정**
```java
// driver.properties 파일
url=jdbc:oracle:thin:@localhost:1521:xe?characterEncoding=UTF-8
```

**4. 폼 전송 시 인코딩 설정**
```jsp
<%
    request.setCharacterEncoding("UTF-8");
%>
```

### Q10: 이미지가 안 보여요!
**A:** 이미지 경로 문제입니다:

**1. 이미지 저장 경로 확인**
```java
// 이미지가 저장되는 실제 경로
String uploadPath = request.getServletContext().getRealPath("/resources/product_images/");
```

**2. JSP에서 이미지 경로 설정**
```jsp
<!-- 올바른 방법 -->
<img src="<%=request.getContextPath()%>/resources/product_images/<%=product.getImageRenamedName()%>" alt="상품 이미지">

<!-- 잘못된 방법 -->
<img src="/resources/product_images/<%=product.getImageRenamedName()%>" alt="상품 이미지">
```

**3. 이미지 파일 존재 확인**
```java
// 파일 존재 여부 확인
File imageFile = new File(uploadPath + fileName);
if (!imageFile.exists()) {
    System.out.println("이미지 파일이 존재하지 않습니다: " + fileName);
}
```

### Q11: 데이터베이스에 데이터가 저장되지 않아요!
**A:** 트랜잭션 문제일 가능성이 높습니다:

**1. 자동 커밋 확인**
```java
Connection conn = getConnection();
conn.setAutoCommit(false); // 자동 커밋 비활성화

// 데이터 작업 수행
int result = dao.insertData(conn, data);

if (result > 0) {
    commit(conn);  // 수동으로 커밋
} else {
    rollback(conn); // 실패 시 롤백
}
```

**2. SQL 쿼리 확인**
```java
// 쿼리 실행 결과 확인
int result = pstmt.executeUpdate();
System.out.println("쿼리 실행 결과: " + result + "건 처리됨");
```

**3. 예외 처리 확인**
```java
try {
    // 데이터 작업
} catch (SQLException e) {
    e.printStackTrace(); // 에러 메시지 출력
    System.out.println("에러 발생: " + e.getMessage());
}
```

## 🎯 프로젝트 구조 관련

### Q12: 이 프로젝트는 어떤 패턴으로 만들어졌나요?
**A:** **JSP Model 2 아키텍처**를 사용했습니다:

**데이터 계층 (Model 역할)**
```
src/main/java/com/auction/
├── dto/          → 데이터 구조
├── dao/          → 데이터베이스 접근
└── common/       → 공통 기능
```

**화면 계층 (View)**
```
src/main/webapp/
├── index.jsp           → 메인 페이지
├── member/            → 회원 관련 화면
├── product/           → 상품 관련 화면
└── resources/         → CSS, JS, 이미지
```

**처리 계층 (Controller 역할 - JSP가 담당)**
```
src/main/webapp/
├── member/loginAction.jsp       → 로그인 처리
├── product/productEnrollAction.jsp → 상품 등록 처리
└── auction/bidAction.jsp        → 입찰 처리
```

**⚠️ 중요**: 완전한 MVC 패턴은 아니고, 전통적인 JSP 방식입니다.

### Q13: 왜 JSP에서 직접 데이터베이스 작업을 하나요? Spring MVC를 쓰는 게 좋지 않나요?
**A:** 학습 단계에 따른 차이입니다:

**현재 방식 (JSP Model 2)
```jsp
<!-- loginAction.jsp -->
<%
    String userId = request.getParameter("userId");
    Connection conn = getConnection();
    MemberDAO dao = new MemberDAO();
    MemberDTO user = dao.loginMember(conn, userId, userPwd);
    
    if (user != null) {
        session.setAttribute("loginUser", user);
        response.sendRedirect("../index.jsp");
    }
%>
```

**장점:**
- 동작 원리를 직접 볼 수 있음
- 설정이 간단함
- 학습하기 쉬움

**Spring MVC 방식 (진짜 MVC 패턴)**
```java
@Controller
@RequestMapping("/member")
public class MemberController {
    @Autowired
    private MemberService memberService;
    
    @PostMapping("/login")
    public String login(@ModelAttribute LoginForm form, HttpSession session) {
        MemberDTO user = memberService.login(form.getUserId(), form.getUserPwd());
        if (user != null) {
            session.setAttribute("loginUser", user);
            return "redirect:/index";
        }
        return "member/loginForm";
    }
}
```

**장점:**
- 더 체계적이고 안전함
- 대규모 프로젝트에 적합
- 실무에서 많이 사용

**결론:** 학습 단계에서는 JSP Model 2가 이해하기 쉬우고, 실무에서는 Spring MVC를 사용하는 것이 좋습니다.

### Q14: 보안은 어떻게 처리되나요?
**A:** 이 프로젝트의 보안 기능들:

**1. 비밀번호 암호화**
```java
// SHA256으로 비밀번호 암호화
String encryptedPwd = SHA256.encrypt(userPwd);
```

**2. 세션 관리**
```java
// 로그인 상태 확인
MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
if (loginUser == null) {
    response.sendRedirect("loginForm.jsp");
    return;
}
```

**3. SQL 인젝션 방지**
```java
// PreparedStatement 사용
String sql = "SELECT * FROM USERS WHERE MEMBER_ID = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, userId); // 안전한 방법
```

**4. 파일 업로드 보안**
```java
// 허용된 확장자만 업로드
String fileName = uploadFile.getOriginalFilename();
String ext = fileName.substring(fileName.lastIndexOf("."));
if (!Arrays.asList(".jpg", ".jpeg", ".png").contains(ext.toLowerCase())) {
    throw new RuntimeException("허용되지 않는 파일 형식입니다.");
}
```

## 🚀 기능 구현 관련

### Q15: 새로운 기능을 추가하고 싶은데 어떻게 해야 하나요?
**A:** 단계별로 진행하세요:

**예시: 상품 리뷰 기능 추가**

**1단계: 데이터베이스 테이블 생성**
```sql
CREATE TABLE REVIEW (
    REVIEW_ID NUMBER PRIMARY KEY,
    PRODUCT_ID NUMBER NOT NULL,
    MEMBER_ID VARCHAR2(50) NOT NULL,
    REVIEW_CONTENT VARCHAR2(2000),
    RATING NUMBER(1),
    REVIEW_DATE DATE DEFAULT SYSDATE,
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID),
    FOREIGN KEY (MEMBER_ID) REFERENCES USERS(MEMBER_ID)
);
```

**2단계: DTO 클래스 생성**
```java
public class ReviewDTO {
    private int reviewId;
    private int productId;
    private String memberId;
    private String reviewContent;
    private int rating;
    private Date reviewDate;
    
    // getter, setter 메서드들...
}
```

**3단계: DAO 클래스 생성**
```java
public class ReviewDAO {
    public int insertReview(Connection conn, ReviewDTO review) {
        // 리뷰 저장 로직
    }
    
    public List<ReviewDTO> selectReviewsByProduct(Connection conn, int productId) {
        // 상품별 리뷰 조회 로직
    }
}
```

**4단계: 리뷰 입력 폼 생성**
```jsp
<!-- reviewForm.jsp -->
<form action="reviewAction.jsp" method="post">
    <input type="hidden" name="productId" value="<%=productId%>">
    <textarea name="reviewContent" placeholder="리뷰를 작성해주세요"></textarea>
    <select name="rating">
        <option value="5">★★★★★</option>
        <option value="4">★★★★</option>
        <option value="3">★★★</option>
        <option value="2">★★</option>
        <option value="1">★</option>
    </select>
    <button type="submit">리뷰 작성</button>
</form>
```

**5단계: 리뷰 처리 로직 생성**
```jsp
<!-- reviewAction.jsp -->
<%
    int productId = Integer.parseInt(request.getParameter("productId"));
    String reviewContent = request.getParameter("reviewContent");
    int rating = Integer.parseInt(request.getParameter("rating"));
    String memberId = (String) session.getAttribute("sid");
    
    ReviewDTO review = new ReviewDTO();
    review.setProductId(productId);
    review.setMemberId(memberId);
    review.setReviewContent(reviewContent);
    review.setRating(rating);
    
    Connection conn = getConnection();
    ReviewDAO dao = new ReviewDAO();
    int result = dao.insertReview(conn, review);
    
    if (result > 0) {
        response.sendRedirect("productDetail.jsp?productId=" + productId);
    }
%>
```

### Q16: 실시간 기능은 어떻게 구현하나요?
**A:** 여러 방법이 있습니다:

**1. JavaScript 타이머 사용 (간단한 방법)**
```javascript
// 3초마다 현재 입찰가 업데이트
setInterval(function() {
    fetch('getCurrentPrice.jsp?productId=' + productId)
        .then(response => response.json())
        .then(data => {
            document.getElementById('currentPrice').textContent = data.currentPrice;
        });
}, 3000);
```

**2. WebSocket 사용 (실시간 방법)**
```java
// WebSocket 서버 (고급 기능)
@ServerEndpoint("/auction/{productId}")
public class AuctionWebSocket {
    @OnMessage
    public void onMessage(String message, Session session) {
        // 새로운 입찰 정보를 모든 클라이언트에게 전송
    }
}
```

**3. AJAX 폴링 (현재 프로젝트에 적합)**
```javascript
function updateAuctionInfo() {
    $.ajax({
        url: 'getAuctionInfo.jsp',
        method: 'GET',
        data: { productId: productId },
        success: function(data) {
            $('#currentPrice').text(data.currentPrice);
            $('#bidCount').text(data.bidCount);
            $('#timeLeft').text(data.timeLeft);
        }
    });
}

// 5초마다 업데이트
setInterval(updateAuctionInfo, 5000);
```

## 🎓 학습 방향 관련

### Q17: 이 프로젝트를 다 이해하면 다음에 무엇을 배워야 하나요?
**A:** 단계별 학습 로드맵:

**1단계: 현재 기술 심화**
- **Java**: 컬렉션, 제네릭, 람다식
- **JSP/Servlet**: 필터, 리스너, 커스텀 태그
- **SQL**: 조인, 서브쿼리, 인덱스 최적화
- **JavaScript**: ES6+, 비동기 처리

**2단계: 전통 기술 심화**
- **Servlet/JSP 심화**: 필터, 리스너, 세션 관리
- **JDBC 최적화**: 커넥션 풀, 트랜잭션 관리
- **JavaScript/AJAX**: 비동기 통신, DOM 조작
- **SQL 심화**: 인덱스, 성능 최적화

**3단계: 현대적 프레임워크**
- **Spring Framework**: 의존성 주입, AOP (현재 프로젝트 기반에 도입)
- **Spring MVC**: 진짜 MVC 패턴 구현
- **MyBatis**: SQL 매퍼로 JDBC 코드 간소화
- **REST API**: RESTful 서비스 설계

**4단계: 최신 기술 스택**
- **Spring Boot**: 자동 설정, 마이크로서비스
- **React/Vue.js**: 모던 프론트엔드
- **JPA/Hibernate**: 객체 관계 매핑
- **Docker/Kubernetes**: 컸테이너화

**4단계: 실무 기술**
- **Git**: 버전 관리
- **Docker**: 컨테이너화
- **AWS**: 클라우드 서비스
- **CI/CD**: 자동화 배포

### Q18: 취업할 때 이 프로젝트가 도움이 될까요?
**A:** 매우 도움이 됩니다!

**포트폴리오 어필 포인트:**
1. **전체 개발 프로세스 이해**: 기획부터 배포까지
2. **데이터베이스 설계**: 테이블 관계, 정규화
3. **웹 개발 기초**: HTML, CSS, JavaScript, JSP
4. **Java 객체지향 프로그래밍**: 클래스, 상속, 다형성
5. **JSP Model 2 아키텍처**: 간단한 구조적 설계

**면접에서 예상 질문:**
- "이 프로젝트에서 가장 어려웠던 점은?"
- "데이터베이스 설계 시 고려한 점은?"
- "보안은 어떻게 처리했나요?"
- "성능 최적화는 어떻게 했나요?"

**개선 방향:**
- 단위 테스트 추가
- 로깅 시스템 도입
- 예외 처리 강화
- 코드 리팩토링

### Q19: 에러가 났을 때 어떻게 디버깅해야 하나요?
**A:** 체계적인 디버깅 방법:

**1. 에러 메시지 분석**
```java
// 에러 스택 트레이스 읽기
java.sql.SQLException: ORA-00942: table or view does not exist
    at oracle.jdbc.driver.T4CTTIoer.processError(T4CTTIoer.java:445)
    at com.auction.dao.MemberDAO.loginMember(MemberDAO.java:25)
    
// 해석: 25번 줄에서 테이블이 없다는 에러
```

**2. 로그 출력으로 디버깅**
```java
public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
    System.out.println("로그인 시도: " + userId); // 디버깅용
    
    String sql = "SELECT * FROM USERS WHERE MEMBER_ID = ?";
    System.out.println("실행할 쿼리: " + sql); // 디버깅용
    
    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        System.out.println("쿼리 실행 전"); // 디버깅용
        
        rs = pstmt.executeQuery();
        System.out.println("쿼리 실행 후"); // 디버깅용
        
        if (rs.next()) {
            System.out.println("사용자 발견: " + rs.getString("MEMBER_NAME"));
            // ...
        } else {
            System.out.println("사용자 없음");
        }
    } catch (SQLException e) {
        System.out.println("SQL 에러: " + e.getMessage()); // 디버깅용
        e.printStackTrace();
    }
}
```

**3. 브라우저 개발자 도구 활용**
```javascript
// 콘솔에서 변수 값 확인
console.log("입찰 금액:", bidAmount);
console.log("상품 ID:", productId);

// 네트워크 탭에서 요청/응답 확인
fetch('/auction/placeBid.jsp', {
    method: 'POST',
    body: formData
})
.then(response => {
    console.log("응답 상태:", response.status);
    return response.text();
})
.then(data => {
    console.log("응답 데이터:", data);
});
```

**4. 단계별 확인**
```
1. 폼 데이터가 제대로 전송되는가?
2. 파라미터가 올바르게 받아지는가?
3. 데이터베이스 연결은 정상인가?
4. SQL 쿼리는 올바른가?
5. 결과 처리가 제대로 되는가?
```

### Q20: 이 프로젝트를 어떻게 개선할 수 있나요?
**A:** 개선 방향들:

**1. 코드 품질 개선**
```java
// 현재: 하드코딩
String sql = "SELECT * FROM USERS WHERE MEMBER_ID = 'hong123'";

// 개선: 상수 사용
public class SqlConstants {
    public static final String SELECT_USER_BY_ID = 
        "SELECT * FROM USERS WHERE MEMBER_ID = ?";
}
```

**2. 예외 처리 강화**
```java
// 현재: 단순 출력
catch (SQLException e) {
    e.printStackTrace();
}

// 개선: 로깅과 사용자 친화적 메시지
catch (SQLException e) {
    logger.error("회원 조회 실패", e);
    throw new ServiceException("회원 정보를 불러올 수 없습니다.", e);
}
```

**3. 성능 최적화**
```java
// 현재: 매번 DB 조회
public List<ProductDTO> getProductList() {
    return productDAO.selectAllProducts(conn);
}

// 개선: 캐싱 적용
public List<ProductDTO> getProductList() {
    String cacheKey = "product_list";
    List<ProductDTO> cachedList = cache.get(cacheKey);
    
    if (cachedList == null) {
        cachedList = productDAO.selectAllProducts(conn);
        cache.put(cacheKey, cachedList, 300); // 5분 캐싱
    }
    
    return cachedList;
}
```

**4. 보안 강화**
```java
// 현재: 기본 세션 관리
session.setAttribute("loginUser", user);

// 개선: 세션 보안 강화
session.setAttribute("loginUser", user);
session.setMaxInactiveInterval(1800); // 30분 후 자동 로그아웃
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
```

**5. 테스트 코드 추가**
```java
// 단위 테스트 예시
@Test
public void testLoginMember() {
    // Given
    String userId = "testuser";
    String userPwd = "testpass";
    
    // When
    MemberDTO result = memberDAO.loginMember(conn, userId, userPwd);
    
    // Then
    assertNotNull(result);
    assertEquals(userId, result.getMemberId());
}
```

---

이 FAQ를 통해 초보자들이 자주 겪는 문제들과 궁금증을 해결할 수 있기를 바랍니다. 

**중요한 것은 에러를 두려워하지 말고, 하나씩 차근차근 해결해 나가는 것입니다!** 🚀

**추가 질문이 있으면 언제든지 물어보세요!**