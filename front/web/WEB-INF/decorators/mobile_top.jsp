<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<section class="gnb">
    <div class="logo"><a href="<spring:url value="/m"/>"><img width="110" height="22" src="${baseUrl}/resources/images/m/logo.png"/></a></div>
    <a id="feedBackBtn" href="<spring:url value="/m/feedback"/>" class="feedback-btn">피드백</a>
</section>