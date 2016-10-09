<jsp:directive.page contentType="text/html;charset=UTF-8"/>
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>
<html>
<head>
    <script type="text/javascript"
            src="${baseUrl}/resources/scripts/jquery-fakeform/jquery-fakeform-0.5.min.js"></script>
    <script type="text/javascript"
            src="${baseUrl}/resources/scripts/libs/jquery.smooth-scroll.min.js"></script>

    <link href="${baseUrl}/resources/scripts/jquery-fakeform/fakeform.css" rel="stylesheet">

    <script>
        window.gaObj = {
            hitType: 'pageview',
            page: '/main',
            title: '(모바일) 메인'
        };

        window.isAutoLoader = false;

        // 바로보기 (모바일 경우 이동)
        if("${viewId}" != "" && isMobile.any()){
            location.href = baseUrl + "/m/codiynavi/${viewId}";
        }

        $(document).ready(function () {
            $("select").fakeform();

            $("#orderBy").change(function () {
                if( $("#orderBy").val() == "" ){
                    location.href = "<spring:url value="/m/main"/>";
                } else {
                    $("#search").submit();
                }
            });

            $(".item").click(function(){
                location.href = baseUrl + "/m/codiynavi/" + $(this).data("id");
            });
        });

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

        <div class="items">

            <c:forEach items="${products}" var="product" varStatus="status">

                <c:set var="marginRight" value="15px"/>
                <c:if test="${status.count % 5 == 0}">
                    <c:set var="marginRight" value="0px"/>
                </c:if>

                <!-- item -->
                <div class="item" data-id="${product.id}" data-code="${product.code}">
                    <div class="pic">
                        <img src="<spring:url value="/resources/uploads${product.mainImage.filePath}/${product.mainImage.fileName}"/>"/>
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
                                <span><fmt:formatNumber value="${product.viewCount}" type="currency" currencySymbol=""/></span>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- //item -->

            </c:forEach>

        </div>

    </section>

</body>
</html>
