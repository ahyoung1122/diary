<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
request.setCharacterEncoding("utf-8");        
//1.요청값
String diaryDate = request.getParameter("diaryDate");
String title = request.getParameter("title");
String weather=request.getParameter("weather");
String content = request.getParameter("content");
String feeling = request.getParameter("feeling");

//디버깅해보기

System.out.println("diaryDate=>"+diaryDate);
System.out.println("title=>"+title);
System.out.println("weather=>"+weather);
System.out.println("content=>"+content);
System.out.println("feeling=>"+feeling);
//2데이터수정
  String sql = "INSERT INTO diary(diary_date, feeling, title, weather, content, update_date, create_date) VALUES (?, ?, ?, ?, ?,NOW(), NOW())";
   Class.forName("org.mariadb.jdbc.Driver");
   Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
   PreparedStatement stmt = conn.prepareStatement(sql);
   
   stmt.setString(1, diaryDate);
   stmt.setString(2, feeling);
   stmt.setString(3, title);
   stmt.setString(4, weather);
   stmt.setString(5, content);
   
   System.out.println(stmt + "<<==stmt");
   
   int row = stmt.executeUpdate();
   if(row == 1) {
      System.out.println("입력성공");
   } else {
      System.out.println("입력실패");
   }
   
   // 3. 목록(diary.jsp) 을 재요청(redirect)하게 한다
   response.sendRedirect("./diary.jsp");


%>