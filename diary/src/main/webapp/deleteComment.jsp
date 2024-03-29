<%@page import="javax.swing.text.html.HTMLEditorKit.Parser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
		//인코딩 하기
		request.setCharacterEncoding("utf-8");
		//response에 사용할것
		String diaryDate = request.getParameter("diaryDate");
		
		System.out.println(diaryDate);
		//삭제하려는 기준점 comment_no 쿼리 -> int로 형변환 해줘야함
		int commentNo = Integer.parseInt(request.getParameter("commentNo"));
		
		 //확인
		 System.out.println("commentNo=>"+commentNo);
		 
	//연결
	
		Class.forName("org.mariadb.jdbc.Driver");
		String sql = "DELETE FROM comment WHERE comment_no=?";
		Connection con = null;
		PreparedStatement stmt= null; 
		ResultSet rs = null;
		con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		stmt = con.prepareStatement(sql);
		stmt.setInt(1, commentNo);
		
		//왜안나오늑너야...디버깅
		System.out.println(stmt);
		
		int row = stmt.executeUpdate();
		
		response.sendRedirect("./diaryOne.jsp?diaryDate="+ diaryDate);

%>