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
<body>

<!-- body content start-->
<div class="body-content">
	<decorator:body />
	<page:applyDecorator name="ga" />
</div>
<!-- body content end-->

</body>
</html>
