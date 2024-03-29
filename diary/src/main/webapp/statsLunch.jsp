<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import = "java.util.*" %>
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
	
	Calendar target = Calendar.getInstance();
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
%>	

<%
	/*
	SELECT menu,COUNT(*) 
	FROM lunch
	GROUP BY menu
	ORDER BY COUNT(*) DESC;
	*/
	String sql2 = "SELECT lunch_date lunchDate, menu, count(*) cnt from lunch group by menu";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<title>statsLunch</title>
	<style>
		body{
			background-image: url("./image/jerry.png");
			}
			*{
			font-family: CookieRun;
			}
			a{
			text-decoration: none;
			background-color: pink;
			color : ivory;
			}
	</style>
</head>
<body>
	<%
				double maxHeight = 500;
				double totalCnt = 0; //
				while(rs2.next()) {
					totalCnt = totalCnt + rs2.getInt("cnt");
				}
				
				rs2.beforeFirst();
	%>
	<div class="container">
		<div class="row">
			<div class="col-2"></div>
				<div class="mt-5 col-4 bg-black border shadow p-3 mb-5 bg-body-tertiary rounded" >
					<div><a href="./diary.jsp">뒤로가기</a></div>
					<div><a href="./lunchOne.jsp">상세보기</a></div>
					<h2 style="color : #420100;">
						점심메뉴 통계🐹
					</h2>
						<hr>
							<p>이번달 : <%=tMonth+1%>월</p>
									<div>
										전체 투표수 : <%=(int)totalCnt%>
									</div>
										<table border="" style="width: 400px;">
											<tr>
												<%	
													String[] c = {"#FF0000", "#FF5E00", "#FFE400", "#2F9D27", "#4374D9"};
													int i = 0;
													while(rs2.next()) {
														int h = (int)(maxHeight * (rs2.getInt("cnt")/totalCnt));
												%>
														<td style="vertical-align: bottom;">
															<div style="height: <%=h%>px; 
																		background-color:<%=c[i]%>;
																		text-align: center">
																<%=rs2.getInt("cnt")%>
															</div>
														</td>
													<%		
															i = i+1;
														}
													%>
											</tr>
											
											<tr>
													<%
														// 커스의 위치를 다시 처음으로
														rs2.beforeFirst();
																	
														while(rs2.next()) {
													%>
															<td><%=rs2.getString("menu")%></td>
													<%		
														}
													%>
											</tr>
						</table>
				</div><!-- col마지막 -->
					<div class="mt-5 col-3 bg-black border shadow p-3 mb-5 bg-body-tertiary rounded">
						<h2 style="color : #420100;">
						 	날짜별 메뉴
						</h2>
							<table border="1">
								<tr>
									<td>날짜</td>
									<td>메뉴</td>
								</tr>
									<%
									while(rs2.next()){
									%>
											<tr>
												<td></td>
												<td></td>
											</tr>
									<%
									}
									%>
							</table>
						
					
					</div>
				<div class="col-3"></div>
		</div><!-- row -->
	</div><!-- container -->
</body>
</html>
