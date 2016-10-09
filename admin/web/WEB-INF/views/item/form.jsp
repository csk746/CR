<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<html>
<head>
	<title>Home</title>

	<script src="${baseUrl}/resources/scripts/libs/html2canvas.js" type="text/javascript"></script>

	<script type="text/javascript">

		// 메뉴 활성 [1뎁스, 2뎁스] : 1부터 카운트
		var activeMenus = [3];

		var categoryConfig = {
			maxDepth : 3
		};

		window.isAutoLoader = false;

		$(document).ready(function(){
			getCategories(1);
			getProperties(1, "DETAIL");
			getProperties(1, "NORMAL", 0, function(){
				getProperties(1, "COLOR");
			});

			// 카테고리 선택
			$(document).on('click', '.category option', function(){
				var data = {
					depth: $(this).parent().data("depth")
					, id: $(this).val()
				}
				getCategories(data.depth+1, data.id);
			});

			// 속성 선택
			$(document).on('click', '.property option', function(){
				var data = {
					type: ''
					, depth: $(this).parent().data("depth")
					, id: $(this).val()
				};

				var property = $(this).parents(".property");

				if( !property.hasClass("detail") ) return;

				if( property.hasClass("detail") ){
					data.type = "detail";
				}
				if( property.hasClass("normal") ){
					data.type = "normal";
				}

				getProperties(data.depth+1, data.type.toUpperCase(), data.id);
			});

			// 저장
			$("#saveBtn").click(function(){

				var categoryIds = getSelectedCategory();
				var propertyIds1 = getSelectedProperty('detail');
				var propertyIds3 = getSelectedProperty('color');

				if( categoryIds.length == 0 ){
					alert("카테고리는 필수 항목입니다.");
					return false;
				}

				if( !ValidateUtil.requiredCheck("#frm") ) return false;

				$("#category").val(addDelimiter(categoryIds.toString(), ","));
				$("#detailProperty").val(addDelimiter(propertyIds1.toString(), ","));
				$("#colorProperty").val(addDelimiter(propertyIds3.toString(), ","));

				var propertyIds2 = getSelectedProperty('normal');
				var normalProp = "";
				for(var i=0; i<propertyIds2.length; i+=2){
					normalProp += propertyIds2[i] + "," + propertyIds2[i+1] + "|";
				}
				$("#normalProperty").val(addDelimiter(normalProp, "|"));

				$("#frm").ajaxSubmit(function(res){

					console.log(res);

					if( !res.data.uploadResult ){
						if( res.result ) {
							alert("등록이 완료 되었습니다.");
							location.href = "<spring:url value="/item/items"/>";
						} else {
							alert("등록이 실패 하였습니다.");
						}
						return;
					}

					$("#captureCanvas").find(".thumbImg").remove();
					var img = $("<img class='thumbImg'/>");
					img.attr("src", "/resources/uploads" + res.data.item.thumbSUrl);
					$("#captureCanvas").prepend(img);

					if( res.result ){
						$("#captureField").show();
						html2canvas($("#captureCanvas"), {
							onrendered: function (canvas) {
								$("body").append(canvas);

								var xhr = new XMLHttpRequest();
								xhr.open("post", "<spring:url value="/item/saveImage/"/>" + res.data.item.id, false);
								var boundary = Math.random().toString().substr(2);
								xhr.setRequestHeader("content-type",
										"multipart/form-data; charset=utf-8; boundary=" + boundary);
								var multipart = "--" + boundary + "\r\n" +
										"Content-Disposition: form-data; name=myImg\r\n" +
										"Content-type: image/png\r\n\r\n" +
										canvas.toDataURL("image/png") + "\r\n" +
										"--" + boundary + "--\r\n";
								xhr.onreadystatechange = function() {
									var res = null;
									if (xhr.readyState == XMLHttpRequest.DONE) {
										res = JSON.parse(xhr.responseText);
										if( res.result ){
											alert("등록이 완료 되었습니다.");

											<c:if test="${layoutType == 'iframe'}">
											parent.location.reload();
											return;
											</c:if>

											location.href = "<spring:url value="/item/items"/>";

										} else {
											alert("[1] 이미지 저장이 실패 하였습니다.");
										}

									}
									setTimeout(function(){
										callback(null, res.data);
									}, 500);

								}
								xhr.send(multipart);

							}
						});

					} else {
						alert("등록이 실패 하였습니다.");
					}
				});
			});

			setFormData();

			<c:if test="${layoutType == 'iframe'}">
			setTimeout(function(){
				parent.$("iframe").height(1200);
				$(".body-content").css("min-height", "auto");
			}, 500);
			</c:if>

			$("#captureField").hide();
		});

		function setFormData() {
			var loadSelectedData = {
				category : {
					count : 0
					, data : $.map($("#category").val().split(","), function(val){ if(val != "") return val; })
					, items : $(".category select")
				}
				, detail : {
					count : 0
					, data : $.map($("#detailProperty").val().split(","), function(val){ if(val != "") return val; })
					, items : $(".property.detail select")
				}
				, normal : {
					count : 0
					, data : $.map($("#normalProperty").val().split(","), function(val){ if(val != "") return val; })
//					, items : $(".property.normal")
				}
				, color : {
					data : $("#colorProperty").val().split(",")
				}
			};

			// 카테고리 선택 데이터 처리
			$(document).on(ItemEvent.LOAD_COMPLATE, function (event, args) {
				console.log(args);

				if( args.type == "CATEGORY" ) {
					console.log("CATEGORY", loadSelectedData.category);
					var selectedData = loadSelectedData.category;
					if (selectedData.data.length != selectedData.count) {
						selectedData.items.eq(selectedData.count).val(selectedData.data[selectedData.count]);
						selectedData.items.eq(selectedData.count).find("option[value='" + selectedData.data[selectedData.count] + "']").click();
						selectedData.count += 1;
					}
				}

				if( args.type == "DETAIL" ) {
					var selectedData = loadSelectedData.detail;
					if (selectedData.data.length != selectedData.count) {
						selectedData.items.eq(selectedData.count).val(selectedData.data[selectedData.count]);
						selectedData.items.eq(selectedData.count).find("option[value='" + selectedData.data[selectedData.count] + "']").click();
						selectedData.count += 1;
					}
				}

				if( args.type == "NORMAL" ) {
					var selectedData = loadSelectedData.normal;
					if (selectedData.data.length != selectedData.count) {
						var subData = selectedData.data[selectedData.count].split(",");
						var targetSelect = $(".property.normal select[data-parent='" + subData[0] + "']");

						console.log(subData, targetSelect);

						targetSelect.val( subData[1] );
						targetSelect.find("option[value='" + subData[1] + "']").click();
						selectedData.count += 1;
					}
				}

				if( args.type == "COLOR" ) {
					var selectedData = loadSelectedData.color;
					$(selectedData.data).each(function(idx, colorId){
						$(".property.color .color-item").filter("[data-id=" + colorId + "]").click();
					});
				}
			});

			if( $("#id").val() > 0 ){
				$("#uploadFile").removeAttr("required");
			}
		}

		/**
		 * image to data url
		 */
		function getBase64Image(img) {
			// Create an empty canvas element
			var canvas = document.createElement("canvas");
			canvas.width = img.width;
			canvas.height = img.height;

			// Copy the image contents to the canvas
			var ctx = canvas.getContext("2d");
			ctx.drawImage(img, 0, 0);

			// Get the data-URL formatted image
			// Firefox supports PNG and JPEG. You could check img.src to guess the
			// original format, but be aware the using "image/jpg" will re-encode the image.
			var dataURL = canvas.toDataURL("image/png");

			return dataURL;
		}

	</script>
	<script src="${baseUrl}/resources/scripts/item-category.js"></script>

</head>
<body>

<c:if test="${layoutType != 'iframe'}">
<!-- page head start-->
<div class="page-head">
	<h3></h3>
	<span class="sub-title"></span>
</div>
<!-- page head end-->
</c:if>

<!--body wrapper start-->
<div class="wrapper page-itemform">
	<section class="panel">
		<div class="panel-heading">
			<h4>아이템 등록</h4>
		</div>
		<div class="panel-body">
			<a href="#" id="itemFilterResetBtn" class="btn btn-warning btn-xs">선택 초기화</a>

			<div class="categories">
				<c:forEach begin="1" end="3" varStatus="status">
					<div class="category">
						<h5 class="category-title">${status.index}차 카테고리</h5>
						<select data-depth="${status.index}" class="form-control" size="7">
						</select>
					</div>
				</c:forEach>
				<c:forEach begin="1" end="3" varStatus="status">
					<div class="property detail">
						<c:if test="${status.first}"><h5 class='category-title'>세부특성</h5>	</c:if>
						<c:if test="${!status.first}"><h5 class='category-title noline'>&nbsp;</h5></c:if>
						<select data-depth="${status.index}" class="form-control" size="7">
						</select>
					</div>
				</c:forEach>
			</div>

		</div>
	</section>

	<section class="panel">
		<div class="panel-body">

			<spring:url value="/item/save" var="saveUrl"/>
			<form:form id="frm" commandName="item" method="post" action="${saveUrl}" role="form" enctype="multipart/form-data">
				<form:hidden path="id"/>
				<form:hidden path="category"/>
				<form:hidden path="colorProperty"/>
				<form:hidden path="detailProperty"/>
				<form:hidden path="normalProperty"/>

				<c:if test="${not empty item.thumbName}">
					<div class="form-group">
						<label for="uploadFile">현재 썸네일</label>
						<div>
							<img src="<spring:url value="/resources/uploads${item.thumbUrl}"/>" />
						</div>
					</div>
					<hr/>
				</c:if>

				<div class="form-group">
					<label for="uploadFile">썸네일</label>
					<input id="uploadFile" type="file" class="file" name="uploadFile" required="required"/>
				</div>

				<div id="captureField" class="form-group">
					<label for="link">코디나비용 썸네일</label>
					<div id="captureCanvas" style="position:relative;width:77px;height:77px;overflow:hidden;">
						<img id="itemBg" src="${baseUrl}/resources/images/bg-item.png" style="position:absolute;top:0;left:0;z-index:2;"/>
					</div>
				</div>

				<div class="form-group">
					<label for="title">샵이름 또는 브랜드</label>
					<form:input path="title" class="form-control" required="required"/>
				</div>

				<div class="form-group">
					<label for="name">상품 이름</label>
					<form:input path="name" class="form-control" required="required"/>
				</div>

				<div class="form-group">
					<label for="price">가격</label>
					<form:input path="price" class="form-control" required="required"/>
				</div>

				<div class="form-group">
					<label for="link">링크</label>
					<form:input path="link" class="form-control" />
				</div>

				<a class="btn btn-primary" id="saveBtn">저장</a>

			</form:form>

		</div>
	</section>

</div>
<!--body wrapper end-->

</body>
</html>
