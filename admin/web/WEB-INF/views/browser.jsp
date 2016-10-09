<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>
<html>
<head>
	<title>Home</title>
	<page:applyDecorator name="header" />
	<script type="text/javascript" src="${baseUrl }/resources/scripts/libs/jquery.cookie.js"></script>
	<script type="text/javascript">

		$(document).ready(function(){

		});
	</script>

</head>
<body>

<body class="login-body">

<div class="login-logo" style="background-color: #fff;">
	<img src="${baseUrl }/resources/images/logo-text.jpg" alt=""/>
</div>

<%--<h2 class="form-heading">Admin Login</h2>--%>
<div class="container log-row" style="color:white;text-align:center;">
	<br/>
	<h4>지원하지 않는 브라우져 입니다.</h4>
	<p>지원 브라우져 : <a href="https://www.google.co.kr/chrome/browser/desktop/" target="_blank">Chrome 다운로드</a></p>
	<p>현재 브라우져 : ${browser}</p>
</div>

</body>
</html>
