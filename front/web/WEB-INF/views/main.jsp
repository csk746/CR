<jsp:directive.page contentType="text/html;charset=UTF-8"/>
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>
<html>
<head>
    <!-- main 2 -->

    <script type="text/javascript"
            src="${baseUrl}/resources/scripts/jquery-fakeform/jquery-fakeform-0.5.min.js"></script>
    <script type="text/javascript"
            src="${baseUrl}/resources/scripts/libs/jquery.smooth-scroll.min.js"></script>

    <link href="${baseUrl}/resources/scripts/jquery-fakeform/fakeform.css" rel="stylesheet">

    <script src="${baseUrl}/resources/scripts/zeroclipboard/jquery.zeroclipboard.min.js"></script>

    <script>

        window.gaObj = {
            hitType: 'pageview',
            page: '/main',
            title: '(PC) 메인'
        };

        // 바로보기 (모바일 경우 이동)
        if("${viewId}" != "" && isMobile.any()){
            location.href = baseUrl + "/m/codiynavi/${viewId}";
        }

        window.isAutoLoader = false;

        $(document).ready(function () {

            $(window).resize(function(){
                $("#zoomLayer").width($(window).width());
                $("#zoomLayer").height($(window).height());
            }).resize();


            $("select").fakeform();
            $("body").prepend($("#codiynaviLayer"));

            $("#orderBy").change(function () {
                if( $("#orderBy").val() == "" ){
                    location.href = "<spring:url value="/main"/>";
                } else {
                    $("#search").submit();
                }
            });

            // 공유 버튼
            $(document).on('click', '#shareCancelBtn, .share-btn', function () {
                if( $(".share").is(":visible") ){
                    $(".share").fadeOut('fast');

                } else {
                    $("#sourceIframe").attr("src", baseUrl + "/codiynavi-source?id=" + $(".codiynavi").data("id"));

                }

            });

//            // 복사 버튼
//            $(document).on("click", "#shareLinkBtn, #shareHtmlBtn", function(){
//                var inputId = $(this).attr("id").replace("Btn", "");
//                $("#"+inputId).select();
//                alert("CTRL + C 로 복사해주세요.");
//                return false;
//            });

            $(document).on("copy", "#shareLinkBtn, #shareHtmlBtn", function(/* ClipboardEvent */ e) {
                var targetId = $(this).attr("id");
                var copyData = "";
                if( targetId == "shareLinkBtn" ){
                    copyData = $("#shareLink").val();
                }
                if( targetId == "shareHtmlBtn" ){
                    copyData = $("#shareHtml").val();
                }
                e.clipboardData.clearData();
                e.clipboardData.setData("text/plain", copyData);
                e.preventDefault();
                alert("복사 되었습니다.");
            });

            $(document).on("click", "#shareLink, #shareHtml", function(){
                $("#" + $(this).attr("id") + "Btn").click();
            });

            // 코디나비 보기
            $(document).on('click', '.products .items .item', function () {
                var productItem = {
                    id: $(this).data("id")
                    , member: $(this).find(".member").text().trim()
                    , title: $(this).find(".text1").text().trim()
                };
                $.get(baseUrl + "/codiynavi/" + $(this).data("id"), function (html) {

                    var gaProduct = {
                        id: productItem.id
                        , name: productItem.title
                        , dimension1: productItem.member
                    };

                    //traking
                    // The impression from a Related Products section.
//                    ga('ec:addImpression', gaProduct);

                    // The product being viewed.
//                    ga('ec:addProduct', {                 // Provide product details in an productFieldObject.
//                        'id': 'P67890',                     // Product ID (string).
//                        'name': 'YouTube Organic T-Shirt',  // Product name (string).
//                        'category': 'Apparel/T-Shirts',     // Product category (string).
//                        'brand': 'YouTube',                 // Product brand (string).
//                        'variant': 'gray',                  // Product variant (string).
//                        'position': 2                       // Product position (number).
//                    });

//                    ga('ec:setAction', 'detail');       // Detail action.
//
                    ga('send', {
                        hitType: 'event',
                        eventCategory: productItem.member,
                        eventAction: 'view',
                        eventLabel: productItem.title
                    });

                    ga('send', 'pageview', "/codiynavi/view/" + productItem.member + "/" + productItem.id, {title: productItem.title});

                    console.log(gaProduct);

                    var codiynavi = $(html).find(".codiynavi");
                    $(".layer-codiynavi").children().remove();
                    $(".layer-codiynavi").append(codiynavi[0].outerHTML);
                    $("#codiynaviLayer").fadeIn("fast");

                    $("#zoomLayer img").remove();
                    var zoomImg = $("<img/>").attr("src", $(".main-panel img.original").attr("src"));
                    $("#zoomLayer .zoom-image-wrap").append(zoomImg);

                    $(".codiynavi .main-panel img:eq(0)").each(function(){
                        var image = $(this);
                        var parent = $(this).parent();
                        var newImage = new Image();
                        newImage.onload = function(){
                            image.attr("src", $(this).attr("src"));

                            var imageWidth = newImage.width;
                            var imageHeight = newImage.height;

                            var resizeResult = {
                                width : imageWidth
                                , height : imageHeight
                            };

//                            var resizeResult = resizeImage(500, 848, imageWidth, imageHeight);
//
//                            if( resizeResult.height > 450 ) {
//                                resizeResult.top = resizeResult.left = 0;
//                            }

//                            if( resizeResult.width < parent.width() ) {
//                                resizeResult.marginLeft = resizeResult.left;
//                            }
//                            if( resizeResult.height < parent.height() ) {
//                                resizeResult.marginTop = resizeResult.top;
//                            }

                            $(image).css( resizeResult );

//                            $(".codiynavi .main-panel").width( resizeResult.width );
                            $(".codiynavi .main-panel").css("padding-right", $(".codiynavi .item-panel").width() + 10);
                            $(".codiynavi .item-panel").css("left", resizeResult.width);
                            $("section.codiynavi .panel-item").height($(".codiynavi").height() - $(".item-panel .panel-heading").height() - $(".item-panel .panel-footer").height() - 20);

                            $(".layer-codiynavi").css({
                                marginTop: -($(".codiynavi").height()/2)
                                , marginLeft: -($(".codiynavi").width()/2)
                            });

                            if( resizeResult.height < $(".main-panel").height() ){
                                $(".image-panel").css("top", ($(".main-panel").height() - resizeResult.height) / 2);
                            }

                        };
                        newImage.src = $(this).data("src");
                    });

                    console.log("아이템 썸네일 리사이즈");
                    $(".codiynavi .items .pic img").each(function(){
                        var image = $(this);
                        var parent = $(this).parent();
                        var newImage = new Image();
                        newImage.onload = function(){
                            var imageWidth = newImage.width;
                            var imageHeight = newImage.height;
                            var resizeResult = resizeImage(parent.width(), parent.height(), imageWidth, imageHeight);
                            $(image).css( resizeResult );
                            console.log(resizeResult);
                            image.attr("src", $(this).attr("src"));
                        };
                        newImage.src = $(this).attr("src");
                    });

                });
            });

            // 레이어 닫기 (코디나비)
            $("#codiynaviLayer .layer-mask").click(function () {
                $("#codiynaviLayer").fadeOut("fast", function () {
                    $(".layer-codiynavi").children().remove();
                });
                //location.href = "/main#";
            });

            // 레이어 닫기 (확대)
            $("#zoomLayer .layer-mask, .zoom-image-wrap").click(function () {
                $("#zoomLayer").hide();
            });

            // 바로보기
            if("${viewId}" != ""){
                $(".item[data-id='${viewId}']").click();
            }

            // 확대 보기
            $(document).on('click', '.zoom-btn', function(){
                var image = $("#zoomLayer img");
                var imageWrap = $("#zoomLayer .zoom-image-wrap");

                var imageHeightPercent = image[0].height / $(window).height() * 100;

                // 높이 비율이 90% 이상일때
                if( imageHeightPercent > 90 ){
                    imageWrap.addClass("full");
                    imageWrap.css("margin-top", "auto");
                } else {
                    imageWrap.removeClass("full");
                    imageWrap.css("margin-top", -(image[0].height / 2) );
                }
                console.log(imageHeightPercent);


                $("#zoomLayer").show();
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

//            var destWidth = 530;
//            var destHeight = 848;

//            console.log("기준 정보", destWidth, destHeight);

            var imgRatio = (imgWidth > imgHeight) ? getRatio(imgWidth, imgHeight) : getRatio(imgHeight, imgWidth);

//            console.log("이미지 정보", imgWidth, imgHeight);
//            console.log("이미지 비율", imgRatio);

            if( imgWidth < destWidth && imgHeight < destHeight ) {
                // 컨테이너 크기보다 작을때
                resizeResult.width = imgWidth;
                resizeResult.height = imgHeight;

            } else {
                if (imgWidth < imgHeight) {
                    resizeResult.height = destHeight;
                    resizeResult.width = parseInt(imgWidth * ((destHeight / imgHeight)));

                    if (resizeResult.width < destWidth) {
                        resizeResult.width = destWidth;
                        resizeResult.height = parseInt(imgHeight * ((destWidth / imgWidth)));

                    }

                }

                if (imgWidth > imgHeight) {
                    resizeResult.width = destWidth;
                    resizeResult.height = parseInt(imgHeight * ((destWidth / imgWidth)));

                    if (resizeResult.height < destHeight) {
                        resizeResult.height = destHeight;
                        resizeResult.width = parseInt(imgWidth * ((destHeight / imgHeight)));
                    }
                }
            }

//            console.log(resizeResult);

            // 위치
            if( resizeResult.width > destWidth ){
                resizeResult.left = -( (resizeResult.width / 2) - (destWidth/2) );
            }
            if( resizeResult.height > destHeight ){
                resizeResult.top = -( (resizeResult.height / 2) - (destHeight/2) );
            }

            return resizeResult;
        }

        function getRatio(width, height){
            return (Math.round((width/height)*100)/100)
        }


    </script>

</head>
<body>

<section class="products">

    <div class="filter">
        <form:form id="search" commandName="productSearch" class="form" method="get">
            <form:select path="orderBy">
                <form:option value="">조회순</form:option>
                <form:option value="recent">최신순</form:option>
            </form:select>
        </form:form>
    </div>

    <div class="line"></div>

    <div class="items">

        <c:forEach items="${products}" var="product" varStatus="status">

            <!-- item -->
            <div class="item" data-id="${product.id}" data-code="${product.code}">
                <spring:url var="image" value="/resources/uploads${product.mainImage.filePath}/${product.mainImage.fileName}"/>
                <div class="pic">
                    <img data-src="${image}" src="${baseUrl}/resources/images/blank.gif"/>
                </div>
                <div class="info">
                    <div class="text1"><p class="ellipsis">${product.title}</p></div>
                    <div class="text2">
                        <div class="member">
                            <i class="icon-people"></i>
                            <span>${product.memberNickName}</span>
                        </div>
                        <div class="viewcount">
                            <i class="icon-eye"></i>
                            <span><fmt:formatNumber value="${product.viewCount}" type="currency" currencySymbol="" maxFractionDigits="0"/></span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //item -->

        </c:forEach>

    </div>

</section>

<div id="zoomLayer" class="layer-popup">
    <div class="layer-mask"></div>
    <div class="zoom-image-wrap"></div>
</div>

<div id="codiynaviLayer">
    <div class="layer-mask"></div>
    <div class="layer-codiynavi"></div>
</div>

<iframe id="sourceIframe" width="1" height="1" style="display:none" src="about:blank"></iframe>

</body>
</html>
