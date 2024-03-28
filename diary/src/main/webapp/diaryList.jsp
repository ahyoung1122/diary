<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	
	String sql1 = "select my_session mySession from login";
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
%>	

<%
	// 출력 리스트 모듈
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	/*
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	*/
	
	int startRow = (currentPage-1)*rowPerPage; // 1-0, 2-10, 3-20, 4-30,....
	
	String searchWord = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
	}
	/* 쿼리 적어둔거 옮겨적기
		select diary_date diaryDate, title
		from diary
		where title like ?
		order by diary_date desc
		limit ?, ?
	*/
	String sql2 = "select diary_date diaryDate, title from diary where title like ? order by diary_date desc limit ?, ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%"+searchWord+"%");
	stmt2.setInt(2, startRow);
	stmt2.setInt(3, rowPerPage);
	rs2 = stmt2.executeQuery();
%>

<%
	// lastPage 모듈
	String sql3 = "select count(*) cnt from diary where title like ?";
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1, "%"+searchWord+"%");
	rs3 = stmt3.executeQuery();
	int totalRow = 0;
	int pageList = totalRow;
	System.out.println(pageList+"=pageList");
	
	
	if(rs3.next()) {
		totalRow = rs3.getInt("cnt");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<title>diaryList</title>
	<style>
	body{
				background-image: url("./image/jerry.png");
				text-align: center;
			}
		*{
			font-family: CookieRun;
			}
		a{
		text-decoration: none;
		color : black;
		}
		a:hover{
		background : pink;
		color : ivory;
		}
		p{text-align: right;}
		#back1{
		text-align: left;
		}
		th{
		color : #BD5C24;
		font-size: 20px;
		text-align: center;
		}
		.back a{
		background-color: #F15F5F;
		color:ivory;
		}
		#di {
				background-color: #6B9900;
				color : ivory;
				}
	 .box {
	    display: flex;
	    align-items: center;
	    justify-content: center;
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
								<a id="back1"href="./diary.jsp" style="color : green;">뒤로가기</a>
								<a id="di" href="./diary.jsp">다이어리</a>
							</p>
					</div>
					<h2 style="color : #420100;">
						일기 목록🐹
					</h2><hr>
					
								<div class="box">
									<table border="1">
										<tr>
											<th>no</th>
											<th>날짜 &nbsp;</th>
											<th>제목 &nbsp;</th>
										</tr>
										<%
											while(rs2.next()) {
										%>
										<!-- diaryOne.jsp?diaryDate= a태그 추가(날짜, 제목) -->
										<!-- 앞에 listNumber도 추가해보면 좋을듯? -->
												<tr>
													<td><%=pageList=pageList+1 %></td>
													<td><a href="./diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>"><%=rs2.getString("diaryDate")%></a></td>
													<td><a href="./diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>"><%=rs2.getString("title")%></a></td>
												</tr>
										<%		
											}
										%>
									</table>
								</div>
								
								
								<div><%=currentPage%></div><!-- 현재 페이지를 나타냄 -->
								<div><!-- 이전,다음 버튼 만들기 -->
											<%
												if(currentPage >1){
													
											%>
													<button><a href="./diaryList.jsp?currentPage=1&searchWord=<%=searchWord %>">처음</a></button>
													<button><a href="./diaryList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord %>">이전</a></button>
											<%
												}
											%>
											
											<%
											if(currentPage<lastPage || currentPage ==1 ){
											%>
													<button><a href="./diaryList.jsp?currentPage=<%=currentPage+1%>&searchWord=<%=searchWord%>">다음</a></button>
													<button><a href="./diaryList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>">마지막</a></button>
											<%
											}
											%>
								</div><hr>
							<form method="get" action="/diary/diaryList.jsp">
								<div>
									<span style="color : #751400; font-weight: bold; font-size: 20px;">제목검색 :<span>
									<input type="text" name="searchWord">
									<button type="submit" class="btn btn-dark">검색</button>
								</div>
							</form>
			</div><!-- col마지막 -->
			<div class="col-3"></div>
			</div><!-- row -->
	</div><!-- container -->
</body>
</html>