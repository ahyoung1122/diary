<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
//diary_date, title, weather, content 가져오기
String diaryDate = request.getParameter("diaryDate");
String feeling = request.getParameter("feeling");
String title = request.getParameter("title");
String weather = request.getParameter("weather");
String content = request.getParameter("content");

//확인체크
System.out.println(diaryDate + ("=> diaryDate"));
System.out.println(feeling+("=>feeling"));
System.out.println(title + ("=> title"));
System.out.println(weather + ("=> weather"));
System.out.println(content + ("=> content"));

//데이터 수정작업
//update() set 
String sql = "UPDATE diary SET title =?, feeling=?, weather=?, content=? WHERE  diary_date = ?";
// DB랑 연결하기
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = null;
		PreparedStatement stmt = null;   
		conn =DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		stmt = conn.prepareStatement(sql);
		
		stmt.setString(1,title);
		stmt.setString(2, feeling);
		stmt.setString(3,weather);
		stmt.setString(4, content);
		stmt.setString(5, diaryDate);
		//stmt값 확인작업
		
		System.out.println("title="+title);
		System.out.println("feeling="+feeling);
		System.out.println("weather="+weather);
		System.out.println("content="+content);
		System.out.println("diaryDate="+diaryDate);
		//null값으로 들어온거 확인 완료

		
	int row = stmt.executeUpdate();
	//확인
	System.out.println(row);
	
	//결과분기 업데이트가 잘 된 경우 => diaryOne.jsp로 돌아가기
	//업데이트가 잘 못되면 다시 updateDiaryForm.jsp로 
	if(row == 1){
			response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);			
	}else {
				response.sendRedirect("./updateDiaryForm.jsp?diary_date="+diaryDate);
			}


		
   
%>

