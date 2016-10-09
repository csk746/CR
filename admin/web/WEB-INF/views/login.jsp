<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>
<html>
<head>
	<title>Home</title>
	<page:applyDecorator name="header" />
	<script type="text/javascript" src="${baseUrl }/resources/scripts/libs/jquery.cookie.js"></script>
	<script type="text/javascript">

		$(document).ready(function(){
			
			onEnterHandler('username', function(){ $("#loginBtn").click(); });
			onEnterHandler('password', function(){ $("#loginBtn").click(); });
			
			$("#loginBtn").click(function(){
				
				if( ValidateUtil.isBlank('username', '아이디를 입력해 주세요.', true) ) return;
				if( ValidateUtil.isBlank('password', '비밀번호를 입력해 주세요.', true) ) return;

				$("#loginFrm").ajaxSubmit(function(res){
					if( res.result ){
						alert("로그인이 완료 되었습니다.");
						location.href = "<c:url value="/main"/>";
					} else {
						if( res.message == "enable" ){
							alert("승인되지 않는 아이디입니다.");	
						} else {
							alert("아이디 또는 비밀번호 오류입니다.");
						}
					}
				});
				
			});
			
		});
	</script>
	
</head>
<body>

	<body class="login-body">

      <div class="login-logo" style="background-color: #fff;">
          <img src="${baseUrl }/resources/images/logo-text.jpg" alt=""/>
      </div>

      <h2 class="form-heading">Admin Login</h2>
      <div class="container log-row">
          <form id="loginFrm" class="form-signin" action="<c:url value="/doLogin"/>" method="post">
              <div class="login-wrap">
                  <input type="text" class="form-control" placeholder="User ID" autofocus id="username" name="username">
                  <input type="password" class="form-control" placeholder="Password" id="password" name="password">
                  <a id="loginBtn" class="btn btn-lg btn-success btn-block" type="submit">로그인</a>
              </div>
          </form>
      </div>
	
</body>
</html>
