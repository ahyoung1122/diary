<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
//인코딩
request.setCharacterEncoding("utf-8");

String diaryDate = request.getParameter("diary_date");
//삭제쿼리 가져오기delete from , where=?
String sql = "DELETE FROM diary WHERE  diary_date = ?";
//DB랑 연결하기
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = null;
PreparedStatement stmt = null;   
conn =DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
stmt = conn.prepareStatement(sql);
stmt.setString(1, diaryDate);

System.out.println(stmt+"=stmt");

ResultSet rs=null; 
rs = stmt.executeQuery();

int row = stmt.executeUpdate(); 

//삭제를 성공했을때와 실패했을때를 분기해서 나눠주어야한다.
//삭제성공하면 => 다이어리 메인 페이지로 
//삭제 실패하면 ->diaryOne.jsp로 이동하게끔하자
if(row == 0) {
	response.sendRedirect("./diary.jsp");
	System.out.println("삭제성공했음");
}else { 
	response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);
	System.out.println("삭제실패했음");
}



%>
