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
	<script src="${baseUrl}/resources/scripts/libs/jquery.min.js"></script>
	<script src="${baseUrl}/resources/scripts/zeroclipboard/jquery.zeroclipboard.min.js"></script>
		<script type="text/javascript">
		$(document).ready(function(){
			// 링크 변경
			$("a[href='productUrl']").attr("href", "${baseFrontUrl}/main?viewId=${product.id}");

			var htmlData = $(".codiynavi").clone();
			htmlData.find(".control").remove();
			$(".control .html .data").val(removeNewlines(htmlData[0].outerHTML));

//			$(".copyBtn").click(function(){
//				alert("선택된 텍스트를 CTRL + C 로 복사하세요.");
//				$(this).parent().find(".data").select();
//			});



			$(document).on("copy", ".copyBtn", function(/* ClipboardEvent */ e) {
				var copyData = "";
				if( $(this).text().indexOf("HTML") > -1 ){
					copyData = $(this).parent().find("input").val();
				}
				if( $(this).text().indexOf("URL") > -1 ){
					copyData = $(this).parent().find("input").val();
				}
				e.clipboardData.clearData();
				e.clipboardData.setData("text/plain", copyData);
				e.preventDefault();
				alert("복사 되었습니다.");
			});

		});

		function removeNewlines(str) {
			str = str.replace(/\s{2,}/g, ' ');
			str = str.replace(/\t/g, ' ');
			str = str.toString().trim().replace(/(\r\n|\n|\r)/g,"");
			return str;
		}
	</script>
</head>
<body>

<!--body wrapper start-->
<div class="wrapper">

	<div class="codiynavi" style="position:relative;font-family: 'Nanum Gothic';width:436px;border:2px solid #e0e0e0;padding:5px;">

		<table cellspacing="0" cellpadding="0" width="436">
			<tr><td>
				<a href="productUrl" target="_blank"><img width="100%" src="${baseFrontUrl}/resources/uploads${product.mainImage.filePath}/${product.mainImage.getFileNameAddType('cap')}"/></a>
			</td></tr>
		</table>

		<div class="control">
			<div class="url">
				<%--<div class="data ellipsis">${baseFrontUrl}/product/codiynavi?code=${product.code}</div>--%>
				<input readonly type="text" class="data copyBtn" value="${baseFrontUrl}/main?viewId=${product.id}"/>
				<div class="text copyBtn">URL 복사</div>
			</div>
			<div class="html">
				<input readonly type="text" class="data copyBtn"/>
				<div class="text copyBtn">HTML 복사</div>
			</div>
		</div>

		<div style="overflow:hidden;width:436px;">

			<c:set var="totalCnt" value="0"/>
			<c:set var="maxCnt" value="5"/>

			<c:forEach items="${points}" var="point" varStatus="status">
				<c:set var="pointItemCss" value="width:auto !important;float:left;" />
				<c:if test="${!status.first}">
					<c:set var="pointItemCss" value="${pointItemCss}margin-left:6px;" />
				</c:if>
				<c:if test="${totalCnt < maxCnt}">
					<table cellspacing="0" cellpadding="0" style="${pointItemCss}">
						<tr>
							<td colspan="${fn:length(point.items)}" bgcolor="#aeaeae" style="font-size:13px;color:#fff">&nbsp;&nbsp;${fn:toUpperCase(point.name)}</td>
						</tr>
						<tr>
							<c:forEach items="${point.items}" var="item" varStatus="status2">
								<c:if test="${totalCnt < maxCnt}">
									<td width="70">
										<c:set var="thumbCss" value="width: 70px !important;max-width: 70px !important;" />
										<c:if test="${!status2.first}">
											<c:set var="thumbCss" value="${thumbCss}margin-left:3px;" />
										</c:if>
										<table class="thumb" cellspacing="0" cellpadding="0" width="70" style="${thumbCss}">
											<tr><td width="70"><div style="width:70px;height:94px;overflow:hidden;"><a href="productUrl" target="_blank"><img width="70" src="${baseUrl}/resources/uploads${item.thumbUrl}"/></a></div></td></tr>
											<tr><td align="center" width="70" style="font-size:14px;text-overflow: ellipsis;-o-text-overflow: ellipsis;overflow: hidden;white-space: nowrap;word-wrap: normal !important;display: block;">${item.title}${totalCnt}</td></tr>
											<tr><td align="center" width="70" style="font-size:14px;"><strong><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" /></strong></td></tr>
										</table>
									</td>
								</c:if>
								<c:set var="totalCnt" value="${totalCnt+1}"/>
							</c:forEach>
						</tr>
					</table>
				</c:if>
			</c:forEach>

			<a class="more" href="productUrl" target="_blank" style="display:inline-block;width:45px;height:141px;margin-left:8px;background: #c0392b url(${baseUrl}/resources/images/codiynavi-plus.png) 50% 50% no-repeat;"></a>

		</div>

	</div>

</div>
<!--body wrapper end-->

</body>
</html>
