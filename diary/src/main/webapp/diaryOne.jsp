<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<%@ page import = "java.util.*" %>
<%

String diaryDate = request.getParameter("diaryDate");

String sql = "SELECT feeling, title, weather,content FROM diary WHERE diary_date = ?";
System.out.println(sql);
//연결시키기
Connection conn = null;
PreparedStatement stmt = null;
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
stmt = conn.prepareStatement(sql);

stmt.setString(1, diaryDate);

System.out.println(stmt+"=stmt");

ResultSet rs=null; 
rs = stmt.executeQuery();


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
								<a href="/diary/deleteDiaryForm.jsp?diary-date=<%=diaryDate%>" class="btn btn-outline-dark">일기삭제</a>
					
						<%		
							} else {
						%>
								<div><%=diaryDate%> 날짜의 글을 존재하지 않습니다.</div>
						<%		
							}
						%>
								
		</div><!-- col마지막 -->
				<div class="col-3"></div>
			</div><!-- row -->
	</div><!-- container -->



</body>
</html>