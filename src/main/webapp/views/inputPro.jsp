<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.UserDAO, model.UserDTO" %>

<%
  String id = request.getParameter("memberId");
  String pw = request.getParameter("memberPwd");
  // ...
  UserDTO user = new UserDTO(memberId, memberPwd, memberName, Integer.parseInt(mileage), new java.util.Date());
  UserDAO dao = new UserDAO();
  boolean ok = dao.insertUser(user);
  if(ok) out.println("가입 성공"); else out.println("가입 실패");
%>


<h1></h1>