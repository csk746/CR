<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><decorator:title default=":: [${env}] Codiyrabbit ::" /></title>

<page:applyDecorator name="header" />

<decorator:head />
</head>
<body class="${isMobile ? 'm' : ''}">

	<!-- body content start-->
	<div class="body-content">

		<c:choose>
			<c:when test="${isMobile}">
				<page:applyDecorator name="mobileTop" />
			</c:when>
			<c:otherwise>
				<page:applyDecorator name="top" />
			</c:otherwise>
		</c:choose>

		<decorator:body />

		<page:applyDecorator name="footer" />

	</div>
	<!-- body content end-->

	<page:applyDecorator name="bottomScript" />

	<page:applyDecorator name="ga" />


</body>
</html>
