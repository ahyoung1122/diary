<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import="java.net.*"%>
<%
	//DB분기는 아래쪽으로 빼둠
	
	// session.removeAttribut("loginMember");
	
	
	session.invalidate(); //세션 공간 초기화(포맷)
	
	
	response.sendRedirect("./loginForm.jsp");
%>


	