<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<html>
<head>
<title>Home</title>

	<link rel="stylesheet" type="text/css" href="${slickLabHome}/js/bootstrap-colorpicker/css/colorpicker.css"/>
	<script type="text/javascript" src="${slickLabHome}/js/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>

<style>
	.categories {display: -webkit-flex;display: flex;}
	.categories > div,
	.normal-wrap,
	.color-wrap{border:1px solid #e8e8e8;border-radius:3px;-webkit-flex: 1;flex: 1;margin-right:10px;padding: 10px;}
	.categories hr {margin:0 0 5px 0;}
	.items{height:300px;overflow-y:scroll;padding-right:5px;}
	.categories .item,
	.properties .item{position:relative;margin-top:5px;border-radius: 3px;cursor:pointer;}
	.categories .item.active,
	.properties .item.active{background-color:#7cd8a9;}
	/*.categories .item:hover{background-color:#e8e8e8;}*/
	.categories .item .text,
	.properties .item .text{width:100px;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal}
	.categories .item a,
	.properties .item a{margin-right:5px;}
	.categories .item .arrow,
	.properties .item .arrow{position:absolute;top:0;right:0;}
	.ellipsis {
		text-overflow: ellipsis;
		-o-text-overflow: ellipsis;
		overflow: hidden;
		white-space: nowrap;
		word-wrap: normal !important;
		display: block;
	}
	.form {position:relative}
	.form form input {padding-right:33%;}
	.form form .save-btn{position:absolute;top:0;right:0}
	.form form .remove-btn{position:absolute;top:0;right:52px;}
	.form form .modify-btn{position:absolute;top:0;right:104px;}
	.category-head {position:relative;}
	.orderSaveBtn {position:absolute;top:-5px;right:0}

	.properties {display: -webkit-flex;display: flex;}
	.properties hr {margin:0 0 5px 0;}
	.properties .details{-webkit-flex: 3;flex: 3;}
	.properties .normals{-webkit-flex: 2;flex: 2;}
	.properties .colors{-webkit-flex: 1;flex: 1;}

	.detail-wrap, .normal-wrap {display: -webkit-flex;display: flex;}
	.detail-wrap .detail,
	.normal-wrap, .normal{border:1px solid #e8e8e8;border-radius:3px;-webkit-flex: 1;flex: 1;margin-right:10px;padding: 10px;}
	.color-item{width:20px;height:20px;float:left;margin:0 5px 5px 0;}
	form .color-item{position:absolute;top:6px;left:6px;}
	.colors .items{height:310px;}
	.color-wrap{padding-bottom:20px;}
	.colors .form input[name='name'] {padding-left:35px;}
	.colors .items .color-item{cursor:pointer;}
	.colors .items .color-item.active{
		-webkit-box-shadow: 2px 2px 5px 1px rgba(0,0,0,0.5);
		-moz-box-shadow: 2px 2px 5px 1px rgba(0,0,0,0.5);
		box-shadow: 2px 2px 5px 1px rgba(0,0,0,0.5);
	}
</style>

<script type="text/javascript">

	// 메뉴 활성 [1뎁스, 2뎁스] : 1부터 카운트
	var activeMenus = [4];

	var categoryConfig = {
		maxDepth : 3
	};

	window.isAutoLoader = false;

	$(document).ready(function(){

		$(".remove-btn, .modify-btn").addClass("disabled");

		$("#colorpicker1").colorpicker();
		$("#colorpicker1").on('hide', function(){
			console.log('change', $(this).val());
			$("#colorpicker1").attr("value", $(this).val() );
			$("#colorpicker1").parent().find(".color-item").css("background-color", $(this).val());
		});

		getCategories(1);
		getProperties(1, "DETAIL");
		getProperties(1, "NORMAL");
		getProperties(1, "COLOR");

		$(window).resize(function(){
			$(".categories .item .text").width( $(".categories > div").width() - 60 );
			$(".details .item .text").width( $(".detail").width() - 60 );
		}).resize();

		// 카테고리 추가
		$(".categorySaveBtn").click(function(){
			var frm = $(this).parents("form");
			var category = $(this).parents(".category");
			var depth = category.data("depth");

			if( depth != 1 ){
				var parentItem = $(".category[data-depth='" + (depth-1) + "']").find(".item.active");
				if( parentItem.length == 0 ){
					alert("상위 카테고리를 선택해주세요.");
					return false;
				}
				frm.find("input[name='parentId']").val( parentItem.data("id") );
			}
			if( frm.find("input[name='name']").val() == "" ){
				alert("카테고리명은 필수 항목입니다.");
				frm.find("input[name='name']").focus();
				return false;
			}

			frm.find("input[name='idx']").val( $(this).parents(".category").find(".item").length + 1 );

			//Loader.show();
			$(this).parents("form").ajaxSubmit(function(res){
				if( res.result ){
					alert("저장이 완료 되었습니다.");
					frm.find("input[name='name']").val("");
					getCategories(frm.find("input[name='depth']").val(), frm.find("input[name='parentId']").val());

				} else {
					if( res.message == "exist" ) {
						alert("중복되는 카테고리명입니다.");
						frm.find("input[name='name']").select();
					}
					else {
						alert("저장이 실패하였습니다.");
					}
				}
				//Loader.hide();
			});
		});

		// 카테고리 선택
		$(document).on('click', '.category .item', function(){
			var data = $(this).data();
			$(".categories form").eq(data.depth).find("input[name='parentId']").val(data.id);
			$(this).parent().find(".item").removeClass("active");
			$(this).addClass("active");
			console.log("선택", data);
			getCategories(data.depth+1, data.id);

			$(this).parents(".category").find(".remove-btn, .modify-btn").removeClass("disabled");
		});

		// 카테고리 삭제
		$(".category .remove-btn").click(function(){
			if( !confirm("정말 삭제하시겠습니까?") ) return;
			var selectItem = $(this).parents(".category").find(".item.active");
			var data = selectItem.data();
			$.post("category/remove", data, function(res){
				if( res.result ){
					alert("카테고리 삭제가 완료 되었습니다.");
					selectItem.remove();
				} else {
					if( res.message == "subItem" ){
						alert("하위 카테고리가 존재하는 경우 삭제 할 수 없습니다.");
					} else {
						alert("카테고리 삭제가 실패 하였습니다.");
					}
				}
			});
		});

		// 카테고리 수정
		$(".category .modify-btn").click(function(){
			var selectItem = $(this).parents(".category").find(".item.active");
			var data = selectItem.data();
			var name = $(this).parents(".category").find("input[name='name']").val();
			data.name = name;
			$.post("category/update", data, function(res){
				if( res.result ){
					alert("카테고리 수정이 완료 되었습니다.");
					selectItem.text( name );
				} else {
					alert("카테고리 수정이 실패 하였습니다.");
				}
			});
		});

		// 정렬 변경
		$(document).on('click', '.fa-caret-up, .fa-caret-down', function(){
			var item = $(this).parents(".item");
			var data = item.data();

			if( $(this).hasClass("fa-caret-up") ){
				data.order = "up";
				item.prev().before(item);
			}
			if( $(this).hasClass("fa-caret-down") ){
				data.order = "down";
				item.next().after(item);
			}
			return false;
		});

		// 정렬 저장
		$(".orderSaveBtn").click(function(){
			var items = $(this).parents(".category").find(".item");
			var list = [];
			$(items).each(function(idx){
				var category = $(this).data();
				category.idx = idx + 1;
				list.push(category);
			});

			if( list.length == 0 ){
				alert("저장될 항목이 없습니다.");
				return false;
			}

			var search = { list : list };

			//Loader.show();
			$.ajax({
				url: "category/saveIndex",
				data: JSON.stringify(search),
				type: "POST",
				dataType:"json",
				contentType:'application/json',
				success: function(res){
					console.dir(res.data);
					if( res.result ){
						alert("저장이 완료 되었습니다.");

					} else {
						alert("저장이 실패 하였습니다.");
					}
					getCategories(list[0].depth, list[0].parentid);
				},
				error: function(){
					alert("저장이 실패 하였습니다.");
					//Loader.hide();
				}
			});

		});



		// 속성 저장
		$(".propertySaveBtn").click(function(){
			var frm = $(this).parents("form");
			var type = frm.find("input[name='type']").val();
			var category = $(this).parents("." + type.toLowerCase());
			var depth = category.data("depth");

			var typeName = "";
			if( type == "DETAIL" ) typeName = "세부 특성명";
			if( type == "NORMAL"
			) typeName = "일반 특성명";
			if( type == "COLOR" ) typeName = "색상";

			if( depth != 1 && type != "COLOR" ){
				var parentItem = $("." + type.toLowerCase() + "[data-depth='" + (depth-1) + "']").find(".item.active");
				if( parentItem.length == 0 ){
					alert("상위 카테고리를 선택해주세요.");
					return false;
				}
				frm.find("input[name='parentId']").val( parentItem.data("id") );
			}
			if( frm.find("input[name='name']").val() == "" ){
				alert(typeName + "은 필수 항목입니다.");
				frm.find("input[name='name']").focus();
				return false;
			}

			//frm.find("input[name='idx']").val( $(this).parents(".category").find(".item").length + 1 );

			//Loader.show();
			$(this).parents("form").ajaxSubmit(function(res){
				if( res.result ){
					alert("저장이 완료 되었습니다.");
					frm.find("input[name='name']").val("");
					getProperties(frm.find("input[name='depth']").val(), type, frm.find("input[name='parentId']").val());

				} else {
					if( res.message == "exist" ) {
						alert("중복되는 " + typeName + " 입니다.");
						frm.find("input[name='name']").select();
					}
					else {
						alert("저장이 실패하였습니다.");
					}
				}
				//Loader.hide();
			});
		});

		// 속성 선택
		$(document).on('click', '.detail .item, .normal .item', function(){
			var data = $(this).data();
			var type = "";
			if( $(this).parents(".detail").length > 0 ){
				type = "detail";
			}
			if( $(this).parents(".normal").length > 0 ){
				type = "normal";
			}
			$("." + type + " form").eq(data.depth).find("input[name='parentId']").val(data.id);
			$(this).parent().find(".item").removeClass("active");
			$(this).addClass("active");
			console.log("선택", data);
			getProperties(data.depth+1, type, data.id);

			$(this).parent().parent().parent().find(".remove-btn, .modify-btn").removeClass("disabled");
		});

		// 특성 삭제
		$(".detail .remove-btn, .normal .remove-btn").click(function(){
			if( !confirm("정말 삭제하시겠습니까?") ) return;
			var parentWrap = $(this).parent().parent().parent();
			var selectItem = parentWrap.find(".item.active");
			var data = selectItem.data();
			$.post("property/remove", {id:data.id}, function(res){
				if( res.result ){
					alert("특성 삭제가 완료 되었습니다.");
					selectItem.remove();
				} else {
					if( res.message == "subItem" ){
						alert("하위 특성이 존재하는 경우 삭제 할 수 없습니다.");
					} else {
						alert("특성 삭제가 실패 하였습니다.");
					}
				}
			});
		});

		// 특성 수정
		$(".detail .modify-btn, .normal .modify-btn").click(function(){
			var parentWrap = $(this).parent().parent().parent();
			var selectItem = parentWrap.find(".item.active");
			var data = selectItem.data();
			var name = parentWrap.find("input[name='name']").val();
			data.name = name;
			$.post("property/update", data, function(res){
				if( res.result ){
					alert("특성 수정이 완료 되었습니다.");
					selectItem.text( name );
				} else {
					alert("특성 수정이 실패 하였습니다.");
				}
			});
		});

		// 컬러 선택
		$(document).on('click', ".colors .items .color-item", function(){
			$(".colors .items .color-item").removeClass("active");
			$(this).addClass("active");
			$(this).parents(".color-wrap").find(".modify-btn, .remove-btn").removeClass("disabled");
		});

		// 컬러 삭제
		$(document).on('click', ".colors .items .color-item", function(){
			$(".colors .items .color-item").removeClass("active");
			$(this).addClass("active");
		});

		// 색상 삭제
		$(".color-wrap .remove-btn").click(function(){
			if( !confirm("정말 삭제하시겠습니까?") ) return;
			var selectItem = $(".color-item.active");
			var data = selectItem.data();
			console.log(selectItem, data);
			$.post("property/remove", data, function(res){
				if( res.result ){
					alert("색상 삭제가 완료 되었습니다.");
					selectItem.remove();
				} else {
					alert("색상 삭제가 실패 하였습니다.");

				}
			});
		});

		// 색상 수정
		$(".color-wrap .modify-btn").click(function(){
			var selectItem = $(".color-item.active");
			var data = selectItem.data();
			data.name = $(".color-wrap input[name='name']").val();
			$.post("property/update", data, function(res){
				if( res.result ){
					alert("색상 수정이 완료 되었습니다.");
					selectItem.css("background-color", data.name);
				} else {
					alert("색상 수정이 실패 하였습니다.");

				}
			});
		});

	});

	function getCategories(depth, parentId){
		//Loader.show();
		var params = { depth: depth, parentId: parentId };
		console.log("getCategories", params);
		for(var i=depth-1; i<categoryConfig.maxDepth; i++){
			console.log("카테고리 초기화 ", i);
			$(".category .items").eq(i).children().remove();
		}
		$.post("category/list", params, function(res){
			if( res.result && res.data.categories ){
				$(res.data.categories).each(function(idx, item){
					var html = "";
					html += '<div class="item" data-id="'+item.id+'" data-depth="'+item.depth+'" data-parentid="'+item.parentId+'" data-idx="'+item.idx+'">';
					html += '	<div class="text ellipsis">'+item.name+'</div>';
					html += '	<div class="arrow">';
					html += '		<a href="#"><span class="fa fa-caret-up"></span></a>';
					html += '		<a href="#"><span class="fa fa-caret-down"></span></a>';
					html += '	</div>';
					html += '</div>';
					$(".category .items").eq(depth - 1).append(html);
				});

			} else {
				alert("카테고리 데이터 조회 실패");
			}
			//Loader.hide();
		});
	}

	function getProperties(depth, type, parentId){
		//Loader.show();
		var params = { depth: depth, parentId: parentId, type: type.toUpperCase() };
		var items = $("." + type.toLowerCase() + " .items");
		console.log("getProperties", params);
		for(var i=depth-1; i<categoryConfig.maxDepth; i++){
			items.eq(i).children().remove();
		}
		$.post(baseUrl + "/property/list", params, function(res){
			if( res.result && res.data.properties ){
				$(res.data.properties).each(function(idx, item){
					var html = "";
					if( type != "COLOR" ) {
						html += '<div class="item" data-id="' + item.id + '" data-depth="' + item.depth + '" data-parentid="' + item.parentId + '" data-idx="' + item.idx + '">';
						html += '	<div class="text ellipsis">' + item.name + '</div>';
						html += '	<div class="arrow">';
//						html += '		<a href="#"><span class="fa fa-caret-up"></span></a>';
//						html += '		<a href="#"><span class="fa fa-caret-down"></span></a>';
						html += '	</div>';
						html += '</div>';
					} else {
						html += '<div class="color-item" data-id="' + item.id + '" style="background-color: ' + item.name + ';"></div>';
					}
					items.eq(depth - 1).append(html);
				});

			} else {
				alert("세부특성 데이터 조회 실패");
			}
			//Loader.hide();
		});
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
	<div class="wrapper">
	
	    <section class="panel">
			<div class="panel-body">

				<div class="categories">

					<c:forEach begin="1" end="3" varStatus="status">
					<div class="category" data-depth="${status.index}">
						<div class="category-head">
							<h5>${status.index}차 카테고리</h5>
							<a href="#" class="btn btn-info btn-xs pull-right orderSaveBtn">순서저장</a>
						</div>
						<hr/>

						<div class="items">
						</div>

						<div class="form">
							<form method="post" action="category/save">
								<input type="hidden" name="depth" value="${status.index}">
								<input type="hidden" name="parentId" value="0">
								<input type="hidden" name="idx" value="0">
								<input type="text" name="name" class="form-control" required="required" />
								<a href="#" class="btn btn-danger remove-btn">삭제</a>
								<a href="#" class="btn btn-info modify-btn">수정</a>
								<a href="#" class="btn btn-primary categorySaveBtn save-btn">저장</a>
							</form>
						</div>
					</div>
					</c:forEach>

				</div>
			</div>
		</section>

		<section class="panel">
			<div class="panel-body">

				<div class="properties">

					<div class="details">
						<div class="head">
							<h5>세부특성</h5>
							<hr/>
						</div>
						<div class="detail-wrap">
							<c:forEach begin="1" end="3" varStatus="status">
								<div class="detail" data-depth="${status.index}">
									<div class="items">
									</div>
									<div class="form">
										<form method="post" action="${baseUrl}/property/save">
											<input type="hidden" name="type" value="DETAIL">
											<input type="hidden" name="depth" value="${status.index}">
											<input type="hidden" name="parentId" value="0">
											<input type="hidden" name="idx" value="0">
											<input type="text" name="name" class="form-control" required="required" />
											<a href="#" class="btn btn-danger remove-btn">삭제</a>
											<a href="#" class="btn btn-info modify-btn">수정</a>
											<a href="#" class="btn btn-primary propertySaveBtn save-btn">저장</a>
										</form>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>

				</div>

			</div>
		</section>

		<section class="panel">
			<div class="panel-body">

				<div class="properties">

					<div class="normals">
						<div class="head">
							<h5>일반특성</h5>
							<hr/>
						</div>
						<div class="normal-wrap">
							<c:forEach begin="1" end="2" varStatus="status">
							<div class="normal" data-depth="${status.index}">
								<div class="items">
								</div>
								<div class="form">
									<form method="post" action="${baseUrl}/property/save">
										<input type="hidden" name="type" value="NORMAL">
										<input type="hidden" name="depth" value="${status.index}">
										<input type="hidden" name="parentId" value="0">
										<input type="hidden" name="idx" value="0">
										<input type="text" name="name" class="form-control" required="required" />
										<a href="#" class="btn btn-danger remove-btn">삭제</a>
										<a href="#" class="btn btn-info modify-btn">수정</a>
										<a href="#" class="btn btn-primary propertySaveBtn save-btn">저장</a>
									</form>
								</div>
							</div>
							</c:forEach>
						</div>
					</div>

					<div class="colors">
						<div class="head">
							<h5>컬러</h5>
							<hr/>
						</div>
						<div class="color-wrap">
							<div class="color">
								<div class="items">
								</div>
							</div>
							<div class="form">
								<form method="post" action="${baseUrl}/property/save">
									<input type="hidden" name="type" value="COLOR">
									<input type="hidden" name="depth" value="1">
									<input type="text" id="colorpicker1" name="name" class="form-control" value="#fff" data-color-format="hex">
									<a href="#" class="btn btn-danger remove-btn">삭제</a>
									<a href="#" class="btn btn-info modify-btn">수정</a>
									<a href="#" class="btn btn-primary propertySaveBtn save-btn">저장</a>
									<div class="color-item" style="background-color: #fff;"></div>
								</form>
							</div>
						</div>
					</div>

				</div>

			</div>
		</section>
	
	</div>
	<!--body wrapper end-->

</body>
</html>
