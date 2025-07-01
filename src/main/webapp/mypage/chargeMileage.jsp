<%--
  File: WebContent/mypage/chargeMileage.jsp
  역할: 마일리지 충전 요청을 실제로 처리합니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ page import="com.auction.vo.MemberDTO"
%><%@ page import="com.auction.dao.MemberDAO"
%><%@ page import="java.sql.Connection"
%><%@ page import="static com.auction.common.JDBCTemplate.*" %><%
    // 1. 로그인 여부 확인
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    // 2. 충전할 금액을 form으로부터 받아옵니다.
    int amount = Integer.parseInt(request.getParameter("amount"));
    
    // 3. '마법 열쇠'와 '회원 관리 직원'을 준비합니다.
    Connection conn = getConnection();
    int result = new MemberDAO().updateMileage(conn, loginUser.getMemberId(), amount);
    
    // 4. 결과에 따라 최종 저장을 할지, 취소를 할지 결정합니다.
    if(result > 0){
        commit(conn);

        // ======== 가장 중요한 부분! ========
        // DB의 마일리지가 바뀌었으니, session에 저장된 'loginUser'의 마일리지 정보도
        // 최신 정보로 직접 업데이트 해주어야 합니다.
        int updatedMileage = loginUser.getMileage() + amount;
        loginUser.setMileage(updatedMileage);
        
        session.setAttribute("alertMsg", "마일리지가 성공적으로 충전되었습니다.");
    } else {
        rollback(conn);
        session.setAttribute("alertMsg", "마일리지 충전에 실패했습니다.");
    }
    
    // 5. 처리가 끝나면 마이페이지로 돌려보냅니다.
    close(conn);
    response.sendRedirect("myPage.jsp");
%>
