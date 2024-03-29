<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import="java.net.*"%>
<%@ page import="java.sql.*" %>
<%
   //0.로그인(인증)분기 
   //diary.login.my_session =? "OFF" =>redirect("loginForm.jsp")
   
 /*   String sql1 = "select my_session mySession from login"; //my_session에서 가져옴
   //mySession은 별칭 my_session은 login table안에 있는값
   Class.forName("org.mariadb.jdbc.Driver");
   Connection conn = null;
   PreparedStatement stmt1 = null;
   ResultSet rs1 = null;
   conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
   stmt1 = conn.prepareStatement(sql1);
   rs1 = stmt1.executeQuery(); //쿼리실행코드
   String mySession = null;
   if(rs1.next()){ //한행씩 실행하는 코드
      mySession = rs1.getString("mySession");//괄호안에 mySession은 String sql안에서 가져온것
      }//mySession안에 on,off둘중에 하나가 있을텐데 뭔지 모르니까 일단 선언. 밑에 mySession.equals를 위해서
   if(mySession.equals("ON")) {
      response.sendRedirect("/diary/diary.jsp");
      //자원반납을 마지막에 해야하는데 return값이 있어서 그 전에 작성해준다.
      rs1.close();
      stmt1.close();
      conn.close();
      return;//메서드 끝날때 사용함(코드 진행 끝내는 문법) 생략하지말고 꼭 적어주자
   } //여기 조건 안맞으면 무조건 스킵해버림. 
   
   rs1.close();
   stmt1.close();
   conn.close();*/
   
   //지금까지는 DB를 사용해서 로그인을 구현하였고 앞으로는 session을 이용하여 로그인구현할것
   //로그인(인증)분기 Session사용으로 변경
   //로그인 사용시 session에 loginMember라는 변수를 만들고 값으로 로그인 아이디를 저장
   String loginMember = (String)(session.getAttribute("loginMember")); 
  //getAttribute 메소드는 찾는 변수가없으면 null값을 반환한다.
  //null이면 로그아웃상태, null이 아니면 로그인 상태
  //여기loginForm에서는 null값이어야만 출력이가능하다->로그아웃상태
  System.out.println(loginMember + " ");
  
  if(loginMember != null){
	  response.sendRedirect("/diary/diary.jsp");
	  return;//메서드 끝날때 사용함(코드 진행 끝내는 문법) 생략하지말고 꼭 적어주자
  }
  
  //요청값 작성
  String errMsg = request.getParameter("errMsg"); //diary.jsp에서 받아오는 요청값이라서 작성해주어야한다. 
%>

<!DOCTYPE html>
<html>
<head>
      <meta charset="UTF-8">
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
      <title>loginForm</title>
      <style>
      
      body{
		background-image: url("./image/jerry.png");
		text-align: center;'
		}
	*{
		font-family: CookieRun;
		}
	container {
		text-align: center;
	}
      </style>
</head>
<body>
<div class="container">
		<div class="row">
			<div class="col"></div>
			<div class="col"></div>
				
			<div class="mt-10 col-4 bg-black border shadow p-3 mb-5 bg-body-tertiary rounded" >
				
      <div>
      	<div class="row" style=" 
      	height: 250px; width: 430px;
      	background-image: url(./image/tomjerry.png);">
      	
      	</div>
      <!-- //언제출력할거? -->
      <%
            if(errMsg != null){
      %>
            <%=errMsg%>
      <%               
            }
      %>
      
      </div>
      <h1 style="color :#420100;">WELCOME!</h1> 
      	<form action="./loginAction.jsp">
				<table>
					<tr>
						<td><label >아이디</label></td>
						<td><input type="text" name="memberId"></td>
					</tr>
					<tr>
						<td><label>비밀번호</label></td>
						<td><input type="password" name="memberPw"></td>
					</tr>
				</table><br>
			<button type="submit" style="border-radius: 5px; background-color: #FF8585; color :#420100;">🧀로그인🧀</button>
		</form>
			</div><!-- col-7마지막 -->
				<div class="col"></div>
				<div class="col"></div>
			</div><!-- row -->
	</div><!-- container -->
</body>
</html>

