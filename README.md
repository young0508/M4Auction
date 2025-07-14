# My Project

## ACU - 온라인 미술품 경매 시스템

### 📋 프로젝트 개요
ACU (Auction)는 온라인 미술품 경매 플랫폼으로, Java 웹 기술을 기반으로 개발된 실시간 경매 시스템입니다.

### 🛠️ 기술 스택
- **Backend**: Java, JSP
- **Database**: Oracle (JDBC)
- **Frontend**: HTML5, CSS3, JavaScript
- **Server**: Apache Tomcat
- **Architecture**: JSP Model 1 Pattern

### 📂 프로젝트 구조
```
acu/
├── src/main/java/com/auction/
│   ├── common/           # 공통 유틸리티 (JDBCTemplate, SHA256 등)
│   ├── dao/              # 데이터 액세스 계층
│   ├── dto/              # 데이터 전송 객체
│   └── scheduler/        # 스케줄러 (경매 자동 종료)
├── src/main/webapp/
│   ├── admin/            # 관리자 페이지
│   ├── auction/          # 경매 페이지
│   ├── member/           # 회원 관리
│   ├── product/          # 상품 관리
│   └── resources/        # 정적 리소스
└── database/             # DB 스키마
```

### 🎯 주요 기능
- 회원 관리 시스템 (일반/VIP/관리자)
- 상품 등록 및 관리
- 실시간 경매 시스템
- 마일리지 시스템
- 관리자 대시보드
- 관심상품 (위시리스트)

### 📊 프로젝트 분석 자료
- **[📋 프로젝트 구조 분석 프레젠테이션](./docs/acu_structure_overview.md)**
  - 상세한 프로젝트 구조 분석
  - 핵심 파일 설명
  - 아키텍처 패턴 분석
  - 코드 하이라이트

### 🚀 실행 방법
1. Oracle Database 설정
2. 프로젝트를 Eclipse IDE로 Import
3. Tomcat 서버 설정
4. 데이터베이스 스키마 생성
5. 웹 애플리케이션 실행

### 📝 개발 가이드
- [초보자 가이드](./acu/beginner-guide.md)
- [개념 설명](./acu/concepts-explained.md)
- [FAQ](./acu/faq.md)
- [코드 읽기 가이드](./acu/how-to-read-code.md)

### 🔧 개발 환경
- Java 8+
- Oracle Database
- Apache Tomcat 9.0+
- Eclipse IDE (또는 IntelliJ IDEA)

---

*이 프로젝트는 Java 웹 개발 학습을 위한 종합적인 경매 시스템입니다.*