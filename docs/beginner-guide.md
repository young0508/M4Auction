# 📖 완전 초보자를 위한 Java 웹 경매 시스템 가이드

## 🎯 이 프로젝트가 무엇인가요?

이 프로젝트는 **온라인 경매 사이트**입니다. 마치 옥션이나 G마켓처럼 물건을 사고 팔 수 있는 웹사이트인데, 여기서는 **미술품**을 경매로 거래합니다.

### 💡 실생활 비유로 설명하면
- **경매장**: 실제 경매장처럼 사람들이 모여서 물건에 대해 가격을 부르는 곳
- **온라인 쇼핑몰**: 인터넷으로 물건을 사고 파는 곳
- **회원제 클럽**: 가입해야만 이용할 수 있는 서비스

이 세 가지를 합쳐놓은 것이 바로 이 프로젝트입니다!

## 🛠️ 사용된 기술들 (쉽게 설명)

### 1. Java (자바)
- **무엇인가요?**: 프로그래밍 언어 중 하나
- **실생활 비유**: 사람들이 한국어, 영어로 대화하듯이 컴퓨터와 대화하는 언어
- **이 프로젝트에서의 역할**: 웹사이트의 핵심 로직을 처리 (로그인, 경매, 결제 등)

### 2. JSP (Java Server Pages)
- **무엇인가요?**: 웹페이지를 만드는 기술
- **실생활 비유**: 워드프로세서로 문서를 작성하는 것처럼, 웹페이지를 작성하는 도구
- **이 프로젝트에서의 역할**: 사용자가 보는 화면을 만들어줌

### 3. Oracle Database (데이터베이스)
- **무엇인가요?**: 정보를 저장하고 관리하는 시스템
- **실생활 비유**: 거대한 도서관의 도서 관리 시스템
- **이 프로젝트에서의 역할**: 회원정보, 상품정보, 경매기록 등을 저장

### 4. HTML/CSS/JavaScript
- **무엇인가요?**: 웹페이지의 모양과 동작을 만드는 기술
- **실생활 비유**: 
  - HTML = 집의 뼈대 (구조)
  - CSS = 집의 인테리어 (디자인)
  - JavaScript = 집의 전자제품 (동작)

## 📁 프로젝트 구조 이해하기

```
acu/
├── src/main/java/com/auction/     ← 자바 코드들이 있는 곳
│   ├── common/                    ← 공통으로 사용하는 도구들
│   ├── dao/                       ← 데이터베이스와 대화하는 코드들
│   ├── dto/                       ← 데이터를 담는 상자들
│   └── scheduler/                 ← 자동으로 실행되는 작업들
├── src/main/webapp/               ← 웹페이지들이 있는 곳
│   ├── index.jsp                  ← 메인 페이지
│   ├── member/                    ← 회원 관련 페이지들
│   ├── product/                   ← 상품 관련 페이지들
│   ├── auction/                   ← 경매 관련 페이지들
│   └── resources/                 ← 이미지, CSS 등의 자료들
└── database/                      ← 데이터베이스 관련 파일들
```

## 📝 주요 파일들의 역할

### 1. 메인 페이지
- **파일**: `index.jsp`
- **역할**: 웹사이트의 첫 화면
- **실생활 비유**: 백화점의 1층 로비

### 2. 회원 관련 파일들
- **폴더**: `member/`
- **주요 파일들**:
  - `loginForm.jsp`: 로그인 화면
  - `enroll_step1.jsp`: 회원가입 화면
- **역할**: 회원가입, 로그인, 회원정보 수정
- **실생활 비유**: 백화점의 회원카드 발급 창구

### 3. 상품 관련 파일들
- **폴더**: `product/`
- **주요 파일들**:
  - `productList.jsp`: 상품 목록 화면
  - `productDetail.jsp`: 상품 상세 화면
  - `productEnrollForm.jsp`: 상품 등록 화면
- **역할**: 상품 보기, 상품 등록, 상품 관리
- **실생활 비유**: 백화점의 상품 진열대

### 4. 경매 관련 파일들
- **폴더**: `auction/`
- **주요 파일들**:
  - `auction.jsp`: 경매 진행 화면
  - `auctionList.jsp`: 경매 목록 화면
- **역할**: 경매 참여, 입찰하기
- **실생활 비유**: 경매장의 경매 진행 무대

## 🎲 데이터의 흐름 (쉽게 설명)

### 1. 회원가입 과정
1. **사용자**: 회원가입 버튼 클릭
2. **JSP**: 회원가입 화면 보여줌
3. **사용자**: 정보 입력 후 제출
4. **Java**: 입력된 정보 검증
5. **데이터베이스**: 회원정보 저장
6. **JSP**: 가입 완료 화면 보여줌

### 2. 상품 보기 과정
1. **사용자**: 상품 목록 페이지 접속
2. **Java**: 데이터베이스에서 상품 정보 조회
3. **데이터베이스**: 상품 정보 전달
4. **JSP**: 상품 목록 화면 생성
5. **사용자**: 상품 목록 확인

### 3. 경매 참여 과정
1. **사용자**: 경매 페이지 접속
2. **Java**: 현재 경매 상태 확인
3. **사용자**: 입찰 가격 입력
4. **Java**: 입찰 가격 검증
5. **데이터베이스**: 입찰 정보 저장
6. **JSP**: 입찰 결과 화면 보여줌

## 🔧 핵심 구성 요소들

### 1. DTO (Data Transfer Object)
- **무엇인가요?**: 데이터를 담는 상자
- **실생활 비유**: 택배 상자
- **예시**: `MemberDTO` - 회원 정보를 담는 상자

```java
// 회원 정보를 담는 상자
public class MemberDTO {
    private String memberId;      // 회원 아이디
    private String memberName;    // 회원 이름
    private String email;         // 이메일
    // ... 기타 정보들
}
```

### 2. DAO (Data Access Object)
- **무엇인가요?**: 데이터베이스와 대화하는 직원
- **실생활 비유**: 도서관 사서
- **예시**: `MemberDAO` - 회원 정보 관련 DB 작업

```java
// 회원 정보 관련 데이터베이스 작업을 담당
public class MemberDAO {
    // 로그인 처리
    public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
        // 데이터베이스에서 회원 정보 조회
        // 비밀번호 확인
        // 결과 반환
    }
}
```

### 3. JSP 페이지
- **무엇인가요?**: 화면과 처리 로직이 함께 있는 파일
- **실생활 비유**: 상점의 진열대와 계산대가 함께 있는 곳
- **예시**: `loginForm.jsp` (화면), `loginAction.jsp` (처리)

### 4. JDBCTemplate
- **무엇인가요?**: 데이터베이스 연결 도구
- **실생활 비유**: 도서관 출입증
- **역할**: 데이터베이스에 안전하게 접근할 수 있게 해줌

## 🔍 파일별 상세 설명

### 1. MemberDTO.java
```java
// 회원 한 명의 정보를 담는 틀
public class MemberDTO {
    private String memberId;     // 아이디
    private String memberPwd;    // 비밀번호
    private String memberName;   // 이름
    private String email;        // 이메일
    private long mileage;        // 마일리지
    
    // getter, setter 메서드들...
}
```

**쉬운 설명**: 
- 회원 정보를 담는 서류 양식이라고 생각하면 됩니다
- 각 항목(필드)은 서류의 빈 칸이고, 실제 데이터는 그 빈 칸에 채워지는 내용입니다

### 2. MemberDAO.java
```java
public class MemberDAO {
    // 로그인 처리
    public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
        // 1. 데이터베이스에서 사용자 정보 찾기
        // 2. 비밀번호 확인
        // 3. 맞으면 회원 정보 반환, 틀리면 null 반환
    }
    
    // 회원가입 처리
    public int enrollMember(Connection conn, MemberDTO member) {
        // 1. 회원 정보를 데이터베이스에 저장
        // 2. 성공하면 1, 실패하면 0 반환
    }
}
```

**쉬운 설명**:
- 데이터베이스와 대화하는 전담 직원입니다
- 로그인, 회원가입, 정보 수정 등의 실제 작업을 수행합니다

### 3. index.jsp
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>M4 Auction - 메인 페이지</title>
</head>
<body>
    <h1>M4 Auction에 오신 것을 환영합니다!</h1>
    
    <!-- 최근 경매 상품들 표시 -->
    <% 
        List<ProductDTO> recentProducts = ... // 최근 상품들 가져오기
        for(ProductDTO product : recentProducts) {
    %>
        <div class="product-card">
            <h3><%= product.getProductName() %></h3>
            <p>현재가: <%= product.getCurrentPrice() %>원</p>
        </div>
    <% } %>
</body>
</html>
```

**쉬운 설명**:
- 사용자가 보는 첫 화면입니다
- HTML로 화면 구조를 만들고, JSP로 동적인 내용을 추가합니다

## 🎯 주요 기능들

### 1. 회원 관리 시스템
- **일반 회원**: 기본적인 경매 참여 가능
- **VIP 회원**: 특별한 혜택과 서비스 제공
- **관리자**: 사이트 전체 관리

### 2. 상품 관리 시스템
- **상품 등록**: 판매자가 경매 상품 등록
- **상품 승인**: 관리자가 상품 검토 후 승인
- **상품 전시**: 승인된 상품들을 사용자에게 보여줌

### 3. 경매 시스템
- **경매 진행**: 실시간으로 입찰 가격 업데이트
- **자동 마감**: 정해진 시간에 경매 자동 종료
- **낙찰 처리**: 최고가 입찰자를 낙찰자로 결정

### 4. 마일리지 시스템
- **적립**: 경매 참여 시 마일리지 적립
- **사용**: 경매 참여 시 마일리지 사용
- **충전**: 관리자가 마일리지 충전 승인

## 🚀 프로젝트 실행 과정

### 1. 사용자가 웹사이트 접속
1. 브라우저에서 `index.jsp` 요청
2. 서버가 최근 경매 상품 정보를 데이터베이스에서 조회
3. 조회된 정보를 화면에 표시

### 2. 사용자가 로그인
1. `loginForm.jsp`에서 아이디/비밀번호 입력
2. `loginAction.jsp`에서 입력 정보 처리
3. `MemberDAO`가 데이터베이스에서 회원 정보 확인
4. 성공 시 메인 페이지로 이동, 실패 시 로그인 페이지로 다시 이동

### 3. 사용자가 경매 참여
1. 상품 목록에서 원하는 상품 클릭
2. 상품 상세 페이지에서 입찰 가격 입력
3. 입찰 정보가 데이터베이스에 저장
4. 현재 최고가 업데이트

## 🎨 디자인과 사용자 경험

### 1. 반응형 디자인
- **무엇인가요?**: 컴퓨터, 태블릿, 휴대폰 등 어떤 기기에서도 잘 보이는 디자인
- **실생활 비유**: 늘어나는 옷처럼 어떤 몸에든 맞는 옷

### 2. 사용자 친화적 인터페이스
- **직관적인 메뉴**: 사용자가 쉽게 찾을 수 있는 메뉴 구조
- **명확한 버튼**: 각 버튼의 역할이 명확히 표시
- **실시간 업데이트**: 경매 상황을 실시간으로 확인

## 🔒 보안 시스템

### 1. 비밀번호 암호화
- **SHA256 알고리즘**: 비밀번호를 안전하게 암호화
- **실생활 비유**: 중요한 서류를 금고에 보관하는 것

### 2. 세션 관리
- **로그인 상태 유지**: 사용자가 로그인 상태를 유지할 수 있게 함
- **자동 로그아웃**: 일정 시간 후 자동으로 로그아웃

## 📊 데이터베이스 구조

### 1. 주요 테이블들
- **USERS**: 회원 정보 저장
- **PRODUCT**: 상품 정보 저장
- **BID**: 입찰 정보 저장
- **VIP_INFO**: VIP 회원 정보 저장

### 2. 테이블 관계
```
USERS (회원)
  ↓
PRODUCT (상품) - 판매자 정보
  ↓
BID (입찰) - 입찰자 정보
```

## 🎪 실제 사용 시나리오

### 시나리오 1: 새로운 사용자의 첫 방문
1. **메인 페이지 접속**: 현재 진행 중인 경매들 확인
2. **회원가입**: 개인정보 입력 후 회원가입
3. **상품 둘러보기**: 관심 있는 상품들 확인
4. **첫 입찰**: 마음에 드는 상품에 입찰 참여

### 시나리오 2: 판매자의 상품 등록
1. **로그인**: 기존 회원으로 로그인
2. **상품 등록**: 판매하고 싶은 상품 정보 입력
3. **승인 대기**: 관리자의 승인 대기
4. **경매 시작**: 승인 후 경매 진행

### 시나리오 3: VIP 회원의 특별 서비스
1. **VIP 신청**: 일반 회원이 VIP 회원 신청
2. **특별 혜택**: VIP 전용 경매 참여
3. **개인 상담**: 전문가 상담 서비스 이용

## 🎯 이 프로젝트에서 배울 수 있는 것들

### 1. 웹 개발의 기초
- **프론트엔드**: HTML, CSS, JavaScript
- **백엔드**: Java, JSP
- **데이터베이스**: Oracle, SQL

### 2. 소프트웨어 개발 패턴
- **DAO 패턴**: 데이터베이스 접근 로직을 별도 클래스로 분리
- **DTO 패턴**: 데이터를 담고 전달하는 객체 활용
- **JSP Model 2**: 화면(JSP)과 로직을 어느 정도 분리하는 방식

### 3. 실무 경험
- **프로젝트 구조**: 실제 프로젝트와 유사한 구조
- **팀 협업**: 여러 명이 함께 작업하는 방식
- **문서화**: 코드 주석과 문서 작성

## 🌟 다음 단계로 나아가기

### 1. 기본기 다지기
- **Java 기초**: 변수, 조건문, 반복문, 클래스
- **웹 기초**: HTML, CSS, JavaScript
- **데이터베이스 기초**: SQL 문법

### 2. 심화 학습
- **Servlet/JSP 심화**: 필터, 리스너, 세션 관리
- **프레임워크**: Spring, MyBatis (현재 프로젝트 기반 위에 도입)
- **프론트엔드**: JavaScript ES6+, AJAX 활용

### 3. 실무 준비
- **포트폴리오 구성**: 자신만의 프로젝트 만들기
- **협업 도구**: Git, GitHub 사용법
- **배포**: 실제 서버에 프로젝트 배포하기

---

이 가이드를 통해 복잡해 보이는 프로젝트가 실제로는 우리가 일상적으로 사용하는 인터넷 쇼핑몰과 비슷한 구조라는 것을 이해할 수 있습니다. 중요한 것은 한 번에 모든 것을 이해하려고 하지 말고, 하나씩 차근차근 익혀나가는 것입니다! 🚀