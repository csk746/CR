<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>

<script>
    window.gaObj = {
        hitType: 'pageview',
        page: '/main',
        title: '(PC) 코디나비'
    };

</script>

<section class="codiynavi" data-id="${product.id}">

    <div class="main-panel">
        <%--<img src="${baseUrl}/resources/uploads${product.captureImage.filePath}/${product.captureImage.fileName}"/>--%>

        <c:set var="mainImage" value="${baseUrl}/resources/uploads${product.mainImage.filePath}/${product.mainImage.fileName}"/>
        <%--<c:set var="mainImage" value="${baseUrl}/resources/uploads${product.mainImage.filePath}/${product.mainImage.getFileNameAddType('cap')}"/>--%>

        <div class="image-panel">
            <div class="image-wrap">

                <a href="#" class="share-btn"><i class="icon-share"></i></a>
                <a href="#" class="zoom-btn"><i class="icon-zoom"></i></a>

                <div class="share">
                    <input id="shareLink" type="text" readonly="readonly" value="${baseUrl}/main?viewId=${product.id}" />
                    <textarea id="shareHtml" type="text" readonly="readonly">askdljflkasjdflkajsdf</textarea>
                    <a href="#" id="shareLinkBtn"></a>
                    <a href="#" id="shareHtmlBtn"></a>
                    <a href="#" id="shareCancelBtn"></a>
                </div>

                <img src="${baseUrl}/resources/images/blank.gif" data-src="${mainImage}"/>
                <div class="points">

                    <c:forEach items="${points}" var="point" varStatus="status">

                        <%--<c:set var="pointTop" value="${(point.top + (point.top*17/100))}"/>--%>
                        <%--<c:set var="pointLeft" value="${(point.left + (point.left*15/100))}"/>--%>

                        <c:set var="pointTop" value="${point.top}"/>
                        <c:set var="pointLeft" value="${point.left}"/>

                        <c:set var="pointWidth" value="77"/>
                        <c:if test="${point.type == 'short'}"><c:set var="pointWidth" value="23"/></c:if>

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
        <%--<img src="${baseUrl}/resources/images/blank.gif" data-src="${mainImage}"/>--%>

        <img class="original" style="display:none;" src="${baseUrl}/resources/uploads${product.mainImage.filePath}/${product.mainImage.getFileNameAddType('ori')}"/>

    </div>

    <div class="item-panel">

        <div class="panel-heading">
            <div class="line"></div>
            <div class="info">
                <p class="title">${product.title}</p>
                <div class="viewcount">
                    <i class="icon-eye"></i>
                    <span><fmt:formatNumber value="${product.viewCount}" type="currency" currencySymbol="" maxFractionDigits="0"/></span>
                </div>
            </div>
        </div>

        <div class="panel-item">

            <c:forEach items="${points}" var="point" varStatus="status">

                <!-- items -->
                <div class="items">

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
                        </c:if>

                        <div class="item" <c:if test="${not empty item.link}">style="cursor:pointer;" onclick="openLink('${item.link}');"</c:if>>
                            <div class="pic"><img src="${baseUrl}/resources/uploads${item.thumbUrl}"/></div>
                            <div class="colors">
                                <c:forEach items="${item.colorProperties}" var="color" varStatus="colorStatus">
                                    <c:if test="${colorStatus.count <= 3}">
                                        <c:set var="colorTop" value="${48 - (colorStatus.index * 16)}"/>
                                        <c:if test="${fn:length(item.colorProperties) > 3}">
                                            <c:set var="colorTop" value="${32 - (colorStatus.index * 16)}"/>
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

</section>

