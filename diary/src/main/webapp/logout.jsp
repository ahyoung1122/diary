<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
	
	//현재 값이 OFF아니고 ON이다 -> OFF변경후 loginForm으로 리다이렉트
	String sql2 = "update login set my_session='OFF' , off_date=now()";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	int row = stmt2.executeUpdate();
	System.out.println(row + "<--row");
	
	response.sendRedirect("/diary/loginForm.jsp");

%>

	