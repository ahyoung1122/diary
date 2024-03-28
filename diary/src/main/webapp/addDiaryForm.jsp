<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
//0.로그인(인증)분기 
	//diary.login.my_session =? "OFF" =>redirect("loginForm.jsp")
	
	String sql1 = "select my_session mySession from login"; //my_session에서 가져옴
	//mySession은 별칭 my_session은 login table안에 있는값
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()) {
		mySession = rs1.getString("mySession");
	}
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}

%>
<%
		String checkDate = request.getParameter("checkDate");
		if(checkDate ==null){//갔다가 돌아오면 null값이 아니겠지? 
			checkDate = " ";
			
		}
		
		String ck = request.getParameter("ck");
		
		//System.out.println(ck);
		
		if(ck == null){
			ck= "";
		}
		
		String msg =" ";
		if(ck.equals("T")){
			msg = "입력이 가능한 날짜입니다";
		}else if(ck.equals("F")){
			msg = "일기가 이미 존재하는 날짜입니다";
		}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
		<title>addDiaryForm</title>


<Style>
body{
background-image: url("./image/jerry.png");
}
*{
	font-family: CookieRun;
	}
a{
text-decoration: none;
}
a:visited{
	color : ivory;
}
th {
font-size: 15px;
color : #BD5C24;
 }

</Style>
</head>
<body>

 checkDate : <%=checkDate %><br>
			ck : <%=ck%> 
	<div class="container">
		<div class="row">
				<div class="col"></div>
				<div class="mt-5 col-6 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">	
					<span style="background-color: #FF8383; color :ivory;"><a href="./diary.jsp">뒤로가기</a></span>
					<h1 style="text-align: center; color:#420100; font-family: CookieRun;">일기장🐹</h1>
						<form method="post" action="/diary/checkDateAction.jsp">
								<div>
									날짜확인 <input type = "date" name="checkDate" value ="<%=checkDate%>">
									<span><%=msg%></span >
								</div>
								<button type="submit" style="background-color: #BD5C24; color : ivory; border: 1px solid #BD5C24;">
									날짜가능확인
								</button>
						</form><hr>
				
						<form method="post" action="/diary/addDiaryAction.jsp"><!-- 얘는 같은 페이지 안에 있지만 완전히 다른 모듈 -->
								<div>
								<table>
										<tr>
											<th>날짜</th>
											<td>
										<%
											if(ck.equals("T")){
												%>
													<input value="<%=checkDate%>" type="text" name="diaryDate" readonly="readonly">
												<%			
														}else{
													%>
															<input value=" " type="text" name ="diaryDate" readonly="readonly">
													<%		
														}
													%>
										</td>
										</tr>
													
										<div>
											기분 : 
											<input type="radio" name="feeling" value="&#128512;">&#128512;
											<input type="radio" name="feeling" value="&#128525;">&#128525;
											<input type="radio" name="feeling" value="&#128545;">&#128545;
											<input type="radio" name="feeling" value="&#128557;">&#128557;
											<input type="radio" name="feeling" value="&#128561;">&#128561;
										</div>
										<tr>
											<th>제목</th>
											<td><input type = "text" name = "title"></td>
										</tr>
								</table>
								</div>
								<br>
								<div>
									<select name ="weather">
											<option value="맑음">맑음☀️</option>
											<option value="흐림">흐림🌥️</option>
											<option value="비">비☔</option>
											<option value="눈">눈☃️</option>
									</select>
								</div>
								<div>
										<textarea rows="7" cols="50" name="content"></textarea>
								</div>
								<div>
									<button type="submit">입력</button>
								</div>
						</form>
			</div><!-- col-7마지막 -->
			<div class="col-5"></div>
				<div class="col"></div>
				<div class="col"></div>
			</div><!-- row -->
	</div><!-- container -->
</body>
</html>