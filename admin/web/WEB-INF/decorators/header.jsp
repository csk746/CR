<%@ page import="java.util.Date" %>
<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>
<c:set var="nowDate" value="<%=new Date()%>"/>
<fmt:formatDate var="now" value="${nowDate}" pattern="yyyyMMddHHmmss" />

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
	<script src="${baseUrl }/resources/scripts/common.js?_n=${now}"></script>
	
	<!-- slick lab -->
	<!--right slidebar-->
    <link href="${slickLabHome}/css/slidebars.css" rel="stylesheet">

    <!--switchery-->
    <link href="${slickLabHome}/js/switchery/switchery.min.css" rel="stylesheet" type="text/css" media="screen" />

    <!--common style-->
    <link href="${slickLabHome}/css/style.css" rel="stylesheet">
    <link href="${slickLabHome}/css/style-responsive.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="${slickLabHome}/js/html5shiv.js"></script>
    <script src="${slickLabHome}/js/respond.min.js"></script>
	    <![endif]-->
    <!-- //slick lab -->
    
    <!-- bootstrap-select -->
   	<%-- <script src="${baseUrl}/resources/bootstrap-select/js/bootstrap-select.min.js"></script>
   	<link href="${baseUrl}/resources/bootstrap-select/css/bootstrap-select.min.css" rel="stylesheet"/> --%>
    <!-- //bootstrap-select -->
    
    <!-- iCheck -->
    <link href="${slickLabHome}/js/icheck/skins/all.css" rel="stylesheet">
   	<script src="${slickLabHome}/js/icheck/skins/icheck.min.js"></script>
   	<script src="${slickLabHome}/js/icheck-init.js"></script>
    <!-- //iCheck -->
    
    <!--bootstrap-inputmask-->
	<script src="${slickLabHome}/js/bs-input-mask.min.js"></script>

    <!--bootstrap-fileinput-master-->
    <link rel="stylesheet" type="text/css" href="${slickLabHome}/js/bootstrap-fileinput-master/css/fileinput.css" />
    <!--bootstrap-fileinput-master-->
	<script type="text/javascript" src="${slickLabHome}/js/bootstrap-fileinput-master/js/fileinput.js"></script>
	<script type="text/javascript" src="${slickLabHome}/js/file-input-init.js"></script>
    
    <!--bootstrap picker-->
    <link rel="stylesheet" type="text/css" href="${slickLabHome}/js/bootstrap-datepicker/css/datepicker.css"/>
    <script type="text/javascript" src="${slickLabHome}/js/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
    
    <!-- daum zipcode API -->
    <%--<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>--%>
    
    <!--Morris Chart -->
    <link rel="stylesheet" href="${slickLabHome}/js/morris-chart/morris.css">
    
    <script>
    	var baseUrl = "${baseUrl}";
		var env = "${env}";
    	$(document).ready(function(){
    		//$("select").selectpicker();

			// common title
			$("title").text(":: [" + env + "] Codiyrabbit Admin ::");

           	// 메뉴활성화
       	 	if( window.activeMenus != null && activeMenus.length > 0 ){
       	 		var $adminMenu1 = null;
       	 		var $adminMenu2 = null;
       	 		
   				var $menuIndex1 = null;
   				var $menuIndex2 = null;

				var $adminMenu1 = null;
				var breadcrumb = null;

       	 		if( activeMenus.length > 1 ){
       	 			// 1뎁스
       	 			$menuIndex1 = activeMenus[0]-1;
       	 			$adminMenu1 = $("li.menu-list").eq($menuIndex1);

					$adminMenu1 = $(".menu-list").eq($menuIndex1);
					$adminMenu1.addClass("nav-active");

					// 2뎁스 활성
					$menuIndex2 = activeMenus[1]-1;
					$adminMenu1.find("ul.child-list li").eq($menuIndex2).addClass("active");

					// breadcrumb
					var firstActiveMenu = $(".menu-list.nav-active");
					var breadcrumb = " 홈 > ";
					/* breadcrumb += firstActiveMenu.prevAll(".menu-title:eq(0)").text().trim() + " > "; */
					breadcrumb += firstActiveMenu.children().eq(0).text().trim();
					if( firstActiveMenu.children().length > 1 ) {
						breadcrumb += " > " + firstActiveMenu.find(".active").text().trim();
					}

       	 		} else if( activeMenus.length == 1 ){
					$menuIndex1 = activeMenus[0]-1;
					$adminMenu1 = $("li.menu-single").eq($menuIndex1);
					$adminMenu1.addClass("active");
					var firstActiveMenu = $(".menu-single");
					var breadcrumb = " 홈 > ";
					breadcrumb += $adminMenu1.text().trim();
				}

				console.log(breadcrumb);
       	 	}

			if( !window.pageTitle )
				if( firstActiveMenu != null )
					$(".page-head h3").text( firstActiveMenu.find(".active").text().trim() );
			else
				$(".page-head h3").text( window.pageTitle );
				
			$(".page-head .sub-title").text( breadcrumb );
    	});
    </script>
    
    <link rel="stylesheet" href="${baseUrl}/resources/css/admin.css">
    <link rel="stylesheet" href="${baseUrl}/resources/css/pages.css">

