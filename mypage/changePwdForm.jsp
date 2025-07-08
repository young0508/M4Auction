<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 비밀번호 변경</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/layout.css">
<style>
    body { background-color: #1a1a1a; }
    .pwd-container {
        width: 500px;
        margin: 50px auto;
        padding: 40px;
        background-color: #2b2b2b;
        border-radius: 10px;
        color: #e0e0e0;
    }
    h1 {
        font-family: 'Playfair Display', serif;
        text-align: center;
        font-size: 36px;
        color: #d4af37;
        margin-bottom: 40px;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #ccc;
        font-weight: bold;
    }
    .form-group input {
        width: 100%;
        padding: 12px;
        background-color: #1a1a1a;
        border: 1px solid #555;
        color: #fff;
        border-radius: 5px;
        font-size: 16px;
    }
    .btn-group {
        display: flex;
        gap: 10px;
        margin-top: 30px;
    }
    .btn {
        flex: 1;
        padding: 15px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
    }
    .submit-btn {
        background-color: #d4af37;
        color: #1a1a1a;
    }
    .cancel-btn {
        background-color: #555;
        color: white;
    }
    .info-text {
        font-size: 14px;
        color: #aaa;
        margin-top: 20px;
        text-align: center;
    }
</style>
</head>
<body>
<jsp:include page="/layout/header/luxury-header.jsp" />

<div class="pwd-container">
    <h1>비밀번호 변경</h1>
    
    <form action="changePwdAction.jsp" method="post" onsubmit="return validatePwd();">
        <div class="form-group">
            <label for="currentPwd">현재 비밀번호</label>
            <input type="password" id="currentPwd" name="currentPwd" required>
        </div>
        
        <div class="form-group">
            <label for="newPwd">새 비밀번호</label>
            <input type="password" id="newPwd" name="newPwd" required onkeyup="checkPasswordStrength()">
            <div class="password-strength">
                <div class="strength-bar" id="strengthBar"></div>
            </div>
            <p class="strength-text" id="strengthText"></p>
        </div>
        
        <div class="form-group">
            <label for="newPwdCheck">새 비밀번호 확인</label>
            <input type="password" id="newPwdCheck" name="newPwdCheck" required>
        </div>
        
        <div class="info-box">
            <h4>안전한 비밀번호 만들기</h4>
            <ul>
                <li>최소 8자 이상 입력해주세요</li>
                <li>영문 대/소문자를 혼합하여 사용하세요</li>
                <li>숫자와 특수문자를 포함하세요</li>
                <li>개인정보와 관련된 단어는 피하세요</li>
            </ul>
        </div>
        
        <div class="btn-group">
            <button type="submit" class="btn submit-btn">변경하기</button>
            <button type="button" class="btn cancel-btn" onclick="location.href='myPage.jsp'">취소</button>
        </div>
    </form>
</div>

<jsp:include page="/layout/footer/luxury-footer.jsp" />

<script>
function checkPasswordStrength() {
    const password = document.getElementById('newPwd').value;
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');
    
    let strength = 0;
    
    // 길이 체크
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    
    // 대소문자 체크
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
    
    // 숫자 체크
    if (/\d/.test(password)) strength++;
    
    // 특수문자 체크
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;
    
    // 강도에 따른 표시
    strengthBar.className = 'strength-bar';
    if (strength <= 2) {
        strengthBar.classList.add('strength-weak');
        strengthText.textContent = '약함';
        strengthText.style.color = '#e74c3c';
    } else if (strength <= 4) {
        strengthBar.classList.add('strength-medium');
        strengthText.textContent = '보통';
        strengthText.style.color = '#f39c12';
    } else {
        strengthBar.classList.add('strength-strong');
        strengthText.textContent = '강함';
        strengthText.style.color = '#27ae60';
    }
}

function validatePwd() {
    const currentPwd = document.getElementById('currentPwd').value;
    const newPwd = document.getElementById('newPwd').value;
    const newPwdCheck = document.getElementById('newPwdCheck').value;
    
    if(newPwd.length < 8) {
        alert('새 비밀번호는 8자 이상 입력해주세요.');
        return false;
    }
    
    if(currentPwd === newPwd) {
        alert('현재 비밀번호와 새 비밀번호가 동일합니다.');
        return false;
    }
    
    if(newPwd !== newPwdCheck) {
        alert('새 비밀번호가 일치하지 않습니다.');
        document.getElementById('newPwd').value = '';
        document.getElementById('newPwdCheck').value = '';
        document.getElementById('newPwd').focus();
        return false;
    }
    
    return confirm('비밀번호를 변경하시겠습니까?');
}
</script>

</body>
</html>