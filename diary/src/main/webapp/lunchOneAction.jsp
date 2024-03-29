<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import = "java.util.*" %>
<%
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	String loginMember = (String)(session.getAttribute("loginMember"));
		if(loginMember == null){
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		 response.sendRedirect("./loginForm.jsp?errMsg="+errMsg);
		return;// 코드 진행을 끝내는 문법 
		}
	
	/* 
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
	} */
	
	Calendar target = Calendar.getInstance();
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
%>	
<%
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = null;
		PreparedStatement stmt1 = null;
		ResultSet rs1 = null;
		conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		String sql2 = "SELECT lunch_date lunchDate, menu, count(*) cnt from lunch group by menu";
		PreparedStatement stmt2 = null;
		ResultSet rs2 = null;
		stmt2 = conn.prepareStatement(sql2);
		rs2 = stmt2.executeQuery();
		
		String lunchDate = request.getParameter("lunch_date");
		
		rs2 = stmt2.executeQuery();
		if(rs2.next()){
			//이날짜 일기 불가능(이유는 현재 존재하기 때문임)
			response.sendRedirect("./lunchOne.jsp?lunchDate="+lunchDate+"&ck=F");
		}else { 
			//이 날짜 일기 가능
			response.sendRedirect("./lunchOne.jsp?lunchDate="+lunchDate+"&ck=T");
			
		}
%>