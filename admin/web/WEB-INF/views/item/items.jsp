<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<html>
<head>
<title>Home</title>

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

		// 사진 선택
		$(document).on('click', ".item .pic", function(){
			location.href = "<spring:url value="/item/form" />/" + $(this).parents(".item").data("id");
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

	});

	// 컬러 선택 처리
	colorSelectFunc = function(){
		itemFilterSearch();
	}
	
</script>

<script src="${baseUrl}/resources/scripts/item-category.js"></script>

</head>
<body>

	<!-- page head start-->
	<div class="page-head">
	    <h3></h3>
	    <span class="sub-title"></span>
	</div>
	<!-- page head end-->
	
	<!--body wrapper start-->
	<div class="wrapper page-items">

	    <section class="panel">
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

				<div class="item-buttons">
					<a href="#" id="allCheckBtn" class="btn btn-info">전체선택</a>
					&nbsp;
					<a href="#" id="removeBtn" class="btn btn-danger">삭제</a>
					<a href="form" class="btn btn-primary pull-right">업로드</a>
					<br/><br/>
				</div>

				<div class="items">
				</div>

			</div>
		</section>
	
	</div>
	<!--body wrapper end-->


	<div class="template">

		<div class="item">
			<input type="checkbox" />
			<span class="badge bg-inverse">3</span>
			<div class="pic">
			</div>
			<div class="info">
				<p class="text1">에잇세컨즈</p>
				<p class="text2">니코 7부 리얼데님 8oz</p>
				<p class="text3">84,000</p>
			</div>
		</div>

	</div>

</body>
</html>
