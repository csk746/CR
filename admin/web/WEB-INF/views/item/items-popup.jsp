<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<c:set var="isMaker" value="${fn:contains(loginAdmin, 'ROLE_MAKER')}"/>

<html>
<head>
<title>Home</title>

<script type="text/javascript">

	// 메뉴 활성 [1뎁스, 2뎁스] : 1부터 카운트
	var activeMenus = [3];

	var categoryConfig = {
		maxDepth : 3
	};

	var maxAddCount = 6;
	if( ${isMaker} ){
		maxAddCount = 3;
	}

	window.isAutoLoader = false;

	$(document).ready(function(){
		getCategories(1);
		getProperties(1, "DETAIL");
		getProperties(1, "NORMAL", 0, function(){
			getProperties(1, "COLOR");
		});
		getItems(new ItemSearch(), function(){
			$(".items .pic img").each(function(){
				var image = $(this);
				var parent = $(this).parent();
				var newImage = new Image();
				newImage.onload = function(){
					var imageWidth = newImage.width;
					var imageHeight = newImage.height;
					var resizeResult = resizeImage(parent.width(), parent.height(), imageWidth, imageHeight);
					$(image).css( resizeResult );
					image.attr("src", $(this).attr("src"));
				};
				if( $(this).data("src") )
					newImage.src = $(this).data("src");
				else
					newImage.src = $(this).attr("src");
			});
		});

		// 카테고리 선택
		$(document).on('click', '.category option', function(){
			var data = {
				depth: $(this).parent().data("depth")
				, id: $(this).val()
			}
			getCategories(data.depth+1, data.id);
			itemFilterSearch();
		});

		// 속성 선택
		$(document).on('click', '.property option', function(){
			var data = {
				type: ''
				, depth: $(this).parent().data("depth")
				, id: $(this).val()
			};

			var property = $(this).parents(".property");

			if( property.hasClass("detail") ){
				data.type = "detail";
			}
			if( property.hasClass("normal") ){
				data.type = "normal";
			}

			if( property.hasClass("detail") ) {
				getProperties(data.depth + 1, data.type.toUpperCase(), data.id);
			}
			itemFilterSearch();
		});

		// 전체 선택
		$("#allCheckBtn").click(function(){
			$(".item input[type='checkbox']").prop("checked", true);
		});

		// 삭제 버튼
		$("#removeBtn").click(function(){
			var selectedList = $(".item input[type='checkbox']:checked");
			if( selectedList.length == 0 ){
				alert("선택된 항목이 없습니다.");
				return;
			}

			var search = { ids : $(".item input[type='checkbox']:checked").map(function(){ return this.value; }).toArray() };

			$.ajax({
				url: baseUrl + "/item/remove",
				data: JSON.stringify(search),
				type: "POST",
				dataType:"json",
				contentType:'application/json',
				success: function(res){
					if( res.result ){
						alert("삭제가 완료 되었습니다.");
						location.reload();
					} else {
						alert("삭제가 실패 하였습니다.");
					}
				},
				error: function(){
					alert("삭제가 실패 하였습니다.");
				}
			});
		});

		// 사진 선택
		$(document).on('click', ".item .pic", function(){
			var itemGroup = opener.$(".itemAddBtn.on").parents(".item-group");
			if( $(".selected-items").children().length + itemGroup.find(".item").length >= maxAddCount ){
				alert("아이템은 최대 6개 까지 가능합니다.");
				return;
			}

			var selectId = $(this).parents(".item").find(".item-chk").val();
			if( itemGroup.find(".item .item-chk[value='" + selectId + "']").length > 0
					|| $(".selected-items .item-chk[value='" + selectId + "']").length > 0
			){
				alert("이미 선택된 아이템입니다.");
				return;
			}

			var copyItem = $(this).parents(".item").clone();
			copyItem.find(".item-remove-btn").show();
			$(".selected-items").append( copyItem );
		});

		// 추가
		$("#addBtn").click(function(){
			var itemGroup = opener.$(".itemAddBtn.on").parents(".item-group");
			if( $(".selected-items").children().length + itemGroup.find(".item").length >= (maxAddCount+1) ){
				alert("아이템은 최대 6개 까지 가능합니다.");
				return;
			}

			$(".selected-items .item").each(function(idx, item){
				itemGroup.find(".items").prepend(item);
				$(item).find("input[type='checkbox']").show();
			});

			self.close();
		});

		// 선택 삭제
		$(document).on("click", ".item-remove-btn", function(){
			$(this).parents(".item").remove();
			return false;
		});
	});

	// 컬러 선택 처리
	colorSelectFunc = function(){
		itemFilterSearch();
	}
	
</script>

<script src="${baseUrl}/resources/scripts/item-category.js"></script>

</head>
<body>
	<!--body wrapper start-->
	<div class="wrapper page-items">

		<section class="isolate-tabs">
			<ul class="nav nav-tabs">
				<li class="active">
					<a data-toggle="tab" href="#finderTab">파인더 모드</a>
				</li>
				<li class="">
					<a data-toggle="tab" href="#registTab">등록모드</a>
				</li>
			</ul>
			<div class="panel-body">
				<div class="tab-content">

					<div id="finderTab" class="tab-pane active">

						<section class="panel">
							<div class="category-body">

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

						<hr/>

						<section class="panel">
							<div class="items-body">

								<div class="items" style="max-height:570px;overflow-y:auto;">
								</div>

								<hr style="border-top:1px solid #a95050"/>

								<div class="item-buttons" style="clear:both">
									<div class="pull-right">
										<a href="#" onclick="self.close();" class="btn btn-default">취소</a>
										<a href="#" id="addBtn" class="btn btn-primary">추가</a>
									</div>
									<br/><br/>
								</div>

								<div class="selected-items">

								</div>

							</div>
						</section>

					</div>
					<div id="registTab" class="tab-pane">
						<iframe width="100%" height="620" frameborder="0" src="<spring:url value="/item/form/iframe"/>" scrolling="yes"></iframe>
					</div>

				</div>
			</div>


		</section>

	</div>
	<!--body wrapper end-->


	<style>
		.item-remove-btn{position:absolute;right:5px;top:5px;color:red;display:none;}
	</style>
	<div class="template">

		<div class="item">
			<input class="item-chk" type="checkbox" style="display: none;" />
			<a href="#" class="item-remove-btn"><i class="icon-close"></i></a>
			<span class="badge bg-inverse">3</span>
			<a href="#" onclick="return false;">
				<div class="pic">
				</div>
			</a>
			<div class="info">
				<p class="text1">에잇세컨즈</p>
				<p class="text2">니코 7부 리얼데님 8oz</p>
				<p class="text3">84,000</p>
			</div>
		</div>

	</div>

</body>
</html>
