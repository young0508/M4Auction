<%--
  File: WebContent/mypage/chargeForm.jsp
  역할: 사용자가 마일리지를 충전할 금액을 입력하는 페이지입니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%
    // 로그인한 사용자만 이 페이지에 접근할 수 있도록 확인합니다.
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

    if(loginUser == null){
        // 로그인이 안되어있으면 로그인 페이지로 보냅니다.
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 마일리지 충전</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<style>
    body { 
        margin: 0; 
        background-color: #f4f4f4; 
        color: #333; 
        font-family: 'Noto Sans KR', sans-serif; 
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
    .container {
        width: 500px;
        padding: 40px;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 10px;
        text-align: center;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    h1 {
        font-family: 'Playfair Display', serif;
        font-size: 32px;
        color: #1a1a1a;
        margin-top: 0;
        margin-bottom: 30px;
    }
    .charge-form input {
        width: 100%;
        padding: 15px;
        font-size: 18px;
        text-align: center;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
        margin-bottom: 20px;
    }
    .charge-btn {
        width: 100%;
        padding: 15px;
        font-size: 20px;
        font-weight: bold;
        color: #fff;
        background-color: #d4af37;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .charge-btn:hover {
        background-color: #c8a02a;
    }
</style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="charge-container">
        <h1>마일리지 충전</h1>
        
        <div class="current-mileage">
            <p class="current-mileage-label">현재 보유 마일리지</p>
            <p class="current-mileage-value">
                <%= String.format("%,d", loginUser.getMileage()) %> P
            </p>
        </div>
        
        <form action="chargeMileage.jsp" method="post" class="charge-form" onsubmit="return validateForm();">
            <div class="form-group">
                <label>충전 금액 선택</label>
                <div class="amount-buttons">
                    <button type="button" class="amount-btn" onclick="setAmount(10000)">1만원</button>
                    <button type="button" class="amount-btn" onclick="setAmount(30000)">3만원</button>
                    <button type="button" class="amount-btn" onclick="setAmount(50000)">5만원</button>
                    <button type="button" class="amount-btn" onclick="setAmount(100000)">10만원</button>
                    <button type="button" class="amount-btn" onclick="setAmount(200000)">20만원</button>
                    <button type="button" class="amount-btn" onclick="setAmount(500000)">50만원</button>
                </div>
            </div>
            
            <div class="form-group">
                <label for="amount">직접 입력</label>
                <div class="custom-amount">
                    <input type="number" id="amount" name="amount" min="1000" step="1000" 
                           placeholder="충전할 금액" required>
                    <span class="currency">원</span>
                </div>
            </div>
            
            <button type="submit" class="charge-btn">
                <i class="fas fa-coins"></i> 충전하기
            </button>
        </form>
        
        <div class="info-box">
            <h4><i class="fas fa-info-circle" style="color: #c9961a;"></i> 충전 안내</h4>
            <ul>
                <li>최소 충전 금액은 1,000원입니다</li>
                <li>충전된 마일리지는 경매 입찰에 사용됩니다</li>
                <li>충전 요청 후 관리자 승인이 필요합니다</li>
                <li>충전 완료까지 1-2일 소요될 수 있습니다</li>
            </ul>
        </div>
        
        <a href="myPage.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> 마이페이지로 돌아가기
        </a>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
    function setAmount(value) {
        document.getElementById('amount').value = value;
        
        // 모든 버튼에서 active 클래스 제거
        document.querySelectorAll('.amount-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // 클릭한 버튼에 active 클래스 추가
        event.target.classList.add('active');
    }
    
    function validateForm() {
        const amount = document.getElementById('amount').value;
        
        if(amount < 1000) {
            alert('최소 충전 금액은 1,000원입니다.');
            return false;
        }
        
        if(amount % 1000 !== 0) {
            alert('1,000원 단위로 입력해주세요.');
            return false;
        }
        
        return confirm(new Intl.NumberFormat('ko-KR').format(amount) + '원을 충전하시겠습니까?');
    }
    
    // 직접 입력 시 버튼 선택 해제
    document.getElementById('amount').addEventListener('input', function() {
        document.querySelectorAll('.amount-btn').forEach(btn => {
            btn.classList.remove('active');
        });
    });
    </script>
</body>
</html>