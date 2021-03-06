<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="Admin Template">
	<meta name="keywords" content="admin dashboard, admin, flat, flat ui, ui kit, app, web app, responsive">
	<link rel="shortcut icon" href="img/ico/favicon.png">
	<title>400 Error</title>

	<!-- Base Styles -->
	<link href="${slickLabHome}/css/style.css" rel="stylesheet">
	<link href="${slickLabHome}/css/style-responsive.css" rel="stylesheet">
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
	<script src="${slickLabHome}/js/html5shiv.min.js"></script>
	<script src="${slickLabHome}/js/respond.min.js"></script>
	<![endif]-->


</head>

<body class="body-404">

<section class="error-wrapper">
	<i class="icon-500"></i>
	<div class="text-center">
		<h2 class="green-bg">page not found</h2>
	</div>
	<p>Something went wrong or that page doesn’t exist yet.</p>
	<a href="#" onclick="history.back()" class="back-btn">Back</a>
</section>

</body>
</html>

