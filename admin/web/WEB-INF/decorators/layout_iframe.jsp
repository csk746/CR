<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><decorator:title default=":: Codiyrabbit Admin ::" /></title>

<page:applyDecorator name="header" />

<decorator:head />
<style>
	body { background-color:#f3f3f3 }
	.sticky-header .body-content{margin-top:0;margin-left:0;padding-top:0;}
</style>
</head>
<body class="sticky-header">

	<section>
		<!-- body content start-->
        <div class="body-content" style="min-height: 1200px;">

			<decorator:body />

        </div>
        <!-- body content end-->

	</section>

	<page:applyDecorator name="bottomScript" />
	<script>
		parent.$("iframe").height($(document).height());
	</script>
</body>
</html>
