<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<%
//인증 분기코드
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
	if(rs1.next()){
		mySession = rs1.getString("mySession");//괄호안에 mySEssion은 String sql안에서 가져온것
		}
	//logout.jsp이니까 OFF로 변경해준다
	if(mySession.equals("OFF")) {
		response.sendRedirect("/diary/loginForm.jsp"); //get방식이기 때문에 jsp뒤에 ?표시해서 설정해준다.<이거 자꾸헷갈림>
		//자원반납을 마지막에 해야하는데 return값이 있어서 그 전에 작성해준다.
		rs1.close();
		stmt1.close();
		conn.close();
		return;//메서드 끝날때 사용함(코드 진행 끝내는 문법) 생략하지말고 꼭 적어주자
	}	
	
	String checkDate = request.getParameter("checkDate");
	
	String sql2 = "select diary_date diaryDate from diary where diary_date=?";
	// 결과가 있으면 이미 이 날짜에 일기가 있다=>이 날짜로는 입력불가!!
			PreparedStatement stmt2 = null;
	ResultSet rs2= null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, checkDate);
	
	rs2 = stmt2.executeQuery();
	if(rs2.next()){
		//이날짜 일기 불가능(이유는 현재 존재하기 때문임)
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=F");
	}else { 
		//이 날짜 일기 가능
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=T");
		
	}
	
%>