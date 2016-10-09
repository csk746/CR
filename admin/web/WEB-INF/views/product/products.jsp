<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<html>
<head>
<title>Home</title>

<script type="text/javascript">

	// 메뉴 활성 [1뎁스, 2뎁스] : 1부터 카운트
	var activeMenus = [1];

	$(document).ready(function(){

		// 전체 선택
		$("#allCheckBtn").click(function(){
			$(".item input[type='checkbox']").prop("checked", true);
		});

		// 사진 선택
		$(document).on('click', ".item .pic", function(){
			location.href = "<spring:url value="/product/form" />/" + $(this).parents(".item").data("id");
		});

		// 삭제 버튼
		$("#removeBtn").click(function(){
			var selectedList = $(".item input[type='checkbox']:checked");
			if( selectedList.length == 0 ){
				alert("선택된 항목이 없습니다.");
				return;
			}

			if( !confirm("정말 삭제하시겠습니까?") ) return false;

			var search = { ids : $(".item input[type='checkbox']:checked").map(function(){ return this.value; }).toArray() };

			$.ajax({
				url: baseUrl + "/product/remove",
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
			newImage.src = $(this).data("src");
		});

//            $(".items .pic img").fill();
	});

	function resizeImage(destWidth, destHeight, imgWidth, imgHeight){
		var resizeResult = {width:0,height:0,left:0,top:0};

		console.log("기준 정보", destWidth, destHeight);

		var imgRatio = (imgWidth > imgHeight) ? getRatio(imgWidth, imgHeight) : getRatio(imgHeight, imgWidth);

		console.log("이미지 정보", imgWidth, imgHeight);
		console.log("이미지 비율", imgRatio);

		if( imgWidth >= destWidth && imgHeight >= destHeight ){
			console.log("* 이미지가 컨테이너보다 가로 세로 클때");

			// 가로형
			if( imgWidth > imgHeight ) {
				console.log("\t- 가로형");
				resizeResult.width = parseInt(destHeight * imgRatio);
				resizeResult.height = destHeight;

				resizeResult.left = -(resizeResult.width/2 - (destWidth/2));
			}

			// 세로형
			else {
				console.log("\t- 세로형");
				resizeResult.width = destWidth;
				resizeResult.height = parseInt(destWidth * imgRatio);

				// 큰 세로형일때는 상단에 맞춘다.
//                    resizeResult.top = -(resizeResult.height/2 - (destHeight/2));
			}

		} else {
			console.log("* 이미지가 컨테이너보다 가로 또는 세로 작을때");

			// 가로형
			if( imgWidth > imgHeight ) {
				console.log("\t- 가로형");
				resizeResult.width = parseInt(imgHeight * imgRatio);
				resizeResult.height = imgHeight;

			}

			// 세로형
			else {
				console.log("\t- 세로형");
				resizeResult.width = imgWidth;
				resizeResult.height = parseInt(imgWidth * imgRatio);

			}

		}

		// 영역이 벗어나면 정렬
		if( resizeResult.width < destWidth ){
			resizeResult.left = -(resizeResult.width/2 - (destWidth/2));
		}
		if( resizeResult.height < destHeight ){
			resizeResult.top = -(resizeResult.height/2 - (destHeight/2));
		}
		return resizeResult;

	}

	function getRatio(width, height){
		return (Math.round((width/height)*100)/100)
	}
	
</script>

</head>
<body>

	<!-- page head start-->
	<div class="page-head">
	    <h3></h3>
	    <span class="sub-title"></span>
	</div>
	<!-- page head end-->
	
	<!--body wrapper start-->
	<div class="wrapper page-products">
	
	    <section class="panel">
			<div class="panel-heading">
				<div class="item-buttons">
					<a href="#" id="allCheckBtn" class="btn btn-info">전체선택</a>
					&nbsp;
					<a href="#" id="removeBtn" class="btn btn-danger">삭제</a>
					<a href="form" class="btn btn-primary pull-right">업로드</a>
					<br/>
				</div>
			</div>
			<div class="panel-body">

				<div class="items">

					<c:set var="createDate"/>
					<c:forEach items="${products}" var="product" varStatus="status">
						<fmt:formatDate value="${product.createDatetime}" var="productCreateDate" pattern="yyyyMMdd"/>
						<c:if test="${empty createDate or createDate != productCreateDate}">
							<c:set var="createDate" value="${productCreateDate}"/>
							<!-- date group -->
							<h4 style="clear: both;padding-top:30px;">
								<fmt:formatDate value="${product.createDatetime}" pattern="yyyy. MM. dd"/>
							</h4>
							<hr/>
							<!-- //date group -->
						</c:if>

						<!-- item -->
						<a href="<spring:url value="/product/form/${product.id}"/>">
							<div class="item" data-id="${product.id}">
								<input type="checkbox" value="${product.id}" />

								<spring:url var="image" value="/resources/uploads${product.mainImage.filePath}/${product.mainImage.fileName}"/>
								<div class="pic">
									<img data-src="${image}" src="${baseUrl}/resources/images/blank.gif"/>
								</div>

								<div class="info">
									<div class="text1 ellipsis">${product.title} </div>
									<div class="text2">
										<div class="pull-left">
											<i class="fa fa-user"></i>
											<span>${product.memberNickName}</span>
										</div>
										<div class="pull-right">
											<i class="fa fa-eye"></i>
											<span>${product.viewCount}</span>
										</div>
									</div>
								</div>
							</div>
						</a>
						<!-- //item -->
					</c:forEach>

				</div>

			</div>
		</section>
	
	</div>
	<!--body wrapper end-->

</body>
</html>
