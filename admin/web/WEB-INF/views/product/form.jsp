<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<spring:url var="saveUrl" value="/product/save"/>

<html>
<head>
<title>Home</title>

<!--jquery-ui-->
<script src="${baseUrl}/resources/scripts/libs/jquery.event.drag-2.2.js" type="text/javascript"></script>
<script src="${baseUrl}/resources/scripts/libs/jquery.event.drag.live-2.2.js" type="text/javascript"></script>
<script src="${baseUrl}/resources/scripts/libs/html2canvas.js" type="text/javascript"></script>
<script src="${baseUrl}/resources/scripts/libs/async.min.js" type="text/javascript"></script>

<script type="text/javascript">

	// 메뉴 활성 [1뎁스, 2뎁스] : 1부터 카운트
	var activeMenus = [1, 1];

	var uploadMinSize = { width: 320, height: 450 };

	var thumbPageNo = 0;
	var thumbCount = 0;
	var thumbId = "N0";
	var maxPointSize = 10;	// 최대 포인트 개수
	var selectThumb = null;
	var pointNameList = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];

	// 저장 후 배포를 위해
	var saveCallback = null;
	var savedProduct = {};
	var saveTaskResult = [];
	var saveTaskResults = [];

	var saveType = ("0" == "${product.id}") ? "new" : "mod";

	window.isAutoLoader = false;

	$(document).ready(function(){

		// 수정일때만 아이템 삭제 버튼
		if( $("#id").val() == 0 ){
			$(".item .item-remove-btn").hide();
		} else {
			modifyView();
		}

		// 업로드 썸네일 선택
		$(document).on("click", ".upload-thumb", function(){
			$(".upload-thumb").removeClass("on");
			$(this).addClass("on");
			selectThumb = $(this);

			var editGroup = $(".edit-group[data-id='" + $(this).data("id") + "']");
			var itemGroup = $(".item-group[data-id^='" + $(this).data("id") + "']");

			$(".edit-panel .edit-group").hide();
			$(".editor-right .item-group").hide();
			editGroup.show();
			itemGroup.show();

			// 폼 그룹 생성 또는 보이기
			console.log("폼 생성");
			var frm = $(".editor-form form[data-id='" + getActiveEditGroup().data("id") + "']");
			if( frm.length == 0 ){
				frm = $(".template form").clone();
				frm.attr("data-id", getActiveEditGroup().data("id"));
				$(".editor-form").append(frm);

				if( saveType == "mod" ){
					frm.find("input[name='title']").val( "${product.title}" );
					frm.find("textarea[name='description']").val( "${product.description}" );
				}
			}

			$(".editor-form form").hide();
			frm.show();
		});

		// 썸네일 삭제
		$(document).on("click", ".remove-thumb", function(evt){
			// 현재 선택 아이템인지
			var uploadThumb = $(this).parents(".upload-thumb");
			$(".edit-group[data-id='" + uploadThumb.data("id") + "']").remove();
			$(".item-group[data-id^='" + uploadThumb.data("id") + "']").remove();
			uploadThumb.remove();
			initThumbPage();
			evt.stopPropagation();
		});

		// 업로드 썸네일 위 버튼
		$("#thumbPageUpBtn").click(function(){
			if( thumbPageNo != 0 ){
				thumbPageNo -= 1;
				$(".thumb-page").hide();
				$(".thumb-page").eq(thumbPageNo).show();
			} else {
				alert("첫 페이지 입니다.");
			}
		});

		// 업로드 썸네일 아래 버튼
		$("#thumbPageDownBtn").click(function(){
			if( $(".thumb-page").length-1 != thumbPageNo ){
				thumbPageNo += 1;
				$(".thumb-page").hide();
				$(".thumb-page").eq(thumbPageNo).show();
			} else {
				alert("마지막 페이지 입니다.");
			}
		});

		// 업로드 썸네일 마지막 페이지
		$.goThumbLastPage = function(){
			var total = $(".upload-thumb").length;
			var lastPage = parseInt(total/3) + (total%3 > 0 ? 1 : 0);
			thumbPageNo = lastPage-1;
			$(".thumb-page").hide();
			$(".thumb-page").eq(thumbPageNo).show();
		};

		// 에디터 회전 버튼
		$(".rotate-btn").click(function(){
			var parent = $(this).parents(".point");
			var img = parent.find(".point-img");
			var imgSrc = img.attr("src");
			if( img.hasClass("rotated") ){
				img.removeClass("rotated");
				img.attr("src", imgSrc.replace("-180", ""));
			} else {
				img.addClass("rotated");
				var idx = imgSrc.lastIndexOf(".");
				imgSrc = imgSrc.substring(0, idx);
				img.attr("src", imgSrc + "-180.png");
			}

		});

		// 포인트 색상 반전
		$(".inverse-btn").click(function(){
			var point = $(this).parents(".point");
			var img = point.find(".point-img");
			var imgSrc = img.attr("src");
			var btnImg = point.find(".inverse-btn img");
			if( imgSrc.indexOf("black") > -1 ){
				img.attr("src", imgSrc.replace("black", "white"));
				btnImg.attr("src", btnImg.attr("src").replace("black", "white"));
				point.data("color", "white");
			} else {
				img.attr("src", imgSrc.replace("white", "black"));
				btnImg.attr("src", btnImg.attr("src").replace("white", "black"));
				point.data("color", "black");
			}
			point.find(".point-name").css("color", point.data("color"));
			return false;
		});

		// 포인트 삭제
		$(".cross-btn").click(function(){
			var pointNames = $(this).parents(".edit-group").data("pointNames");
			var pointName = $(this).parents(".point").data("name");
			pointNames.insert(0, pointName);
			pointNames.sort();
			$(this).parents(".point").remove();
			$(".item-group[data-id='" + getActiveEditGroup().data("id") + "-" + pointName + "']").remove();
			return false;
		});

		// 포인트 추가
		$(".addPointBtn").click(function(){
			if( !selectThumb ){
				alert("이미지를 선택해주세요.");
				return;
			}

			var editGroup = getActiveEditGroup();
			var editPoint = editGroup.find(".edit-point");

			if( editPoint.find(".point").length == maxPointSize ){
				alert("최대 포인트는 " + maxPointSize + "개만 가능합니다.");
				return;
			}

			addPoint({isDrag: true, type: $(this).data("type")});
		});

		// 포인트 활성화
		var isDrag = false;
		$(".point").click(function(){
			console.log("point click");
			var point = $(this);
//			if( !point.hasClass("on") ){
//				console.log("포인트 클릭", point.data());
				$(".point").removeClass("on");
				$(".point .buttons").hide();
				point.addClass("on");
				point.find(".buttons").show();
				$("#itemAddBtn").show();

//				$(".selected-items .items").filter("[data-id='" + ($(selectThumb).data("id") + "-" + point.data("name")) + "']").show();

//				getItems(new ItemSearch(), function(){
//					// 기존에 선택된 아이템을 활성화
//					if( point.data("items") ){
//						$(point.data("items")).each(function(){
//							$(".item input[type='checkbox'][value='" + this + "']").prop("checked", true);
//						});
//					}
//				});

				$(".selected-items").show();

				getActiveEditGroup().find("canvas").mousemove(function(mouseevt){
//					console.log("point move");
					var point = getActivePoint();
					var type = point.data("type");
					var canvas = getActiveEditGroup().find("canvas");

//					var moveY = dd.offsetY - canvas.offset().top;
//					var moveX = dd.offsetX - (canvas.offset().left + 60);

					var moveY = mouseevt.pageY - canvas.offset().top;
					var moveX = mouseevt.pageX - canvas.offset().left;

					if( type == "long" ){
						moveX -= 80;
					}

//					if( type == "short" ){
//						moveX -= 60;
//					}

					if( moveY < -5 || moveX < 0 || moveX > 449 || moveY > 710 )
						return;

					getActivePoint().css({
						top: moveY, left: moveX
					});

//					console.log("move", moveX, moveY);

					isDrag = true;

				});


//			} else {
//				//$(".items .item").remove();
//			}
		});

		$('.drag-box').click(function(){
			var thisPointData = $(this).parents(".point").data();
			var activePointData = getActivePoint().data();

//			console.log(isDrag);

			if( thisPointData.name == activePointData.name && isDrag ){
				getActiveEditGroup().find("canvas").off("mousemove");
				isDrag = false;
			} else {
				getActivePoint().click();
			}

//			if( $(this).parents(".point") )
//			getActiveEditGroup().find("canvas").off("mousemove");
			return false;
		});

		// 포인트 박스 드래그
//		$('.drag-box').drag(function( ev, dd ){
//			var point = $(this).parents(".point");
//			var type = point.data("type");
//			var canvas = getActiveEditGroup().find("canvas");
//			var moveY = dd.offsetY - canvas.offset().top;
//			var moveX = dd.offsetX - (canvas.offset().left + 60);
//
//			if( type == "long" && point.find(".rotated").length > 0 ){
//				moveX += 80;
//			}
//
//			if( type == "short" ){
//				moveX += 60;
//			}
//
//			if( moveY < -5 || moveX < 0 || moveX > 449 || moveY > 710 )
//				return;
//
//			point.css({
//				top: moveY, left: moveX
//			});
//
//		});

		$("#uploadFile").change(function(){

			// 수정모드 일경우 다른 썸네일은 삭제
			if( saveType == "mod" ){
				$(".thumbs .upload-thumb").each(function(){
					$(this).find(".remove-thumb").click();
				});
				initThumbPage();
			}

			var inputFile = $(this).get(0);
			var fileCnt = 0;
			function previewFile(){
				var img = new Image();
				img.style.width = "133px";
				img.style.height = "auto";

				var file = inputFile.files[fileCnt];

				if( !file ) {
					$.goThumbLastPage();
					return;
				}

				// image 파일만
				if (!file.type.match(/image\//)) return;

				// preview
				try {
					// 에디트 그룹 생성
					var editGroup = $(".template .edit-group").clone();
					var editCanvas = {
						canvas : editGroup.find("canvas")[0]
						, context : editGroup.find("canvas")[0].getContext('2d')
					};
					var tId = thumbIdNext();
					editGroup.attr("data-id", tId);
					editGroup.data("pointNames", pointNameList.slice(0));
					$(".edit-panel").append(editGroup);

					var reader = new FileReader();
					reader.onload = function(e){
						img.src = e.target.result;
						img.onload = function(){

							if( img.width < uploadMinSize.width || img.height < uploadMinSize.height ){
								var alertText = "이미지 최소 사이즈는 " + uploadMinSize.width + " x " + uploadMinSize.height + " 입니다.";
								alertText += "\n\n현재 이미지 사이즈 : " + img.width + " x " + img.height;
								alert(alertText);
								editGroup.remove();
								$("#uploadFile").val("");
								return;
							}

							var uploadThumb = $('<div href="#" class="upload-thumb" data-id="' + tId + '"/>');
							var removeBtn = $("<a href='#' class='remove-thumb'/>");
							removeBtn.append('<i class="icon-close"></i>');
							uploadThumb.append(img);
							uploadThumb.append(removeBtn);

							if( $(".upload-thumb").length % 3 == 0 ){
								var page = $('<div class="thumb-page"/>');
								page.append(uploadThumb);
								$(".thumbs").append(page);
							} else {
								$(".thumb-page").last().append(uploadThumb);
							}

							var orgImg = new Image();
							orgImg.src = e.target.result;
							orgImg.onload = function(){
								var resizeResult = codiynaviResizeImage(orgImg.width, orgImg.height);
								console.log("resizeResult", resizeResult);

								if( resizeResult.width < 530 ){
									editGroup.width(resizeResult.width);
									editGroup.find("canvas").attr("width", resizeResult.width);
									editGroup.find("edit-canvas").attr("width", resizeResult.width);
								}
								if( resizeResult.height < 848 ){
									editGroup.height(resizeResult.height);
									editGroup.find("canvas").attr("height", resizeResult.height);
									editGroup.find("edit-canvas").attr("height", resizeResult.height);
								}

								editCanvas.context.drawImage(
										orgImg,
										resizeResult.left,
										resizeResult.top,
										resizeResult.width,
										resizeResult.height
								);

								fileCnt+=1;
								previewFile();

								if( $("#id").val() > 0 ){
									uploadThumb.click();
								}

							}

							$(orgImg).css("display", "none");
							$(orgImg).addClass("org-img");
							uploadThumb.append(orgImg);

						}

					}
					reader.readAsDataURL(file);
				} catch (e) {
					// exception...
					alert("지원하지 않는 브라우져 입니다.");
				}
			}
			previewFile();

		});

		// 캔버스 클릭시 포커스 제거
		$(document).on('click', 'canvas', function(evt){
			var editGroup = getActiveEditGroup();
			editGroup.find(".point").removeClass("on");
			editGroup.find(".point .buttons").hide();
			editGroup.find(".itemAddBtn").hide();
		});

		// 아이템 삭제
		$(document).on('click', '.item-remove-btn', function(){
			$(this).parents(".item").remove();
		});

		// 배포 체크 박스
		$(document).on('click', '.item-chk', function(){
			var editGroupId = getActiveEditGroup().data("id");
			var itemGroups = $(".item-group[data-id^='" + editGroupId + "']");
			var itemChks = itemGroups.find(".item-chk:checked");

			if( this.checked ){
				if( itemChks.length > 5 ){
					alert("배포 최대 개수는 5개 입니다.");
					return false;
				}
			}
		}); 

		// 상품 저장
		$("#saveAndPublishBtn").click(function(){
			for(var i=0; i<$(".thumbs .upload-thumb").length; i++){
				var uploadThumb = $(".thumbs .upload-thumb").get(i);
				var itemGroups = $(".editor-right .item-group[data-id^='" + $(uploadThumb).data("id") + "'");

				var itemCbList = $(itemGroups).find(".item-chk");
				var itemCbSelected = $(itemGroups).find(".item-chk:checked");

				if( itemGroups.length == 0 || itemCbList.length == 0 ){
					alert("최소한 1개 이상의 상품을 매칭해야 합니다.");
					return;
				}

				if( itemCbSelected.length < 5 ){
					if( !confirm("배포할 상품이 5개 선택되지 않은 코디는 임의로 채워집니다.\n계속하시겠습니까?") ) {
						return false;
					}
					if( itemCbList.length <= 5 ){
						itemCbList.prop("checked", true);
					} else {
						while( itemGroups.find(".item-chk:checked").length != 5 ){
							var rndNo = parseInt(Math.random() * itemCbList.length);
							itemCbList.eq(rndNo).prop("checked", true);
						}

					}
				}
			};

			var editGroupId = getActiveEditGroup().data("id");
			var itemGroups = $(".item-group[data-id^='" + editGroupId + "']");

			saveCallback = function(){
				$("#publishLayer iframe").attr("src", baseUrl + '/product/codiynavi?id=' + savedProduct.id + "&saveType=" + saveType);

				$("body").append($("#layer-mask, #publishLayer"));
				$("#layer-mask, #publishLayer").show();
				if( $(window).width() > 800 ){
					$("#publishLayer").css("margin-left", -(800/2));
				}
				if( $(window).height() > 900 ){
					$("#publishLayer").css("margin-top", -(900/2));
				}
				saveCallback = null;
			};
			$("#saveBtn").click();
		});

		// 배포창 닫기
		$("#publishLayer .close").click(function(){
			$("#layer-mask, #publishLayer").fadeOut();
		});

		// 상품 저장
		$("#saveBtn").click(function(){
//			if( getActiveEditGroup().length == 0 ){
//				alert("이미지를 선택해주세요.");
//				return false;
//			}

			var uploadThumbList = $(".upload-thumb");
			if( $("#id").val() != 0 ){
				uploadThumbList = [ getActiveThumb() ];
			}

//			var multiSaveTaskList = [];
			var saveTaskList = [];
			saveTaskResults = [];

			var valid = true;
			$(uploadThumbList).each(function(idx, uploadThumb){
				uploadThumb.click();

				if ($("form[data-id='" + getActiveThumb().data("id") + "'] input[name='title']").val() == ""){
					alert("제목은 필수 항목입니다.");
					valid = false;
				}
			});

			if( !valid ) return;

			$(uploadThumbList).each(function(idx, uploadThumb){
//				var uploadThumb = uploadThumbList[saveProductCnt];

				//multiSaveTaskList.push(function() {
//					var saveTaskList = [];

					saveTaskList.push(function (callback) {
						saveTaskResult = [];
						uploadThumb.click();
						$("canvas").click();

						if ($("#canvas-capture").length > 0)
							$("#canvas-capture").remove();

						callback(null);
					});

					saveTaskList.push(function (callback) {
						var editGroup = getActiveEditGroup();
						console.log($(editGroup).data("id") + "원본 이미지 저장", $(editGroup));
						saveImageDataUrl( {
								dataUrl : $(uploadThumb).find(".org-img").attr("src")
								, type : "ORIGINAL"
								, resizeWidth: 1920
							}
							, callback
						);
					});

					saveTaskList.push(function (imageData, callback) {
						saveTaskResult.push(imageData);
						var editGroup = getActiveEditGroup();
						console.log($(editGroup).data("id") + "포인트 없이 저장 처리", $(editGroup));
						editGroup.find(".point").hide();
						saveEditGroup(editGroup, callback);
					});

					saveTaskList.push(function (imageData, callback) {
						saveTaskResult.push(imageData);
						var editGroup = getActiveEditGroup();
						console.log($(editGroup).data("id") + "포인트 같이 저장 처리", $(editGroup));
						editGroup.find(".point").show();
						saveEditGroup(editGroup, callback);
					});

					saveTaskList.push(function (imageData, callback) {
//					async.series(saveTaskList, function (err, result) {
						saveTaskResult.push(imageData);

						var editGroup = getActiveEditGroup();
						var frmJson = JSON.parse($("form[data-id='" + editGroup.data("id") + "']").serializeJSON());
//						var frmJson = JSON.parse($("#frm").serializeJSON());
						frmJson.images = [];

						console.log("saveTaskResult", saveTaskResult);

						$(saveTaskResult).each(function () {
							this.viewImageId = $(editGroup).data("id");
							console.log(this);
							frmJson.images.push(this);
						});

						var uploadData = frmJson.images[0];

						frmJson.points = [];
						editGroup.find(".point").each(function () {
							var point = $(this).data();
							var position = $(this).position();
							var itemGroup = $(".item-group[data-id='" + $(editGroup).data("id") + "-" + point.name + "']");
							var selectedList = itemGroup.find($(".item .item-chk"));
							point.left = position.left;
							point.top = position.top;
							point.viewImageId = uploadData.viewImageId;
							point.items = [];

							$(selectedList).each(function (idx, chk) {
								point.items.push({id: chk.value, isPublish: (this.checked) ? 'Y' : 'N'});
							});

							frmJson.points.push(point);
						});

						console.log("frmJson", frmJson);

						if( saveType == "mod" ){
							frmJson.id = "${product.id}";
						}

						$.ajax({
							url: baseUrl + "/product/save",
							data: JSON.stringify(frmJson),
							type: "POST",
							dataType: "json",
							contentType: 'application/json',
							success: function (res) {
								savedProduct = res.data.product;
								console.log(res);
								saveTaskResults.push(res);

								console.log($(".upload-thumb[data-id='" + getActiveEditGroup().data("id") + "']"));

								$(".upload-thumb[data-id='" + getActiveEditGroup().data("id") + "']").attr("data-saveid", res.data.product.id);
								$(uploadThumb).data("saveid", res.data.product.id);

								if (res.result) {
									callback();

								} else {
									if (res.message == "code") {
										alert("코드 생성실패");
									} else if (res.message == "maxItem") {
										alert("최대 상품 매칭 개수를 초과하였습니다.");
									} else {
										alert("저장이 실패 하였습니다.");
									}
								}
							},
							error: function () {
								Loader.hide();
								alert("저장이 실패 하였습니다.");

							}
						});

						//				Loader.hide();

					});


				//});

			});

//			console.log(saveTaskList);
			Loader.show();
			async.waterfall(saveTaskList, function () {
				console.log("result", saveTaskResults);
				console.log("완료");
				alert("저장이 완료되었습니다.");
				if (saveCallback) {
					saveCallback();
				} else {
					location.href = "<spring:url value="/product/products"/>";
				}
				Loader.hide();
			});

		});

		// 아이템 체크시 포인트 data.items 값에 추가함
//		$(document).on('change', ".item input[type='checkbox']", function(){
//			var point = getActivePoint();
//			point.data("items", getItemSelectValues());
//			console.log(point.data());
//		});

		// 아이템 추가 팝업
		$(document).on('click', '.itemAddBtn', function(){
			var isAdd = false;
			var addName = $(this).parents(".item-group").data("id").split("-")[1];
			getActiveEditGroup().find(".point").each(function(idx, point){
				if( $(point).data("name") == addName ){
					isAdd = true;
				}
			});

			if( !isAdd ){
				alert("포인트가 존재하지 않습니다.");
				return;
			}

			$(".itemAddBtn").removeClass("on");
			$(this).addClass("on");
			var win = window.open(baseUrl + "/item/items/popup", "itemPopup", "width=1200,height=700");
		});

		// 등록코드
		$("#codeBtn").click(function(){
			if( $("#id").val() == 0 ){
				alert("등록코드는 등록 후 볼수 있습니다.");
			} else {
				$("#codeModal").modal();
			}
		});
	});

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

	/**
	 * 신규 섬네일 아이디 생성
	 * @returns {string}
	 */
	function thumbIdNext(){
		var no = parseInt(thumbId.replace("N", ""));
		thumbId = "N" + (no+1);
		return thumbId;
	}

	/**
	 * 활성화된 썸네일
	 * @returns {*|jQuery|HTMLElement}
	 */
	function getActiveThumb(){
		return $(".upload-thumb.on");
	}

	/**
	 * 활성화된 에디터 그룹
	 * @returns {*|jQuery|HTMLElement}
	 */
	function getActiveEditGroup(){
		return $(".edit-group[data-id='" + getActiveThumb().data("id") + "']");
	}

	/**
	 * 활성화된 캔버스 정보
	 * @returns {{canvas: *, context: (CanvasRenderingContext2D|*|CanvasRenderingContext2D_)}}
	 */
	function getActiveCanvas(){
		return {
			canvas: getActiveEditGroup().find("canvas:eq(0)")[0]
			, context: getActiveEditGroup().find("canvas:eq(0)")[0].getContext('2d')
		}
	}

	/**
	 * 활성화된 포인트
	 */
	function getActivePoint(type){
		return getActiveEditGroup().find(".point.on");
	}

	function saveImageDataUrl(params, callback){
//		console.log(params);
		var xhr = new XMLHttpRequest();
		xhr.open("post", "<spring:url value="/product/saveImage/temp"/>" , false);
		var boundary = Math.random().toString().substr(2);
		xhr.setRequestHeader("content-type",
				"multipart/form-data; charset=utf-8; boundary=" + boundary);
		var multipart = "--" + boundary + "\r\n" +
				"Content-Disposition: form-data; name=myImg\r\n" +
				"Content-type: image/png\r\n\r\n" +
				params.dataUrl + "\r\n" +
				"--" + boundary + "--\r\n";
		xhr.onreadystatechange = function() {
			var res = null;
			if (xhr.readyState == XMLHttpRequest.DONE) {
				res = JSON.parse(xhr.responseText);
				if( res.result ){
					res.data.type = params.type;
					callback(null, res.data);

				} else {
					alert("[1] 이미지 저장이 실패 하였습니다.");
				}

			}

		}
		xhr.send(multipart);
	}

	/**
	 * 캔버스 캡쳐 저장
	 * @param editGroup
	 * @param callback
     */
	function saveEditGroup(editGroup, callback){
		// 캡쳐 이미지 저장
		html2canvas(editGroup, {
			onrendered: function(canvas) {
				var canvasId = "canvas-capture-" + $(editGroup).data("id");

				if( $("#"+canvasId).length > 0 )
					$("#"+canvasId).remove();

				document.body.appendChild(canvas);
				$(canvas).attr("id", canvasId );
				$(canvas).css("display", "none");

				var xhr = new XMLHttpRequest();
				xhr.open("post", "<spring:url value="/product/saveImage/temp"/>", false);
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
							res.data.type = "MAIN";
							if( editGroup.find(".point").is(":visible") ){
								res.data.type = "CAPTURE";
							}

						} else {
							alert("[1] 이미지 저장이 실패 하였습니다.");
						}

					}
					setTimeout(function(){
						callback(null, res.data);
//						$(editGroup).hide();
					}, 500);

				}
				xhr.send(multipart);
			}
		});
	}

	/**
	 * 선택된 아이템 번호
	 * @returns {*}
     */
	function getItemSelectValues(){
		var selectedList = $(".item input[type='checkbox']:checked");
		var search = { ids : $(".item input[type='checkbox']:checked").map(function(){ return this.value; }).toArray() };
		return search.ids;
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

	/**
	 * 기존에 업로드된 메인 이미지 로드
	 */
	function loadMainImage(callback){
		// preview
		try {
			// 에디트 그룹 생성
			var editGroup = $(".template .edit-group").clone();
			var editCanvas = {
				canvas : editGroup.find("canvas")[0]
				, context : editGroup.find("canvas")[0].getContext('2d')
			};
			var tId = thumbIdNext();
			editGroup.attr("data-id", tId);
			editGroup.data("pointNames", pointNameList.slice(0));
			$(".edit-panel").append(editGroup);

			var mainImageData = getBase64Image($("#mainImage")[0]);
			var img = new Image();
			img.style.width = "133px";
			img.style.height = "auto";
			img.onload = function(){
				if( img.width < uploadMinSize.width && img.height < uploadMinSize.height ){
					var alertText = "이미지 최소 사이즈는 " + uploadMinSize.width + " x " + uploadMinSize.height + " 입니다.";
					alertText += "\n\n현재 이미지 사이즈 : " + img.width + " x " + img.height;
					alert(alertText);
					editGroup.remove();
					$("#uploadFile").val("");
					return;
				}

				var uploadThumb = $('<div href="#" class="upload-thumb" data-id="' + tId + '"/>');
				var removeBtn = $("<a href='#' class='remove-thumb'/>");
				removeBtn.append('<i class="icon-close"></i>');
				uploadThumb.append(img);
				uploadThumb.append(removeBtn);

				if( $(".upload-thumb").length % 3 == 0 ){
					var page = $('<div class="thumb-page"/>');
					page.append(uploadThumb);
					$(".thumbs").append(page);
				} else {
					$(".thumb-page").last().append(uploadThumb);
				}

				var orgImg = img;

				var resizeResult = codiynaviResizeImage(orgImg.width, orgImg.height);
				console.log("resizeResult", resizeResult);

				if( resizeResult.width < 530 ){
					editGroup.width(resizeResult.width);
					editGroup.find("canvas").attr("width", resizeResult.width);
				}
				if( resizeResult.height < 848 ){
					editGroup.height(resizeResult.height);
					editGroup.find("canvas").attr("height", resizeResult.height);
				}

				editCanvas.context.drawImage(
						orgImg,
						resizeResult.left,
						resizeResult.top,
						resizeResult.width,
						resizeResult.height
				);

				if( $("#id").val() > 0 ){
					uploadThumb.click();
				}

				$(orgImg).css("display", "none");
				$(orgImg).addClass("org-img");
				uploadThumb.append(orgImg);

				$(".upload-thumb").eq(0).click();
				callback();

			}

			img.src = mainImageData;
		} catch (e) {
			// exception...
			alert("지원하지 않는 브라우져 입니다.");
		}
	}

	/**
	 * 수정모드 설정
	 */
	function modifyView(){
		Loader.show();
		$("#uploadFile").hide();
		$(".upload-thumbs").children().hide();

		async.series([
			loadMainImage
			, function(callback){
				var editGroup = getActiveEditGroup();

				$.post("<spring:url value="/product/points"/>", {productId: $("#id").val()}, function(res){
					console.log(res);
					$( res.data.points).each(function(idx, point){
						addPoint(point);

						$(point.items).each(function(idx, item){
							var itemEl = $(".template .item").clone();
							itemEl.data(item);
							itemEl.find("input[type='checkbox']").val( item.id );
							if( item.isPublish == "Y" ){
								itemEl.find("input[type='checkbox']").prop("checked", true);
							}
							itemEl.find(".pic").append("<img src='" + getItemThumbUrl(item.thumbPath, item.thumbName) + "'/>");
							itemEl.find(".text1").html(item.title);
							itemEl.find(".text2").html(item.name);
							itemEl.find(".text3").html(Number(item.price).toLocaleString('ko'));

							var itemGroup = $(".item-group[data-id='" + $(editGroup).data("id") + "-" + point.name + "']");
							itemGroup.find(".items").prepend(itemEl);
						});

					});
					callback();
				});
			}

		], function(err, result){
			Loader.hide();
			if( err )
				console.log(err);

//			console.log(result);
			setTimeout(function () { Loader.hide(); }, 1000);
		});
	}

	/**
	 * 포인트 추가
	 * @param params
     */
	function addPoint(params){
		var editGroup = getActiveEditGroup();
		var editPoint = editGroup.find(".edit-point");
		var point = $(".template .point").clone(true);
		var pointImg = point.find(".point-img")
//		var pointImgName = "point-{0}-{1}-{2}.png";
		var pointImgName = "point-{0}-{1}.png";
		var pointData = {
			color: "black"
			, type: "short"
			, name: "a"
		};

		if( params.type == "long" ){
			pointData.type = "long";
			pointImg.attr("width", 77);

		} else {
			pointData.type = "short";
			pointImg.attr("width", 23);
		}

		var pointNames = editGroup.data("pointNames");
//		console.log(pointNames);
		if( params.name ){
			pointData.name = params.name;
			var newNames = [];
			$(pointNames).each(function(idx, pname){
				if( pname != params.name ){
					newNames.push( pname );
				}
			});
			editGroup.data("pointNames", newNames);

		} else {
			if( pointNames[0] ){
				pointData.name = pointNames.shift();
			}
		}

		if(params.left){
			point.css("left", params.left);
		}

		if(params.top){
			point.css("top", params.top);
		}

		if(params.id){
			pointData.id = params.id;
		}

		if(params.color){
			pointData.color = params.color;
		}

		point.data(pointData);
		pointImg.attr("src", baseUrl + "/resources/images/" + pointImgName.format(pointData.color, pointData.type, pointData.name));

		point.find(".point-name").text(pointData.name.toUpperCase());
		point.find(".point-name").css("color", pointData.color);
		editPoint.append(point);

		// 아이템 그룹 생성
		var itemGroup = $(".template .item-group").clone();
		var pointId = getActiveEditGroup().data("id") + "-" + pointData.name;
//						console.log(pointId);
		itemGroup.attr("data-id", pointId);
		itemGroup.find(".name-panel p").text(pointData.name.toUpperCase());
		$(".selected-items").append(itemGroup);
		itemGroup.show();

		if( params.isDrag ){
			point.click();
		}

	}

</script>

	<script src="${baseUrl}/resources/scripts/item-category.js"></script>

</head>
<body>
	<input type="hidden" id="id" value="${product.id}"/>

	<div id="publishPopup"></div>

	<!-- page head start-->
	<div class="page-head">
	    <h3></h3>
	    <span class="sub-title"></span>
	</div>
	<!-- page head end-->

	<!--body wrapper start-->
	<div class="wrapper page-productform">

		<section class="panel">

			<div class="panel-body">

				<div class="editor">

					<div class="editor-left">
						<div class="buttons">
							<label for="uploadFile" class="btn btn-primary">이미지 업로드</label>
							<input id="uploadFile" type="file" accept="image/*" class="upload-file-hidden" multiple/>

							<div class="point-buttons pull-right">
								<%--<span>포인터 추가</span>--%>
								<a href="#" class="addPointBtn" data-type="short"><img src="<spring:url value="/resources/images/btn-short-point.jpg"/>"/></a>
								<a href="#" class="addPointBtn" data-type="long"><img src="<spring:url value="/resources/images/btn-long-point.jpg"/>"/></a>
							</div>
						</div>
						<div class="upload-thumbs">
							<a href="#" id="thumbPageUpBtn"><img src="<spring:url value="/resources/images/btn-thumb-up.png"/>" /></a>

							<div class="thumbs">

							</div>

							<a href="#" id="thumbPageDownBtn"><img src="<spring:url value="/resources/images/btn-thumb-down.png"/>" /></a>
						</div>

						<div class="edit-panel"></div>

						<div class="bottom-buttons">
							<a href="#" class="btn btn-default cancelBtn">취소</a>
							<a href="#" id="codeBtn" class="btn btn-info pull-right">등록코드</a>
						</div>
					</div>

					<div class="editor-right">

						<div class="bottom-buttons">
							<c:choose>
								<c:when test="${product.id == 0}">
									<a style="display:none;" href="#" class="btn btn-primary" id="saveBtn">등록</a>
									<a href="#" class="btn btn-warning" id="saveAndPublishBtn">배포</a>
								</c:when>
								<c:otherwise>
									<a style="display:none;" href="#" class="btn btn-primary" id="saveBtn">수정</a>
									<a href="#" class="btn btn-warning" id="saveAndPublishBtn">배포</a>
								</c:otherwise>
							</c:choose>
						</div>

						<div class="selected-items">

						</div>

						<div class="editor-form">
							<c:if test="${product.id > 0}">
								<form:form id="frm" action="${saveUrl}" commandName="product">
									<form:hidden path="id"/>
									<form:input path="title" class="form-control" placeholder="제목"/>
									<form:textarea path="description" class="form-control" placeholder="내용은 500글자 내외로 작성해 주시고,\n고객이 궁금해 하는 개인 SNS, 및 URL주소 및\n개인 신체사이즈를 함께 적으시면 더욱 좋습니다."/>
								</form:form>
							</c:if>
							<c:if test="${not empty product.mainImage}">
								<img id="mainImage" style="display:none;" src="<spring:url value="/resources/uploads"/>${product.mainImage.filePath}/${product.mainImage.fileName}"/>
							</c:if>
						</div>

					</div>

				</div>

			</div>

		</section>

	</div>
	<!--body wrapper end-->

	<div class="template">
		<div class="point">
			<img class="point-img" src="${baseUrl}/resources/images/point-black-long.png"/>
			<div class="point-name">A</div>
			<div class="buttons">
				<a href="#" class="drag-box"></a>
				<a href="#" class="inverse-btn"><img src="${baseUrl}/resources/images/btn-rotate-black.png"/></a>
				<%--<a href="#" class="rotate-btn"><img src="<spring:url value="/resources/images/btn-rotate.png"/>"/></a>--%>
				<a href="#" class="cross-btn"><img src="${baseUrl}/resources/images/btn-cross.png"/></a>
			</div>
		</div>

		<div class="edit-group">
			<div class="edit-canvas">
				<%--<canvas width="460" height="736"></canvas>--%>
				<canvas width="530" height="848"></canvas>
			</div>
			<div class="edit-point"></div>
		</div>

		<div class="item">
			<input class="item-chk" type="checkbox" />
			<a href="#" class="item-remove-btn"><i class="icon-close"></i></a>
			<%--<span class="badge bg-inverse">3</span>--%>
			<div class="pic">
			</div>
			<div class="info">
				<p class="text1">에잇세컨즈</p>
				<p class="text2">니코 7부 리얼데님 8oz</p>
				<p class="text3">84,000</p>
			</div>
		</div>

		<div class="item-group">
			<div class="name-panel"><p>A</p></div>
			<div class="items">
				<a href="#" class="itemAddBtn">
					<i class="fa fa-plus"></i>
				</a>
			</div>
		</div>

		<form>
			<input name="id" type="hidden"/>
			<input name="title" type="text" class="form-control" placeholder="제목"/>
			<textarea name="description" class="form-control" placeholder="내용은 500글자 내외로 작성해 주시고,\n고객이 궁금해 하는 개인 SNS, 및 URL주소 및\n개인 신체사이즈를 함께 적으시면 더욱 좋습니다."></textarea>
		</form>

	</div>

	<div class="modal fade in" id="codeModal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title">등록코드</h4>
				</div>
				<div class="modal-body">
					<h3>${product.code}</h3>
					<p>${baseFrontUrl}/cn/${product.code}</p>
				</div>
				<!--
				<div class="modal-footer">
					<button class="btn btn-primary" data-dismiss="modal" type="button"> 확인</button>
				</div>
				-->
			</div>
		</div>
	</div>

	<div id="layer-mask" style="display: none; position: fixed; z-index: 9999"></div>

	<c:choose>
		<c:when test="${product.id == 0}">
			<div id="publishLayer" style="width:955px">
					<%--<a href="#" class="close"><i class="icon-close"></i></a>--%>
				<iframe frameborder="0" src="about:blank" style="overflow-x:hidden;"></iframe>
			</div>
		</c:when>
		<c:otherwise>
			<div id="publishLayer" style="width:815px">
					<%--<a href="#" class="close"><i class="icon-close"></i></a>--%>
				<iframe frameborder="0" src="about:blank" style="overflow-x:hidden;"></iframe>
			</div>
		</c:otherwise>
	</c:choose>




</body>
</html>
