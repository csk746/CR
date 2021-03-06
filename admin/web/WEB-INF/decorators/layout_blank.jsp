<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><decorator:title default=":: Codiyrabbit Admin ::" /></title>

<page:applyDecorator name="header" />

<decorator:head />
</head>
<body class="sticky-header">

	<section>
	
		<page:applyDecorator name="left" />
		
		<!-- body content start-->
        <div class="body-content" style="min-height: 1200px;">

			<page:applyDecorator name="top" />

			<decorator:body />

			<page:applyDecorator name="footer" />
            
        </div>
        <!-- body content end-->
		
	
	</section>

	<page:applyDecorator name="bottomScript" />
</body>
</html>
