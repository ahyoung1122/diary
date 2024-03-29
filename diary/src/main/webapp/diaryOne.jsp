<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<%@ page import = "java.util.*" %>
<%

String diaryDate = request.getParameter("diaryDate");

Class.forName("org.mariadb.jdbc.Driver");
/* String sql = "SELECT feeling, title, weather,content FROM diary WHERE diary_date = ?"; 
System.out.println(sql);*/
//연결시키기
Connection conn = null;
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

System.out.println(diaryDate+"<-diaryDate");
String sql="select * from diary WHERE diary_date = ?";
PreparedStatement stmt = conn.prepareStatement(sql);

stmt.setString(1, diaryDate);

System.out.println(stmt+"=stmt");
ResultSet rs = stmt.executeQuery();


%>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
		<title>diaryOne</title>
<style>
body{
background-image: url("./image/jerry.png");
}
*{
	font-family: CookieRun;
	}
	a{
	text-decoration: none;
	color : ivory;
	background-color: pink;
	}
	p{text-align: right;}
#ge {
background-color: #FF6C6C;
color : ivory;
}
#di {
background-color: #6B9900;
color : ivory;
}
th{
	color : #BD5C24;

}

</style>
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-3"></div>
			<div class="mt-5 col-6 bg-black border shadow p-3 mb-5 bg-body-tertiary rounded" >
				<div>
						<p>
						<a id="di" href="./diary.jsp">다이어리</a>
						<a id="ge" href="./diaryList.jsp">게시판</a>
						<p>
			</div>
					<h2  style="color :#420100;">일기<h2>
					<h6><%=diaryDate %></h6>
					<hr>
					<!-- diary_date, title, weather, content -->
					<!-- diaryList 버튼 추가 -->
					<!-- diary돌아가기 버튼 추가 -->
					
						<%
							if(rs.next()) {
						%>
								<table class="title">
									<tr>
										<th>제목 : </th>
										<td><%=rs.getString("title")%></td>
									</tr>
									<tr>
										<th>기분</th>
										<td><%=rs.getString("feeling")%></td>
									</tr>
									<tr>
										<th>날씨 : </th>
										<td><%=rs.getString("weather") %></td>
									</tr>
								</table>
								<div style="font-weight: bold; color : #662500;  "> 내용</div>
								<textarea rows="5" cols="30" readonly="readonly">
								<%=rs.getString("content") %>
								</textarea>
								<br>
								
								<a href="/diary/updateDiaryForm.jsp?diary_date=<%=diaryDate%>" class="btn btn-outline-dark">일기수정</a>
								<a href="/diary/deleteDiaryAction.jsp?diary_date=<%=diaryDate%>" class="btn btn-outline-dark">일기삭제</a>
					
						<%		
							} else {
						%>
								<div><%=diaryDate%> 날짜의 글은 존재하지 않습니다.</div>
						<%		
							}
						%>
						<hr>
						<!-- 댓글추가폼 -->
						<div>
							<form method="post" action="/diary/addCommentAction.jsp">
								<input type="hidden" name="diaryDate" value="<%=diaryDate %>">
								<textarea rows="2" cols="50" name="memo"></textarea>
								<br>
								<button type="submit">댓글입력</button>
							</form>
						</div>
						<hr>
						<!-- 댓글리스트 -->
						<% 					
							String sql2 = "SELECT comment_no commentNo, memo, create_date createDate from comment where diary_date=?";
							PreparedStatement stmt2= null;
							ResultSet rs2 = null;
							
							stmt2 = conn.prepareStatement(sql2);
							stmt2.setString(1, diaryDate);
							rs2 = stmt2.executeQuery();
						%>
						<table border = "1">
								<%
									while(rs2.next()){
								%>
										<tr>
											<td><%=rs2.getString("memo") %></td>
											<td><%=rs2.getString("createDate") %></td>
											<!-- 여기서 삭제를 하려면 commentNo랑, 주소창 url값인 diaryDate 또한 넘겨주어야 한다. -->
											<td><a href='./deleteComment.jsp?commentNo=<%=rs2.getInt("commentNo")%>&diaryDate=<%=diaryDate%>'>삭제</a>
											</td>
											
										</tr>
								<%
									}
								%>
						</table>
								
		</div><!-- col마지막 -->
				<div class="col-3"></div>
			</div><!-- row -->
	</div><!-- container -->



</body>
</html>