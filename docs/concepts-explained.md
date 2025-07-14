# 🎯 개념 정리 자료: 핵심 개념을 예시와 함께 설명

## 🏗️ 소프트웨어 아키텍처 패턴

### 1. JSP Model 2 아키텍처

#### 🤔 JSP Model 2가 무엇인가요?
이 프로젝트는 **JSP Model 2 아키텍처**를 사용합니다. 이는 화면과 로직을 어느 정도 분리하는 전통적인 방식입니다.

**실생활 비유: 상점 운영**
- **데이터 처리 (DAO/DTO)**: 창고에서 물건을 관리하는 직원
- **화면 (JSP)**: 고객이 보는 진열대
- **처리 로직 (JSP Action)**: 계산대에서 주문을 처리하는 직원

#### 💡 이 프로젝트에서의 구조
```
데이터 계층 (Model 역할)
├── DTO (데이터 구조)
│   ├── MemberDTO.java - 회원 정보를 담는 틀
│   └── ProductDTO.java - 상품 정보를 담는 틀
├── DAO (데이터 접근)
│   ├── MemberDAO.java - 회원 관련 데이터베이스 작업
│   └── ProductDAO.java - 상품 관련 데이터베이스 작업
└── Common (공통 도구)
    └── JDBCTemplate.java - 데이터베이스 연결 도구

화면 계층 (View)
├── 화면용 JSP 파일들
│   ├── index.jsp - 메인 페이지
│   ├── member/loginForm.jsp - 로그인 화면
│   └── product/productList.jsp - 상품 목록 화면
└── 정적 자원
    ├── CSS - 디자인
    └── JavaScript - 동적 기능

처리 계층 (Controller 역할)
├── 처리용 JSP 파일들
│   ├── member/loginAction.jsp - 로그인 처리
│   └── product/productEnrollAction.jsp - 상품 등록 처리
└── 스케줄러
    └── AuctionScheduler.java - 경매 자동 마감
```

#### 🎯 왜 이런 구조를 사용하나요?
1. **역할 분담**: 화면 담당 JSP와 데이터 처리 담당 클래스 분리
2. **유지보수 용이성**: 화면 수정과 데이터 로직 수정을 독립적으로 가능
3. **코드 재사용**: DAO와 DTO는 여러 JSP에서 공통으로 사용 가능

#### ⚠️ 완전한 MVC 패턴과의 차이점
- **실제 MVC**: 별도의 Controller 클래스가 모든 요청을 처리
- **이 프로젝트**: JSP 파일이 화면과 제어 역할을 함께 담당
- **장점**: 간단하고 이해하기 쉬움
- **단점**: 복잡한 프로젝트에서는 관리가 어려움

### 2. DAO 패턴 (Data Access Object)

#### 🤔 DAO 패턴이 무엇인가요?
데이터베이스와 관련된 모든 작업을 전담하는 클래스를 만드는 패턴입니다.

**실생활 비유: 은행 창구 직원**
- 고객(프로그램)이 돈을 입금하고 싶으면 창구 직원(DAO)에게 요청
- 창구 직원이 실제 금고(데이터베이스)에 접근해서 작업 수행
- 고객은 금고 내부 구조를 몰라도 됨

#### 💡 MemberDAO 예시
```java
public class MemberDAO {
    // 로그인 처리
    public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
        // 1. SQL 쿼리 준비
        String sql = "SELECT * FROM USERS WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";
        
        // 2. 데이터베이스에서 조회
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, userPwd);
        
        // 3. 결과 처리
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            // 회원 정보를 DTO에 담아서 반환
            MemberDTO member = new MemberDTO();
            member.setMemberId(rs.getString("MEMBER_ID"));
            member.setMemberName(rs.getString("MEMBER_NAME"));
            return member;
        }
        
        return null; // 로그인 실패
    }
}
```

#### 🎯 왜 DAO 패턴을 사용하나요?
1. **관심사의 분리**: 데이터베이스 로직과 비즈니스 로직 분리
2. **코드 재사용**: 같은 데이터베이스 작업을 여러 곳에서 사용
3. **유지보수 용이**: 데이터베이스 구조 변경 시 DAO만 수정하면 됨

### 3. DTO 패턴 (Data Transfer Object)

#### 🤔 DTO 패턴이 무엇인가요?
데이터를 전달하기 위한 객체를 만드는 패턴입니다.

**실생활 비유: 택배 상자**
- 여러 물건을 하나의 상자에 담아서 배송
- 상자 안에 무엇이 들어있는지 라벨로 표시
- 받는 사람은 상자를 열어서 내용물 확인

#### 💡 MemberDTO 예시
```java
public class MemberDTO {
    // 회원 정보를 담는 필드들
    private String memberId;      // 회원 ID
    private String memberName;    // 회원 이름
    private String email;         // 이메일
    private long mileage;         // 마일리지
    private boolean isVip;        // VIP 여부
    
    // 생성자
    public MemberDTO() {}
    
    // Getter/Setter 메서드들
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }
    // ... 다른 필드들도 동일
}
```

#### 🎯 왜 DTO 패턴을 사용하나요?
1. **데이터 캡슐화**: 관련된 데이터를 하나로 묶음
2. **타입 안정성**: 잘못된 데이터 타입 사용 방지
3. **전송 효율성**: 여러 데이터를 한 번에 전송

## 🗄️ 데이터베이스 핵심 개념

### 1. 관계형 데이터베이스 (RDBMS)

#### 🤔 관계형 데이터베이스란?
데이터를 표(테이블) 형태로 저장하고, 테이블 간의 관계를 통해 데이터를 관리하는 시스템입니다.

**실생활 비유: 도서관 관리 시스템**
- **책 정보 테이블**: 책 제목, 저자, 출판사 등
- **대출 정보 테이블**: 누가, 언제, 어떤 책을 빌렸는지
- **회원 정보 테이블**: 도서관 회원들의 정보

#### 💡 이 프로젝트의 주요 테이블들
```sql
-- 회원 테이블
CREATE TABLE USERS (
    MEMBER_ID VARCHAR2(50) PRIMARY KEY,    -- 회원 ID
    MEMBER_NAME VARCHAR2(100) NOT NULL,    -- 이름
    EMAIL VARCHAR2(200) NOT NULL,          -- 이메일
    MILEAGE NUMBER DEFAULT 0,              -- 마일리지
    MEMBER_TYPE NUMBER DEFAULT 1           -- 회원 타입 (1:일반, 2:VIP)
);

-- 상품 테이블
CREATE TABLE PRODUCT (
    PRODUCT_ID NUMBER PRIMARY KEY,         -- 상품 ID
    PRODUCT_NAME VARCHAR2(500) NOT NULL,   -- 상품명
    START_PRICE NUMBER NOT NULL,           -- 시작가
    CURRENT_PRICE NUMBER DEFAULT 0,        -- 현재가
    SELLER_ID VARCHAR2(50) NOT NULL,       -- 판매자 ID
    STATUS VARCHAR2(1) DEFAULT 'P',        -- 상태 (P:대기, A:진행, E:종료)
    FOREIGN KEY (SELLER_ID) REFERENCES USERS(MEMBER_ID)
);

-- 입찰 테이블
CREATE TABLE BID (
    BID_ID NUMBER PRIMARY KEY,             -- 입찰 ID
    PRODUCT_ID NUMBER NOT NULL,            -- 상품 ID
    BIDDER_ID VARCHAR2(50) NOT NULL,       -- 입찰자 ID
    BID_PRICE NUMBER NOT NULL,             -- 입찰가
    BID_TIME DATE DEFAULT SYSDATE,         -- 입찰 시간
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID),
    FOREIGN KEY (BIDDER_ID) REFERENCES USERS(MEMBER_ID)
);
```

#### 🎯 관계형 데이터베이스의 장점
1. **데이터 무결성**: 잘못된 데이터 입력 방지
2. **중복 제거**: 같은 데이터를 여러 번 저장하지 않음
3. **복잡한 쿼리**: 여러 테이블의 데이터를 조합해서 조회

### 2. SQL (Structured Query Language)

#### 🤔 SQL이 무엇인가요?
데이터베이스와 대화하기 위한 언어입니다.

**실생활 비유: 도서관에서 사서에게 하는 요청**
- "컴퓨터 관련 책을 모두 찾아주세요" → SELECT
- "새로운 책을 등록해주세요" → INSERT
- "책 정보를 수정해주세요" → UPDATE
- "오래된 책을 폐기해주세요" → DELETE

#### 💡 프로젝트에서 사용하는 SQL 예시

**1. 회원 로그인 확인**
```sql
SELECT * FROM USERS 
WHERE MEMBER_ID = '사용자ID' AND MEMBER_PWD = '비밀번호';
```

**2. 진행 중인 경매 상품 조회**
```sql
SELECT PRODUCT_ID, PRODUCT_NAME, CURRENT_PRICE, END_TIME
FROM PRODUCT 
WHERE STATUS = 'A' 
ORDER BY END_TIME ASC;
```

**3. 입찰 정보 저장**
```sql
INSERT INTO BID (BID_ID, PRODUCT_ID, BIDDER_ID, BID_PRICE, BID_TIME)
VALUES (SEQ_BID_ID.NEXTVAL, 1, 'user123', 50000, SYSDATE);
```

**4. 현재 최고 입찰가 조회**
```sql
SELECT MAX(BID_PRICE) as HIGHEST_BID
FROM BID 
WHERE PRODUCT_ID = 1;
```

### 3. 트랜잭션 (Transaction)

#### 🤔 트랜잭션이 무엇인가요?
여러 개의 데이터베이스 작업을 하나의 논리적 단위로 묶는 것입니다.

**실생활 비유: 은행 송금**
1. 내 계좌에서 돈을 빼기
2. 상대방 계좌에 돈을 넣기

이 두 작업은 둘 다 성공하거나 둘 다 실패해야 합니다. 하나만 성공하면 돈이 사라지거나 복제되는 문제가 발생합니다.

#### 💡 경매 입찰 시 트랜잭션 예시
```java
public boolean processBid(int productId, String bidderId, int bidPrice) {
    Connection conn = null;
    try {
        conn = getConnection();
        conn.setAutoCommit(false); // 트랜잭션 시작
        
        // 1. 입찰 정보 저장
        int bidResult = bidDAO.insertBid(conn, new BidDTO(productId, bidderId, bidPrice));
        
        // 2. 상품의 현재가 업데이트
        int updateResult = productDAO.updateCurrentPrice(conn, productId, bidPrice);
        
        // 3. 입찰자의 마일리지 차감
        int mileageResult = memberDAO.updateMileage(conn, bidderId, -bidPrice);
        
        // 모든 작업이 성공했을 때만 커밋
        if (bidResult > 0 && updateResult > 0 && mileageResult > 0) {
            commit(conn);
            return true;
        } else {
            rollback(conn); // 실패 시 모든 작업 취소
            return false;
        }
    } catch (Exception e) {
        rollback(conn);
        return false;
    } finally {
        close(conn);
    }
}
```

## 🔐 보안 핵심 개념

### 1. 비밀번호 암호화

#### 🤔 왜 비밀번호를 암호화해야 하나요?
데이터베이스가 해킹당해도 실제 비밀번호를 알 수 없게 하기 위해서입니다.

**실생활 비유: 암호문**
- 원본 메시지: "안녕하세요"
- 암호화된 메시지: "xkfn;dlqhgkdy"
- 누가 암호문을 봐도 원본 내용을 알 수 없음

#### 💡 SHA256 암호화 예시
```java
public class SHA256 {
    public static String encrypt(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            
            StringBuffer sb = new StringBuffer();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}

// 사용 예시
String originalPassword = "mypassword123";
String encryptedPassword = SHA256.encrypt(originalPassword);
System.out.println("원본: " + originalPassword);
System.out.println("암호화: " + encryptedPassword);
// 출력: 원본: mypassword123
// 출력: 암호화: a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
```

### 2. 세션 관리

#### 🤔 세션이 무엇인가요?
사용자의 로그인 상태를 서버에서 기억하는 기술입니다.

**실생활 비유: 출입증**
- 회사에 출근할 때 출입증을 받음
- 출입증이 있으면 회사 내부 시설 이용 가능
- 퇴근할 때 출입증을 반납

#### 💡 세션 사용 예시
```java
// 로그인 성공 시 세션 생성
HttpSession session = request.getSession();
session.setAttribute("loginUser", memberDTO);
session.setAttribute("sid", memberDTO.getMemberId());

// 로그인 확인
MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
if (loginUser != null) {
    // 로그인된 사용자만 접근 가능한 기능
    out.println("환영합니다, " + loginUser.getMemberName() + "님!");
} else {
    // 로그인 페이지로 리다이렉트
    response.sendRedirect("loginForm.jsp");
}

// 로그아웃 시 세션 제거
session.invalidate();
```

## 🚀 실시간 처리 개념

### 1. 스케줄러 (Scheduler)

#### 🤔 스케줄러가 무엇인가요?
정해진 시간에 자동으로 특정 작업을 수행하는 프로그램입니다.

**실생활 비유: 알람 시계**
- 매일 오전 7시에 알람이 울림
- 사용자가 직접 눌러야 하는 것이 아니라 자동으로 작동
- 한 번 설정하면 계속 반복

#### 💡 경매 자동 마감 스케줄러 예시
```java
public class AuctionScheduler {
    private ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(5);
    
    public void scheduleAuctionEnd(int productId, Date endTime) {
        long delay = endTime.getTime() - System.currentTimeMillis();
        
        scheduler.schedule(new AuctionCloseTask(productId), delay, TimeUnit.MILLISECONDS);
    }
    
    private class AuctionCloseTask implements Runnable {
        private int productId;
        
        public AuctionCloseTask(int productId) {
            this.productId = productId;
        }
        
        @Override
        public void run() {
            Connection conn = null;
            try {
                conn = getConnection();
                
                // 1. 경매 상태를 '종료'로 변경
                productDAO.updateProductStatus(conn, productId, "E");
                
                // 2. 최고 입찰자 찾기
                BidDTO winner = productDAO.findWinner(conn, productId);
                
                // 3. 낙찰자 정보 업데이트
                if (winner != null) {
                    productDAO.updateProductWinner(conn, productId, 
                                                 winner.getMemberId(), 
                                                 winner.getBidPrice());
                }
                
                commit(conn);
                System.out.println("경매 " + productId + " 자동 마감 완료");
                
            } catch (Exception e) {
                rollback(conn);
                e.printStackTrace();
            } finally {
                close(conn);
            }
        }
    }
}
```

### 2. 실시간 업데이트

#### 🤔 실시간 업데이트가 무엇인가요?
사용자가 페이지를 새로고침하지 않아도 최신 정보가 자동으로 업데이트되는 기술입니다.

**실생활 비유: 전광판**
- 야구장의 스코어보드
- 경기 상황이 바뀔 때마다 자동으로 점수 업데이트
- 관중들이 별도의 행동을 하지 않아도 정보 확인 가능

#### 💡 JavaScript를 이용한 실시간 업데이트 예시
```javascript
// 3초마다 현재 입찰가 업데이트
function updateCurrentPrice() {
    const productId = document.getElementById('productId').value;
    
    fetch('/auction/getCurrentPrice.jsp?productId=' + productId)
        .then(response => response.json())
        .then(data => {
            document.getElementById('currentPrice').textContent = 
                data.currentPrice.toLocaleString() + '원';
            document.getElementById('bidCount').textContent = 
                data.bidCount + '건';
        })
        .catch(error => {
            console.error('업데이트 실패:', error);
        });
}

// 페이지 로드 시 실시간 업데이트 시작
window.onload = function() {
    setInterval(updateCurrentPrice, 3000); // 3초마다 실행
};
```

## 🎨 사용자 경험 (UX) 개념

### 1. 반응형 웹 디자인

#### 🤔 반응형 웹 디자인이 무엇인가요?
화면 크기에 따라 자동으로 레이아웃이 변경되는 웹 디자인입니다.

**실생활 비유: 신축성 있는 옷**
- 다양한 체형에 맞게 늘어나고 줄어듦
- 같은 옷이지만 입는 사람에 따라 다르게 보임
- 편안함과 실용성을 모두 제공

#### 💡 CSS 미디어 쿼리 예시
```css
/* 기본 스타일 (데스크톱) */
.product-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
}

/* 태블릿 크기 */
@media (max-width: 768px) {
    .product-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
    }
}

/* 모바일 크기 */
@media (max-width: 480px) {
    .product-grid {
        grid-template-columns: 1fr;
        gap: 10px;
    }
}
```

### 2. 사용자 친화적 인터페이스

#### 🤔 사용자 친화적 인터페이스란?
사용자가 쉽고 편리하게 이용할 수 있는 화면 구성입니다.

**실생활 비유: 좋은 카페 배치**
- 입구에서 메뉴판을 쉽게 볼 수 있음
- 주문 카운터 위치가 명확함
- 테이블 배치가 자연스러움

#### 💡 사용자 경험 개선 예시
```javascript
// 입찰 시 사용자 피드백
function placeBid() {
    const bidAmount = document.getElementById('bidAmount').value;
    const submitButton = document.getElementById('submitBid');
    
    // 1. 버튼 비활성화로 중복 클릭 방지
    submitButton.disabled = true;
    submitButton.textContent = '입찰 중...';
    
    // 2. 입찰 처리
    fetch('/auction/placeBid.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'productId=' + productId + '&bidAmount=' + bidAmount
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // 3. 성공 메시지 표시
            showNotification('입찰이 성공했습니다!', 'success');
            updateCurrentPrice();
        } else {
            // 4. 실패 메시지 표시
            showNotification('입찰에 실패했습니다: ' + data.message, 'error');
        }
    })
    .finally(() => {
        // 5. 버튼 다시 활성화
        submitButton.disabled = false;
        submitButton.textContent = '입찰하기';
    });
}

// 알림 메시지 표시
function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 3000);
}
```

## 📊 성능 최적화 개념

### 1. 데이터베이스 최적화

#### 🤔 데이터베이스 최적화가 무엇인가요?
데이터베이스 조회 속도를 빠르게 하는 기술입니다.

**실생활 비유: 도서관 색인**
- 책 제목으로 찾기: 색인 카드 사용
- 색인 없이 찾기: 모든 책을 하나씩 확인
- 색인이 있으면 빠르게 찾을 수 있음

#### 💡 인덱스 사용 예시
```sql
-- 인덱스 생성
CREATE INDEX idx_product_status ON PRODUCT(STATUS);
CREATE INDEX idx_bid_product_id ON BID(PRODUCT_ID);

-- 최적화된 쿼리
SELECT P.PRODUCT_NAME, P.CURRENT_PRICE, COUNT(B.BID_ID) as BID_COUNT
FROM PRODUCT P
LEFT JOIN BID B ON P.PRODUCT_ID = B.PRODUCT_ID
WHERE P.STATUS = 'A'  -- 인덱스 사용
GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME, P.CURRENT_PRICE
ORDER BY P.CURRENT_PRICE DESC;
```

### 2. 페이징 (Pagination)

#### 🤔 페이징이 무엇인가요?
많은 데이터를 여러 페이지로 나누어 보여주는 기술입니다.

**실생활 비유: 책의 페이지**
- 모든 내용을 한 페이지에 넣으면 읽기 어려움
- 적당한 분량으로 나누어 여러 페이지에 배치
- 필요한 페이지만 펼쳐서 확인

#### 💡 페이징 구현 예시
```java
public class PageInfo {
    private int currentPage;      // 현재 페이지
    private int boardLimit;       // 한 페이지당 게시물 수
    private int totalCount;       // 전체 게시물 수
    private int maxPage;          // 최대 페이지 수
    
    public PageInfo(int currentPage, int boardLimit, int totalCount) {
        this.currentPage = currentPage;
        this.boardLimit = boardLimit;
        this.totalCount = totalCount;
        this.maxPage = (int) Math.ceil((double) totalCount / boardLimit);
    }
    
    // getter, setter 메서드들...
}

// 페이징 쿼리 (Oracle)
String sql = "SELECT * FROM ("
           + "  SELECT ROWNUM AS RNUM, A.* FROM ("
           + "    SELECT * FROM PRODUCT ORDER BY PRODUCT_ID DESC"
           + "  ) A"
           + ") WHERE RNUM BETWEEN ? AND ?";

int startRow = (currentPage - 1) * boardLimit + 1;
int endRow = startRow + boardLimit - 1;
```

## 🔄 다른 방법들과의 비교

### 1. JSP Model 2 vs Spring MVC Framework

#### JSP Model 2 방식 (현재 프로젝트)
```java
// loginAction.jsp
<%
    String userId = request.getParameter("userId");
    String userPwd = request.getParameter("userPwd");
    
    Connection conn = getConnection();
    MemberDAO memberDAO = new MemberDAO();
    MemberDTO loginUser = memberDAO.loginMember(conn, userId, userPwd);
    
    if (loginUser != null) {
        session.setAttribute("loginUser", loginUser);
        response.sendRedirect("../index.jsp");
    } else {
        session.setAttribute("alertMsg", "로그인에 실패했습니다.");
        response.sendRedirect("loginForm.jsp");
    }
%>
```

#### Spring MVC Framework 방식
```java
@Controller
@RequestMapping("/member")
public class MemberController {
    
    @Autowired
    private MemberService memberService;
    
    @PostMapping("/login")
    public String login(@RequestParam String userId, 
                       @RequestParam String userPwd,
                       HttpSession session, 
                       Model model) {
        
        MemberDTO loginUser = memberService.loginMember(userId, userPwd);
        
        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            return "redirect:/index";
        } else {
            model.addAttribute("alertMsg", "로그인에 실패했습니다.");
            return "member/loginForm";
        }
    }
}
```

**비교 결과:**
- **JSP Model 2**: 간단하고 직관적, 소규모 프로젝트에 적합
- **Spring MVC**: 진짜 MVC 패턴, 대규모 프로젝트에 적합, 유지보수 용이

### 2. 순수 JDBC vs MyBatis

#### 순수 JDBC (현재 프로젝트)
```java
public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
    MemberDTO loginUser = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = "SELECT * FROM USERS WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";
    
    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, userPwd);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            loginUser = new MemberDTO();
            loginUser.setMemberId(rs.getString("MEMBER_ID"));
            loginUser.setMemberName(rs.getString("MEMBER_NAME"));
            // ... 기타 필드 설정
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        close(rs);
        close(pstmt);
    }
    
    return loginUser;
}
```

#### MyBatis 방식
```xml
<!-- MemberMapper.xml -->
<mapper namespace="com.auction.mapper.MemberMapper">
    <select id="loginMember" resultType="MemberDTO">
        SELECT * FROM USERS 
        WHERE MEMBER_ID = #{userId} AND MEMBER_PWD = #{userPwd}
    </select>
</mapper>
```

```java
@Mapper
public interface MemberMapper {
    MemberDTO loginMember(@Param("userId") String userId, 
                         @Param("userPwd") String userPwd);
}
```

**비교 결과:**
- **순수 JDBC**: 자바 코드가 복잡, 하지만 SQL 제어가 세밀
- **MyBatis**: SQL을 XML로 분리, 코드가 간결, 유지보수 용이

## 🏢 실무에서의 활용

### 1. 대규모 시스템에서의 확장
```java
// 현재 프로젝트: 단일 서버
public class ProductDAO {
    public List<ProductDTO> selectProductList(Connection conn) {
        // 직접 데이터베이스 조회
    }
}

// 실무: 마이크로서비스 아키텍처
@Service
public class ProductService {
    
    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public List<ProductDTO> getProductList(PageRequest pageRequest) {
        // 1. 캐시에서 먼저 조회
        String cacheKey = "products:page:" + pageRequest.getPage();
        List<ProductDTO> cachedProducts = (List<ProductDTO>) redisTemplate.opsForValue().get(cacheKey);
        
        if (cachedProducts != null) {
            return cachedProducts;
        }
        
        // 2. 데이터베이스에서 조회
        List<ProductDTO> products = productRepository.findAll(pageRequest);
        
        // 3. 캐시에 저장
        redisTemplate.opsForValue().set(cacheKey, products, Duration.ofMinutes(10));
        
        return products;
    }
}
```

### 2. 클라우드 환경에서의 활용
```java
// 현재 프로젝트: 파일을 서버에 직접 저장
public String uploadFile(MultipartFile file) {
    String uploadPath = "/resources/product_images/";
    String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
    
    try {
        file.transferTo(new File(uploadPath + fileName));
        return fileName;
    } catch (IOException e) {
        e.printStackTrace();
        return null;
    }
}

// 실무: 클라우드 스토리지 (AWS S3) 사용
@Service
public class FileUploadService {
    
    @Autowired
    private AmazonS3 s3Client;
    
    public String uploadToS3(MultipartFile file) {
        String bucketName = "auction-product-images";
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
        
        try {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());
            metadata.setContentType(file.getContentType());
            
            s3Client.putObject(bucketName, fileName, file.getInputStream(), metadata);
            
            return "https://" + bucketName + ".s3.amazonaws.com/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
```

### 3. 보안 강화
```java
// 현재 프로젝트: 기본적인 세션 인증
if (session.getAttribute("loginUser") == null) {
    response.sendRedirect("loginForm.jsp");
}

// 실무: JWT 토큰 기반 인증
@RestController
public class AuthController {
    
    @Autowired
    private JwtTokenProvider jwtTokenProvider;
    
    @PostMapping("/login")
    public ResponseEntity<TokenResponse> login(@RequestBody LoginRequest request) {
        // 사용자 인증
        MemberDTO member = memberService.authenticate(request.getUserId(), request.getPassword());
        
        if (member != null) {
            // JWT 토큰 생성
            String accessToken = jwtTokenProvider.createAccessToken(member.getMemberId());
            String refreshToken = jwtTokenProvider.createRefreshToken(member.getMemberId());
            
            return ResponseEntity.ok(new TokenResponse(accessToken, refreshToken));
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
}
```

이러한 개념들을 이해하면, 현재 프로젝트가 어떻게 작동하는지 알 수 있을 뿐만 아니라, 실무에서 어떻게 확장되고 개선될 수 있는지도 이해할 수 있습니다! 🚀