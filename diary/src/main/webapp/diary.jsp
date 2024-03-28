<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<%@ page import = "java.util.*" %>
<%
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	
	String sql1 = "select my_session mySession from login";
	//mySession은 별칭 my_session은 login table안에 있는값
	//인수 : java에서는 _바를 안쓰기 때문에 카멜방식을 사용한다 원래라면 "select my_session from login"인데 mySession으로 변수값을 바꿔준것.!!
	//선생님 : db에서는 카멜 방식을 사용할 수 없기 때문에 java에서는 _바를 사용해야한다.
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
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
	
	
	// 달력 API
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	Calendar target = Calendar.getInstance();
	
	if(targetYear != null && targetMonth != null) {
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth)); 
	}
	
	target.set(Calendar.DATE, 1);
	
	// 달력 타이틀로 출력할 변수
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);

int time =target.get(Calendar.HOUR_OF_DAY);
int minute = target.get(Calendar.MINUTE);

	
	int yoNum = target.get(Calendar.DAY_OF_WEEK); // 일:1, 월:2, .....토:7
	System.out.println(yoNum); 
	// 시작공백의 개수 : 일요일 공백이 없고, 월요일은 1칸, 화요일은 2칸,....yoNum - 1이 공백의 개수
	int startBlank = yoNum - 1;
	int lastDate = target.getActualMaximum(Calendar.DATE); // target달의 마지막 날짜 반환
	System.out.println(lastDate + " <-- lastDate");
	int countDiv = startBlank + lastDate;
	
	// DB에서 tYear와 tMonth에 해당되는 diary목록 추출
	String sql2 = "select diary_date diaryDate, day(diary_date) day, feeling, left(title,5) title from diary where year(diary_date)=? and month(diary_date)=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, tYear);
	stmt2.setInt(2, tMonth+1);
	System.out.println(stmt2);
	
	rs2 = stmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
		<title>diary</title>
		
<style>

body{
background-image: url("./image/jerry.png");
}
*{
	font-family: CookieRun;
	}
		.cell {
			float : left;
			background-color:#FFCBCB;
			width: 60px; height: 50px;
			color : ivory;
			border: 1px solid #FFCBCB;
         	border-radius: 2px;
         	margin: 3px;
		}
		/* .cell:hover {
			font-size: 27px;
		} */
		.cell2{
			float : left;
			background-color: ;
			width: 60px; height: 25px;
			color : #BD5C24;
			font-weight : 300;
			font-size:15px;
         	border-radius: 2px;
         	margin: 3px;text-align: center;
		}
		.sun{
				clear : both;
				color : red;
		}
		.sat{
				color : blue;
		}
		a {
			
			font-weight: bolder;
			color : gray;
			 text-decoration: none;
		}
		.diaryTitle a{
		font-size: 10px;
		text-decoration: none;
		color : gray;
		}
		a:hover {
		 	color : white;
		 	background-color: orange;
		}
	li{
	list-style-type:  circle;
	}
	.logout a{
	color : white;
	background-color: #BD5C24;
	
	}
	.il a{
	color : white;
	background-color: orange;
	}
	.list a{
	background-color: green; 
	color : white;
	}
	
</style>

</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col"></div>
			<div>
						<a href="./diary.jsp">다이어리 모양으로 보기</a>
						<a href="./diaryList.jsp">게시판 모양으로 보기</a>
				</div>
			<div class="mt-5 col-2 bg-black border shadow p-3 mb-5 bg-body-tertiary rounded" >
			<!-- 오늘의 날짜, 현재 시간, 귀여운 그림, 메모 등등을 추가하기! -->
				<div class = "column1">
				<span style="float: left;"  style= "font-size: 5px;">
				<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>" >저번달</a></span>
				<span style="float : right;" style= "font-size: 5px;">
				<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>">다음달</a></span>
				</div><br><hr>
				<div class=img style="height: 100px; width: 180px; background-image:  url(./image/jerry3.png)"></div>
				<div class="column2">
				📆<%=tYear%>년 <%=tMonth+1%>월
				</div>
				<div class="column3">
				🕑<%=time %> 시 <%=minute %>분
				</div>
				<span style= "font-size: larger; font-weight: bolder; ">✔️ToDoList</span>
				<ul>
					<li>diary</li>
					<li>loginForm</li>
					<li>addDiaryForm</li>
				</ul>
				   <div class="logout"><a href="/diary/logout.jsp">로그아웃</a></div>
				</div>
			<div class="mt-5 col-5 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">	
              	<div class="column4"><span style = "color : white; background-color: #F15F5F;">
              	&nbsp;<%=tMonth+1 %>월 DIARY&nbsp;
              	</span>
              	<div class="il"><a href="./addDiaryForm.jsp">일기쓰기</a></div>
              	<div class="list"><a href="./diaryList.jsp">내 일기 LIST</a></div>
              	</div>
	<div class="cell2" style = "color : red;">일요일</div>
	<div class="cell2">월요일</div>
	<div class="cell2">화요일</div>
	<div class="cell2">수요일</div>
	<div class="cell2">목요일</div>
	<div class="cell2">금요일</div>
	<div class="cell2" style = "color : blue;">토요일</div>
	<%
		for(int i=1; i<=countDiv; i=i+1) {
			
			if(i%7 == 1) {
	%>
				<div class="cell sun">
	<%			
			}else if (i%7 == 0){
		%>
			<div class = "cell sat">
		<%		
			}else {
	%>
				<div class="cell">
	<%				
			}
			if(i-startBlank > 0) {
				%>
						<%=i-startBlank%><br>
				<%
						// 현재날짜(i-startBlank)의 일기가 rs2목록에 있는지 비교
						while(rs2.next()) {
							// 날짜에 일기가 존재한다
							if(rs2.getInt("day") == (i-startBlank)) {
				%>
								<div>
									<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
								  	<%=rs2.getString("feeling")%></a>
									<%-- <p class = "diaryTitle"><a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
										<%=rs2.getString("title")%>
									</a></p> --%><!-- 이부분 너무 지저분해서 일단은 보류해두기 <그래서 위의 feeling으로 다이어리one으로들어가게 -->
								</div>
				<%				
								break;
							}
						}
						rs2.beforeFirst(); // ResultSet의 커스 위치를 처음으로...
					} else {
				%>
						&nbsp;
				<%		
					}
				%>
			</div>
	<%		
		}
	%>

			</div><!-- col-7마지막 -->
				<div class="col"></div>
				<div class="col"></div>
			</div><!-- row -->
	</div><!-- container -->
</body>
</html>