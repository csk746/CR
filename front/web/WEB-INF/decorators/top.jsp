<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<section class="gnb">
    <div class="gnb-wrap">
        <div class="logo"><a href="<spring:url value="/"/>"><img src="${baseUrl}/resources/images/logo.png"/></a></div>
        <a id="feedBackBtn" href="#" class="feedback-btn">피드백</a>

        <div class="feedback">
            <form id="feedbackFrm" method="post" onsubmit="return false;" action="<spring:url value="/feedback/send"/>">
                <textarea id="feedBackContent" name="contents" required="required"></textarea>
                <input id="feedBackEmail" name="email" type="text" required="required" />
                <a href="#" id="feedBackCloseBtn" class="close-btn"></a>
                <a href="#" id="feedBackSendBtn" class="send-btn"></a>
            </form>
        </div>

        <script>
            $(function(){
                $("#feedBackBtn").click(function(){
                   $(".feedback").fadeIn();
                });

                $("#feedBackCloseBtn").click(function(){
                    $(".feedback").fadeOut();
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
    </div>
</section>