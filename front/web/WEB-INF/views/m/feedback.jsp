<jsp:directive.page contentType="text/html;charset=UTF-8"/>
<jsp:directive.include file="/WEB-INF/include/taglib.jsp"/>
<html>
<head>
    <script>
        window.gaObj = {
            hitType: 'pageview',
            page: '/main',
            title: '(모바일) 피드백'
        };

        $(document).ready(function () {
            $("#feedBackCloseBtn").click(function(){
                location.href = "<spring:url value="/m/main"/>";
            });

            $("#feedBackSendBtn").click(function(){
                if( ValidateUtil.isBlank("feedBackContent", "피드백 내용을 입력해주세요.", true) ) return false;
                if( ValidateUtil.isBlank("feedBackEmail", "피드백 이메일을 입력해주세요.", true) ) return false;
                if( !ValidateUtil.isEmail($("#feedBackEmail").val()) ){
                    alert("유효하지 않는 이메일입니다.");
                    $("#feedBackEmail").focus();
                    return false;
                }

                Loader.show();
                $("#feedbackFrm").ajaxSubmit(function(res){
                    if( res.result ){
                        alert("피드백 전송이 완료 되었습니다.");
                        $("#feedBackCloseBtn").click();
                        $("#feedbackFrm").resetForm();
                    } else {
                        alert("피드백 전송이 실패 하였습니다.");
                    }
                    Loader.hide();
                });

            });
        });
    </script>

</head>
<body>

<form id="feedbackFrm" method="post" action="<spring:url value="/feedback/send"/>">
    <div class="feedback">
        <div class="feedback-wrap">

            <img class="logo" src="${baseUrl}/resources/images/m/feedback-logo.png"/>

            <div class="text1">
                <p>코디래빗은 온라인 쇼핑의 불편한 점을 해결하고 있습니다.</p>
                <p>제휴문의 : codiyrabbit@gmail.com</p>
            </div>

            <div class="line"></div>

            <div class="text2">
                <p>불편하신 점이나, 추가되었으면 하는 기능이 있으신가요?</p>
                <p>부담없이 말씀해주세요! 매주 다섯 분에게 추첨을 통하여</p>
                <p>스타벅스 기프티콘을 드립니다!(제휴문의 가능)</p>
            </div>

            <div class="textarea">
                <textarea id="feedBackContent" name="contents"></textarea>
            </div>

            <div class="email-field">
                <div class="text"><label for="feedBackEmail">회신 이메일</label></div>
                <input type="text" id="feedBackEmail" name="email" />
            </div>

            <div class="buttons">
                <a href="#" id="feedBackCloseBtn" class="btn-close">최소</a>
                <a href="#" id="feedBackSendBtn" class="btn-send">제출하기</a>
            </div>

            <%--<form id="feedbackFrm" method="post" onsubmit="return false;" action="<spring:url value="/feedback/send"/>">--%>
                <%--<textarea id="feedBackContent" name="contents" required="required"></textarea>--%>
                <%--<input id="feedBackEmail" name="email" type="text" required="required" />--%>
                <%--<a href="#" id="feedBackCloseBtn" class="close-btn"></a>--%>
                <%--<a href="#" id="feedBackSendBtn" class="send-btn"></a>--%>
            <%--</form>--%>
        </div>
    </div>
</form>

</body>
</html>
