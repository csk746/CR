<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />
<fmt:setLocale value="ko"/>

<html>
<head>
	<title>Home</title>
	<style>
		.codiynavi .control {position:absolute;top:0;left:680px;width:200px;border:2px solid #e0e0e0;font-size:14px;padding:50px 10px;}

		.codiynavi .control .url,
		.codiynavi .control .html{border:1px solid #b3b3b3;width:200px;}

		.codiynavi .control .html{margin-top:20px;width:200px;}
		.codiynavi .control .html .data{width:92%;padding:10px 4%;border:0;}
		.codiynavi .control input {width:92%;padding:10px 4%;border:0;}

		.codiynavi .control .text,
		.codiynavi .control .data{text-align:center;height:20px;font-size:12px;}

		.codiynavi .control .text{font-weight:bold;background-color:#e4e4e4;cursor:pointer;padding:10px;}
		.codiynavi .control .text{border-top:1px solid #b3b3b3;}

		.codiynavi .control .text.endBtn {width:180px;border:1px solid #b3b3b3;margin-top:20px;margin-bottom:20px;}

		.codiynavi .control-thumb{display:inline-block;width:140px;}

		.upload-thumbs{position:absolute;width:140px;margin-right:20px;text-align:center;overflow:hidden;min-height:848px;top:0}
		.edit-panel{position:absolute;left:155px;top:53px;right:0;width:530px;height:848px;}
		.upload-thumb.on{border:2px solid #f02828;}
		.upload-thumb{display:inline-block;height:212px;overflow:hidden;position:relative;cursor:pointer;}
		.upload-thumb+a{margin-top:10px;}
		.upload-thumb .remove-thumb{position:absolute;top:5px;right:5px;text-decoration:none;}
		.upload-thumb .remove-thumb i{color:red;font-weight:bold;width:20px;height:20px;}
		.upload-thumbs .thumb-page+div{display:none;}
		#thumbPageUpBtn{display:inline-block;margin:10px 0 10px 0;}
		#thumbPageDownBtn{display:inline-block;margin:10px 0 10px 0;position:absolute;bottom:0;right:50px}

	</style>
	<link rel="stylesheet" href="${baseUrl}/resources/css/admin.css">
	<script>var baseUrl = "<spring:url value="/"/>";</script>
	<script src="${baseUrl}/resources/scripts/libs/jquery.min.js"></script>
	<script src="${baseUrl}/resources/scripts/common.js"></script>
	<script src="${baseUrl}/resources/scripts/zeroclipboard/jquery.zeroclipboard.min.js"></script>
		<script type="text/javascript">

		var thumbPageNo = 0;
		var removeIds = [];

		$(document).ready(function(){
			// 링크 변경
			$("a[href='productUrl']").attr("href", "${baseFrontUrl}/main?viewId=${product.id}");

			var htmlData = $(".codiynavi").clone();
			htmlData.find(".control").remove();
			htmlData.find(".control-thumb").remove();
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

			// 배포 끝내기
			$("#endBtn").click(function(){
				if( removeIds.length == 0 ){
					alert("코디나비가 만들어졌습니다.");
					top.location.href = "<spring:url value="/product/products"/>";

				} else {
					alert("나머지 코디를 다시 배포하기 위해 에디터로 이동합니다.");
					parent.$(".upload-thumbs .upload-thumb").each(function(idx, item){
						console.log(removeIds.indexOf( parseInt($(item).data("saveid")) ));
						if( removeIds.indexOf( parseInt($(item).data("saveid")) ) == -1 ){
							parent.$(".upload-thumb[data-saveid='" + $(item).data("saveid") + "'] .remove-thumb").click();
						}
					});
					parent.$("#layer-mask, #publishLayer").fadeOut();
				}

			});

			// thumbs copy
			$(".upload-thumbs .thumbs").append(parent.$(".upload-thumbs .thumbs").children().clone());
			$(".remove-thumb i").append("x");

			$(document).on("click", ".thumbs .upload-thumb", function(){
				console.log();
			});

			// 삭제
			$(document).on("click", ".thumbs .remove-thumb", function(){
				if( !confirm("정말 삭제하시겠습니까?") ) return false;

				var target = $(this).parents(".upload-thumb");
				var search = { ids : [target.data("saveid")] };

				$.ajax({
					url: "<spring:url value="/product/remove"/>",
					data: JSON.stringify(search),
					type: "POST",
					dataType:"json",
					contentType:'application/json',
					success: function(res){
						console.log("삭제완료", res);
						target.remove();
						initThumbPage();
						removeIds.push(target.data("saveid"));
//						$("iframe").attr("src", "about:blank");
						$("iframe")[0].contentWindow.location.href = "about:blank";

						if( $(".upload-thumb").length == 0 ){
							$("#endBtn").click();
						}

					},
					error: function(){
					}
				});
			});

			// 썸네일 클릭
			$(document).on("click", ".thumbs .upload-thumb", function(){
				$(".upload-thumb").removeClass("on");
				$(this).addClass("on");
				Loader.show();
				$("body").css("overflow-y", "hidden");
				$("iframe").attr("src", "codiynavi-source?id=" + $(this).data("saveid"));
			});

			// iframe load complete
			$('iframe').on('load', function(){
				Loader.hide();
				$("body").css("overflow-y", "scroll");
			});

			// 업로드 썸네일 위 버튼
			$(document).on("click","#thumbPageUpBtn",function(){
				if( thumbPageNo != 0 ){
					thumbPageNo -= 1;
					$(".thumb-page").hide();
					$(".thumb-page").eq(thumbPageNo).show();
				} else {
					alert("첫 페이지 입니다.");
				}
			});

			// 업로드 썸네일 아래 버튼
			$(document).on("click","#thumbPageDownBtn",function(){
				if( $(".thumb-page").length-1 != thumbPageNo ){
					thumbPageNo += 1;
					$(".thumb-page").hide();
					$(".thumb-page").eq(thumbPageNo).show();
				} else {
					alert("마지막 페이지 입니다.");
				}
			});

			// 업로드 썸네일 마지막 페이지
			var goThumbLastPage = function(){
				var total = $(".upload-thumb").length;
				var lastPage = parseInt(total/3) + (total%3 > 0 ? 1 : 0);
				thumbPageNo = lastPage-1;
				$(".thumb-page").hide();
				$(".thumb-page").eq(thumbPageNo).show();
			};
			goThumbLastPage();
		});

		function removeNewlines(str) {
			str = str.replace(/\s{2,}/g, ' ');
			str = str.replace(/\t/g, ' ');
			str = str.toString().trim().replace(/(\r\n|\n|\r)/g,"");
			return str;
		}

		/**
		 * 썸네일 순서 재정렬
		 */
		function initThumbPage(){
			var thumbs = $(".upload-thumb").clone(true);
			$(".thumbs").children().remove();
			$(".thumbs").append($('<div class="thumb-page"/>'));
			$(thumbs).each(function(idx, item){
				if( idx > 0 && idx % 3 == 0 ){
					$(".thumbs").append($('<div class="thumb-page"/>'));
				}
				$(".thumb-page").last().append(item);
			});
			$(".thumb-page").hide();
			$(".thumb-page").eq(thumbPageNo).show();
		}
	</script>
</head>
<body>

<!--body wrapper start-->
<div class="wrapper">

	<div class="codiynavi" style="position:relative;font-family: 'Nanum Gothic';padding:5px;">

		<div class="control-thumb">

			<div class="upload-thumbs">
				<a href="#" id="thumbPageUpBtn"><img src="<spring:url value="/resources/images/btn-thumb-up.png"/>" /></a>

				<div class="thumbs">

				</div>

				<a href="#" id="thumbPageDownBtn"><img src="<spring:url value="/resources/images/btn-thumb-down.png"/>" /></a>
			</div>

		</div>

		<c:choose>
			<c:when test="${saveType == 'new'}">
				<iframe style="position:absolute;left:160px;top:0;" width="770" height="950" frameborder="0" src="<spring:url value="codiynavi-source?id=${product.id}"/>"></iframe>
			</c:when>
			<c:otherwise>
				<iframe width="770" height="950" frameborder="0" src="<spring:url value="codiynavi-source?id=${product.id}"/>"></iframe>
				<script>$(".control-thumb").remove();</script>
			</c:otherwise>
		</c:choose>


		<div id="endBtn" style="display:none;"></div>

	</div>

</div>
<!--body wrapper end-->

</body>
</html>
