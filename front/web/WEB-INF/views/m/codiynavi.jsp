<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>

<html>
    <head>
        <script>
            window.gaObj = {
                hitType: 'pageview',
                page: '/main',
                title: '(모바일) 코디나비'
            };

            var beforeHash = "";

            $(document).ready(function(){

                var productItem = {
                    id: parseInt("${product.id}")
                    , member: "${product.memberNickName}"
                    , title: "${product.title}"
                };

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

                ga('send', 'pageview', "/m/codiynavi/view/" + productItem.member + "/" + productItem.id, {title: productItem.title});

                $(window).bind('hashchange', function() {
                    if( beforeHash == "#share" ){
                        $("#shareCancelBtn").click();
                    }
                    if( beforeHash == "#zoom" ){
                        $(".zoom-pic").click();
                    }

                    beforeHash = window.location.hash;
                });

                // 공유 버튼
                $(".share-btn").click(function(){
                    $(".layer-mask").show();
                    $("#sourceIframe").attr("src", baseUrl + "/codiynavi-source?id=" + $(".codiynavi").data("id"));
                });

                // 확대 버튼
                $(".zoom-btn").click(function(){
                    $(".codiynavi .zoom-pic, .layer-mask").show();
                });

                $(".zoom-pic").click(function(){
                    $(".codiynavi .zoom-pic, .layer-mask").hide();
                });

                // 복사 버튼
                $(document).on("click", "#shareLinkBtn, #shareHtmlBtn", function(){
//                    var inputId = $(this).attr("id").replace("Btn", "");
//                    $("#"+inputId).select();
//                    document.getElementById(inputId).selectionStart = 0
//                    document.getElementById(inputId).selectionEnd = 99999;
                    alert("텍스트를 선택 후 복사해주세요.");
                    return false;
                });

//                var clipboard = new Clipboard('#shareLinkBtn, #shareHtmlBtn', {
//                    text: function(trigger) {
//                        var inputId = $(trigger).attr("id").replace("Btn", "");
//                        return $("#"+inputId).val();
//                    }
//                });
//
//                clipboard.on('success', function(e) {
//                    alert("복사 되었습니다.");
//                });


//                $(document).on("click", "#shareLink, #shareHtml", function(){
//                    $("#" + $(this).attr("id") + "Btn").click();
//                });

                $("#shareCancelBtn").click(function(){
                    $(".share, .layer-mask").hide();
                    $("#sourceIframe").attr("src", "about:blank");
                });

                $(window).resize(function(){
                    $(".share, .codiynavi .zoom-pic").width( $(window).width() - 10 );
                    $(".share, .codiynavi .zoom-pic").height( $(window).width() - 10 );
                }).resize();

                $("body").on("touchmove", function(){
                    return !$(".layer-mask").is(":visible");
                });

            });
        </script>

    </head>
<body>



    <section class="codiynavi" data-id="${product.id}">
        <a href="#share" class="share-btn"><i class="icon-share"></i></a>
        <a href="#zoom" class="zoom-btn"><i class="icon-zoom"></i></a>

        <div class="layer-mask"></div>
        <div class="zoom-pic">
            <img class="main-img" src="${baseUrl}/resources/uploads${product.mainImage.filePath}/${product.mainImage.fileName}"/>
        </div>
        <div class="share">
            <div class="share-wrap">
                <input id="shareLink" type="text" readonly="readonly" value="${baseUrl}/main?viewId=${product.id}" />
                <a href="#" id="shareLinkBtn">링크복사</a>
                <textarea id="shareHtml" type="text" readonly="readonly"></textarea>
                <a href="#" id="shareHtmlBtn">코드복사</a>
                <a href="#" class="close-btn" id="shareCancelBtn">취소</a>
            </div>
        </div>

        <div class="main-panel">
            <%--<img src="${baseUrl}/resources/uploads${product.captureImage.filePath}/${product.captureImage.fileName}"/>--%>

            <div class="main-panel-wrap">

                <img class="main-img" src="${baseUrl}/resources/uploads${product.mainImage.filePath}/${product.mainImage.fileName}"/>
                <div class="points">

                    <c:forEach items="${points}" var="point" varStatus="status">

                        <c:set var="pointTop" value="${(point.top - (point.top*53/100))}"/>
                        <c:set var="pointLeft" value="${(point.left - (point.left*47/100))}"/>

                        <c:set var="pointWidth" value="42"/>
                        <c:if test="${point.type == 'short'}"><c:set var="pointWidth" value="12"/></c:if>

                        <%--<div class="point" data-top="${point.top}" data-left="${point.left}" data-name="${point.name}" style="top: ${pointTop}px; left: ${pointLeft}px;">--%>
                            <%--<a href="#point-${point.name}" data-sc-target=".item-panel">--%>
                                <%--<img class="point-img" src="${baseUrl}/resources/images/point-${point.color}-${point.type}-${point.name}.png" width="${pointWidth}">--%>
                            <%--</a>--%>
                        <%--</div>--%>
                        <div class="point" data-name="${point.name}" style="top: ${pointTop}px; left: ${pointLeft}px;">
                            <a href="#point-${point.name}" data-sc-target=".item-panel">
                                <img class="point-img" src="${baseUrl}/resources/images/point-${point.color}-${point.type}.png" width="${pointWidth}">
                                <div class="point-name" style="color:${point.color}">${fn:toUpperCase(point.name)}</div>
                            </a>
                        </div>
                    </c:forEach>

                </div>

            </div>

        </div>

        <div class="item-panel">

            <div class="panel-heading">
                <div class="line"></div>
                <div class="info">
                    <p class="title">${product.title}</p>
                    <div class="viewcount">
                        <i class="icon-eye"></i>
                        <span><fmt:formatNumber value="${product.viewCount}" type="currency" currencySymbol="" /></span>
                    </div>
                </div>
            </div>

            <div class="panel-item">

                <c:forEach items="${points}" var="point" varStatus="status">

                        <c:forEach items="${point.items}" var="item" varStatus="status2">

                            <c:if test="${status2.first}">
                                <!-- item point heading -->
                                <a name="point-${point.name}"></a>
                                <div class="item-heading" data-name="${point.name}">
                                    <div class="line"></div>
                                    <div class="point-name">${fn:toUpperCase(point.name)}</div>
                                    <div class="line"></div>
                                </div>
                                <!-- //item point heading -->

                                <!-- items -->
                                <div class="items">
                            </c:if>

                            <div class="item" <c:if test="${not empty item.link}">style="cursor:pointer;" onclick="openLink('${item.link}');"</c:if>>
                                <div class="pic"><img src="${baseUrl}/resources/uploads${item.thumbUrl}"/></div>
                                <div class="colors">
                                    <c:forEach items="${item.colorProperties}" var="color" varStatus="colorStatus">
                                        <c:if test="${colorStatus.count <= 3}">
                                            <c:set var="colorTop" value="${30 - (colorStatus.index * 10)}"/>
                                            <c:if test="${fn:length(item.colorProperties) > 3}">
                                                <c:set var="colorTop" value="${20 - (colorStatus.index * 10)}"/>
                                            </c:if>
                                            <div class="color" style="top:${colorTop}px;background-color:${color.name}"></div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${fn:length(item.colorProperties) > 3}">
                                        <p>+3</p>
                                    </c:if>
                                </div>
                                <div class="item-info">
                                    <p class="brand">${item.title}</p>
                                    <p class="name">${item.name}</p>
                                    <p class="price"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol=""/></p>
                                </div>
                            </div>

                            <c:if test="${status2.count % 3 == 0}">
                                </div><div class="items">
                            </c:if>

                        </c:forEach>

                    </div>
                    <!-- //items -->

                </c:forEach>

            </div>

            <div class="panel-footer">
                <div class="line"></div>
                <div class="title">
                    <img src="${baseUrl}/resources/images/txt-editorsay.jpg"/>
                </div>
                <div class="text">
                    <p>${fn:replace(product.description, crcn, '<br/>')}</p>
                </div>
                <div class="line" style="margin-top:7px;"></div>
                <div class="author">
                    <span class="by">by</span>
                    <span>${product.memberNickName}</span>
                </div>
            </div>

        </div>

        <iframe id="sourceIframe" frameborder="0" src="about:blank" style="width:1px;height:1px;"></iframe>

    </section>

</body>
</html>