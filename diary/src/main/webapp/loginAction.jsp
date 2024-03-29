<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<%
	//session=on이면 또다시 입력을 안해도 페이지로 넘어가는걸 만든 코드✔️
	//0.로그인(인증)분기 
	//diary.login.my_session =? "OFF" =>redirect("loginForm.jsp")
	
/* 	String sql1 = "select my_session mySession from login"; //my_session에서 가져옴
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
	if(mySession.equals("ON")) {
		response.sendRedirect("/diary/loginForm.jsp"); //get방식이기 때문에 jsp뒤에 ?표시해서 설정해준다.<이거 자꾸헷갈림>
		//자원반납을 마지막에 해야하는데 return값이 있어서 그 전에 작성해준다.
		rs1.close();
		stmt1.close();
		conn.close();
		return;//메서드 끝날때 사용함(코드 진행 끝내는 문법) 생략하지말고 꼭 적어주자
	} */
	String loginMember = (String)(session.getAttribute("loginMember")); 
	  //getAttribute 메소드는 찾는 변수가없으면 null값을 반환한다.
	  //null이면 로그아웃상태, null이 아니면 로그인 상태
	  //여기loginForm에서는 null값이어야만 출력이가능하다->로그아웃상태
	  System.out.println(loginMember + " ");
	  
	  if(loginMember != null){
		  response.sendRedirect("/diary/diary.jsp");
		  return;//메서드 끝날때 사용함(코드 진행 끝내는 문법) 생략하지말고 꼭 적어주자
	  }
	  
	  //loginMember가 null 이다 ->session공간에 loginMember변수를 생성...
%>
<%
	//1.요청값 분석(loginForm에서 무엇이 넘어올것인지 잘 생각해봐) ->로그인 성공 - >session에 loginMember변수를 생성
		String memberId = request.getParameter("memberId");
		String memberPw = request.getParameter("memberPw");
		
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = null;
		PreparedStatement stmt1 = null;
		ResultSet rs1 = null;
		conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		
		String sql2 = "select member_id memberId from member where member_id=? and member_pw=?";
		PreparedStatement stmt2 = null;
		ResultSet rs2 = null;
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1,memberId);
		stmt2.setString(2,memberPw);
		
		rs2 = stmt2.executeQuery();
		
		
		if(rs2.next()){
				//로그인 성공 
				//diary.login.my_session값을 -> "ON"으로 변경//stmt3를 만들고 updateQuery하나 만들어준다 그리고 diary.jsp로 연결하면 됨.
				System.out.println("로그인 성공");
			/* 	String sql3 = "update login set my_session = 'ON', on_date = NOW() "; 
				PreparedStatement stmt3 = conn.prepareStatement(sql3);
				
				int row = stmt3.executeUpdate();
				System.out.println(row+"<--row"); */
				//로그인 성공시 DB값 설정 -> session변수 세팅으로 변경 
				session.setAttribute("loginMember", rs2.getString("memberId"));
				
				response.sendRedirect("/diary/diary.jsp");
				
		}else{
				//로그인 실패
				System.out.println("로그인 실패");
			String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요", "utf-8");
			response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		}
		
	
/* 	rs1.close();
	stmt1.close();
	rs2.close();
	stmt2.close();
	conn.close(); */
	
	
%>