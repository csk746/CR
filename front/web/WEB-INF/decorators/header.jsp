<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <meta name="author" content="Mosaddek" />
    <meta name="keyword" content="slick, flat, dashboard, bootstrap, admin, template, theme, responsive, fluid, retina" />
    <meta name="description" content="" />
    <link rel="shortcut icon" href="javascript:;" type="image/png">

	<script src="${baseUrl }/resources/scripts/libs/jquery.min.js"></script>
	<script src="${baseUrl }/resources/scripts/libs/jquery.form.js"></script>
	<script src="${baseUrl }/resources/scripts/libs/jquery.serialize-object.min.js"></script>
	<script src="${baseUrl }/resources/scripts/libs/underscore-min.js"></script>
	<script src="${baseUrl }/resources/scripts/common.js"></script>

    <!-- 나눔고딕 웹폰트 적용 -->
    <script src="//ajax.googleapis.com/ajax/libs/webfont/1.4.10/webfont.js"></script>
    <script type="text/javascript">
        WebFont.load({

            custom: {
                families: ['Nanum Gothic'],
                urls: ['http://fonts.googleapis.com/earlyaccess/nanumgothic.css']
            }

        });
    </script>

    <script>
    	var baseUrl = "${baseUrl}";
		var env = "${env}";
    	$(document).ready(function(){

    	});
    </script>

    <link rel="stylesheet" href="${baseUrl}/resources/css/common${isMobile ? '_m' : ''}.css">

