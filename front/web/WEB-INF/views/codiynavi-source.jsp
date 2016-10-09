<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />
<fmt:setLocale value="ko"/>

<html>
<head>
	<title>Home</title>
	<style>
		.codiynavi .control {position:absolute;top:0;left:540px;width:200px;height:200px;border:2px solid #e0e0e0;font-size:14px;padding:50px 10px;}

		.codiynavi .control .url,
		.codiynavi .control .html{border:1px solid #b3b3b3;width:200px;}

		.codiynavi .control .html{margin-top:20px;width:200px;}
		.codiynavi .control .html .data{width:92%;padding:10px 4%;border:0;}
		.codiynavi .control input {width:92%;padding:10px 4%;border:0;}

		.codiynavi .control .text,
		.codiynavi .control .data{text-align:center;height:20px;font-size:12px;}

		.codiynavi .control .text{font-weight:bold;background-color:#e4e4e4;cursor:pointer;padding:10px;}
		.codiynavi .control .text{border-top:1px solid #b3b3b3;}

	</style>
	<script src="http://localhost:8080/admin/resources/scripts/libs/jquery.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){

			// 링크 변경
			$("a[href='productUrl']").attr("href", "${baseFrontUrl}/main?viewId=${product.id}");

			var htmlData = $(".codiynavi").clone();
			htmlData.find(".control").remove();
			$(".control .html .data").val(removeNewlines(htmlData[0].outerHTML));

			$(".copyBtn").click(function(){
				alert("선택된 텍스트를 CTRL + C 로 복사하세요.");
				$(this).parent().find(".data").select();
			});

			parent.$("#shareHtml").val( $(".control .html .data").val() );
			parent.$(".share").fadeIn();

		});

		function removeNewlines(str) {
			str = str.replace(/\s{2,}/g, ' ');
			str = str.replace(/\t/g, ' ');
			str = str.toString().trim().replace(/(\r\n|\n|\r)/g,"");
			return str;
		}

		function getSource(){
			return $(".html .data").val();
		}

	</script>
</head>
<body>

<!--body wrapper start-->
<div class="wrapper">

	<div class="codiynavi" style="position:relative;font-family: 'Nanum Gothic';padding:5px;">

		<div class="control">
			<div class="url">
				<%--<div class="data ellipsis">${baseUrl}/product/codiynavi?code=${product.code}</div>--%>
				<input readonly type="text" class="data copyBtn" value="${baseUrl}/product/codiynavi?code=${product.code}"/>
				<div class="text copyBtn">URL 복사</div>
			</div>
			<div class="html">
				<input readonly type="text" class="data copyBtn"/>
				<div class="text copyBtn">HTML 복사</div>
			</div>
		</div>

		<div>
			<c:set var="itemCount" value="0"/>
			<c:forEach items="${points}" var="point" varStatus="status">
				<c:set var="itemCount" value="${itemCount + fn:length(point.items)}"/>
			</c:forEach>

			<%-- Traking --%>
			<img src="${baseFrontUrl}/codiynavi/images/p-${product.id}.gif"/>

			<%--<table cellpadding="0" cellspacing="0" style="max-width:456px;width:100%;height:auto;border:2px solid #e0e0e0;">--%>
			<table cellpadding="0" cellspacing="0" style="max-width:456px;width:100%;height:auto;">
				<tr>
					<td colspan="5">
						<a href="productUrl" target="_blank"><img width="100%" style="vertical-align:top" src="${baseFrontUrl}/resources/uploads${product.mainImage.filePath}/${product.mainImage.getFileNameAddType('cap')}"/></a>
					</td>
				</tr>
				<tr style="background-color:#ebebee"><!-- 포인트 이름 -->
					<c:forEach items="${points}" var="point" varStatus="status">
						<c:if test="${fn:length(point.items) > 0}">
							<c:set var="colspan" value="${fn:length(point.items)}"/>
							<%--<c:if test="${status.last}">--%>
							<%--<c:set var="colspan" value="${fn:length(point.items) + (5-itemCount)}"/>--%>
							<%--</c:if>--%>
							<td <c:if test="${!status.first}">style="border-left:1px solid #fff"</c:if> colspan="${colspan}"><div style="padding-left:5px;background-color:#aeaeae;">${fn:toUpperCase(point.name)}</div></td>
						</c:if>
					</c:forEach>
					<c:forEach begin="1" end="${5-itemCount}">
						<td width="20%">&nbsp;</td>
					</c:forEach>
				</tr>
				<tr style="background-color:#ebebee"><!-- 아이템 -->
					<c:forEach items="${points}" var="point" varStatus="status">
						<c:forEach items="${point.items}" var="item" varStatus="status2">
							<%--<td width="20%" align="center" style="height:120px;padding-right:5px;background: url('${baseUrl}/resources/uploads${item.thumbSUrl}') no-repeat;background-size: 100%;">--%>
							<td width="20%" <c:if test="${status2.first && status.index > 0}">style="border-left:1px solid #fff"</c:if>>
									<%--<span style="position:relative;display:block;overflow:hidden;background-color:#ebebee;">--%>
									<%--&lt;%&ndash;<img src="${baseUrl}/resources/uploads${item.thumbSUrl}" style="width:100%;z-index:1;"><img src="${baseUrl}/resources/images/bg-item.png" style="width:100%;z-index:2;top:0;left:0;margin-top:-133px;">&ndash;%&gt;--%>
									<%--&lt;%&ndash;<img src="${baseUrl}/resources/images/bg-item.png" width="100%">&ndash;%&gt;--%>
									<%--<img src="${baseUrl}/resources/uploads${item.thumbSUrl}" width="100%">--%>
									<%--</span>--%>
								<a href="${item.link}"><img style="vertical-align:top" src="${baseUrl}/resources/uploads${item.thumbSUrl}" width="100%"></a>
							</td>
						</c:forEach>
					</c:forEach>
					<c:forEach begin="1" end="${5-itemCount}">
						<td width="20%">&nbsp;</td>
					</c:forEach>
				</tr>
				<tr height="25" style="background-color:#ebebee"><!-- 아이템명 -->
					<c:forEach items="${points}" var="point" varStatus="status">
						<c:forEach items="${point.items}" var="item" varStatus="status2">
							<c:set var="title" value="${item.title}"/>
							<c:if test="${fn:length(title) > 10}">
								<c:set var="title" value="${fn:substring(title, 0, 7)}..."/>
							</c:if>
<<<<<<< HEAD
							<td style="<c:if test="${status2.first}">border-left:1px solid #fff;</c:if>font-size: 0.8em!important;text-align: center;">
                                <a href="${item.link}"><div style="text-align: center;padding-right:5px;">${title}</div></a>
                            </td>
=======
							<td style="<c:if test="${status2.first && status.index > 0}">border-left:1px solid #fff;</c:if>font-size: 0.8em!important;text-align: center;"><div style="text-align: center;padding-right:5px;">${title}</div></td>
>>>>>>> 7de9bc8f14544bac6a1bae7000d35f46fc6fddc4
						</c:forEach>
					</c:forEach>
					<c:forEach begin="1" end="${5-itemCount}">
						<td width="20%">&nbsp;</td>
					</c:forEach>
				</tr>
				<%--
				<tr><!-- 아이템 가격 -->
					<c:forEach items="${points}" var="point" varStatus="status">
						<c:forEach items="${point.items}" var="item" varStatus="status2">
							<td align="center" style="padding-right:5px;font-weight:bold;font-size: 0.8em!important;text-align: center;"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" /></td>
						</c:forEach>
					</c:forEach>
					<c:forEach begin="1" end="${5-itemCount}">
						<td width="20%">&nbsp;</td>
					</c:forEach>
				</tr>
				--%>
			</table>

		</div>

	</div>

</div>
<!--body wrapper end-->

</body>
</html>
