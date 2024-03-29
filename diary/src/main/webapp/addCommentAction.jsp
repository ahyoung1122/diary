<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//요청
	String diaryDate = request.getParameter("diaryDate");
	String memo = request.getParameter("memo");
	//디버깅
	System.out.println("diaryDate=>"+diaryDate);
	System.out.println("memo=>"+memo);
	
	
	//연결하기
	
	Class.forName("org.mariadb.jdbc.Driver");
	String sql = "INSERT INTO comment(diary_date, memo, update_date, create_date) VALUES(?,?,NOW(), NOW())"; 
	Connection con = null;
	PreparedStatement stmt= null; 
	ResultSet rs = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = con.prepareStatement(sql);
	stmt.setString(1,diaryDate);
	stmt.setString(2,memo);
	
	System.out.println(stmt+"=>>stmt");
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("성공입니다");
	} else {
		System.out.println("실패입니다");
	}
	
	response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);
%>