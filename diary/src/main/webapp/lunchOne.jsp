<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
		String loginMember = (String)(session.getAttribute("loginMember"));
		if(loginMember == null){
					String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
					return;// 코드 진행을 끝내는 문법 
		}
	
	
	String sql1 = "select my_session mySession from login";
	/* 
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
	} */
%>	
<%
//오늘 점심을 투표했는지 보기
/* SELECT lunch_date lunchDate, menu FROM lunch
WHERE lunch_date = CURDATE(); */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
 	String sql2 = "SELECT lunch_date lunchDate, menu From lunch WHERE lunch_date = CURDATE()";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	System.out.println("stmt2=>"+stmt2);
	
	rs2 = stmt2.executeQuery();

	String lunchDate = request.getParameter("lunchDate");
	if(lunchDate ==null){
		lunchDate = "";
	}
	
	String ck = request.getParameter("ck");
	if(ck == null){
		ck="";
	}
	
	String msg =" ";
	if(ck.equals("T")){
		msg = "오늘의 점심메뉴를 골라주세요!";
	}else if(ck.equals("F")){
		msg = " 이미 점심메뉴를 체크한날짜입니다";
	}
%>
<%
//오늘 점심 투표하기
/* INSERT INTO lunch(lunch_date,menu,update_date,create_date)
VALUES(CURDATE(), ?, NOW(), NOW()); */
	

%>

<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
		<title>lunchOne</title>
		<style>
			body{
				background-image: url("./image/jerry.png");
				}
				*{
				font-family: CookieRun;
				}
		</style>

</head>
<body>
<div class="container">
		<div class="row">
			<div class="col-3"></div>
				<div class="mt-5 col-6 bg-black border shadow p-3 mb-5 bg-body-tertiary rounded" >
					<h2 style="color : #420100;">
						오늘의 점심메뉴 투표🐹
					</h2>
						<hr>
						<form method ="get" action="./statsLunchCheck.jsp">
							<div>
								날짜를 선택하기
							</div>
								<span><%=msg %></span>
									<input type="date" name="lunchDate" value="<%=lunchDate%>">
										<button type="submit">확인하기</button>
								
						</form>
								<!-- 확인하는 날짜에 입력된 값이
								없다면 점심메뉴 투표하기 -->
								<!-- 확인하는 날짜에 입력된 값이 있다면? "이미 투표하셨습니다" 띄우기 -->
							<%
								if(lunchDate.equals("")){
							%>
									<div>점심 메뉴 투표하기</div>
									<input type="radio" name="lunch" value="han">한식
									<input type="radio" name="lunch" value="yang">양식
									<input type="radio" name="lunch" value="il">일식
									<input type="radio" name="lunch" value="jung">중식
									<input type="radio" name="lunch" value="gi">기타
							
							<%
								}
							%>
						
							
					
					
				</div><!-- col마지막 -->
			<div class="col-3"></div>
		</div><!-- row -->
	</div><!-- container -->
</body>
</html>