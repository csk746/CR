<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<html>
<head>
<title>Home</title>

<script type="text/javascript">

	// 메뉴 활성 [1뎁스, 2뎁스] : 1부터 카운트
	var activeMenus = [5];

	$(document).ready(function(){
		$("#memberFormToggleBtn").click(function(){
			$(this).blur();
			if( $("#frm").is(":visible") ){
				$("#frm").slideUp();
				$(this).find(".fa").removeClass("fa-angle-down");
				$(this).find(".fa").addClass("fa-angle-up");
			} else {
				$("#frm").resetForm();
				$("#frm").slideDown();
				$(this).find(".fa").removeClass("fa-angle-up");
				$(this).find(".fa").addClass("fa-angle-down");
			}
		});

		// 저장
		$("#saveBtn").click(function(){

			if( !ValidateUtil.requiredCheck("#frm") ) return false;

			$("#frm").ajaxSubmit(function(res){
				if( res.result ){
					alert("저장이 완료 되었습니다.");
					location.reload();

				} else {
					if( res.message == "exist" ) {
						alert("중복되는 아이디입니다.");
						$("#loginId").focus();
					}
					else {
						alert("저장이 실패하였습니다.");
					}
				}

			});
		});

		// 삭제
		$("#removeBtn").click(function(){
			var search = {
				ids: []
			};

			$(".cbMember:checked").each(function(){
				search.ids.push($(this).parents("tr").data("id"));
			});

			if( search.ids.length == 0 ){
				alert("삭제할 회원을 선택해주세요.");
				return;
			}

			if( !confirm("삭제하시겠습니까?") ) return;

			$.ajax({
				url: baseUrl + "/member/removeForChoice",
				data: JSON.stringify(search),
				type: "POST",
				dataType:"json",
				contentType:'application/json',
				success: function(res){
					console.dir(res.data);
					if( res.result ){
						alert("회원 삭제가 완료 되었습니다.");
						location.reload();
					} else {
						alert("회원 삭제가 실패 하였습니다.");
					}
				},
				error: function(){
					alert("회원 삭제가 실패 하였습니다.");
				}
			});
		});
	});
	
</script>

</head>
<body>

	<!-- page head start-->
	<div class="page-head">
	    <h3>
	        페이지 메인 타이틀
	    </h3>
	    <span class="sub-title">홈 > </span>
	</div>
	<!-- page head end-->
	
	<!--body wrapper start-->
	<div class="wrapper">

		<section class="panel">
			<div class="panel-heading">
				<h4>
					<a href="#" id="memberFormToggleBtn">
						회원 등록
						<span class="fa fa-angle-up"></span>
					</a>
				</h4>
			</div>
			<div class="panel-body">
				<form:form id="frm" commandName="member" method="post" action="save" role="form" style="display:none;">

					<div class="form-group">
						<label for="role">권한</label>
						<form:select path="role" class="form-control">
							<form:option value="ROLE_ADMIN" label="관리자"/>
							<form:option value="ROLE_MAKER" label="메이커"/>
							<form:option value="ROLE_MEMBER" label="일반회원"/>
						</form:select>
					</div>

					<div class="form-group">
						<label for="loginId">아이디</label>
						<form:input path="loginId" class="form-control" required="required"/>
					</div>

					<div class="form-group">
						<label for="password">비밀번호</label>
						<form:password path="password" class="form-control" required="required"/>
					</div>

					<div class="form-group">
						<label for="nickname">닉네임</label>
						<form:input path="nickname" class="form-control" required="required"/>
					</div>

					<div class="form-group">
						<label for="sex">성별</label>
						<form:select path="sex" class="form-control">
							<form:option value="M" label="남"/>
							<form:option value="F" label="여"/>
						</form:select>
					</div>

					<div class="form-group">
						<label for="email">이메일</label>
						<form:input path="email" class="form-control" required="required"/>
					</div>

					<div class="form-group">
						<label for="nickname">전화번호</label>
						<form:input path="phone" class="form-control" required="required"/>
					</div>

					<div class="form-group">
						<label for="nickname">SNS</label>
						<form:select path="snsType" class="form-control">
							<form:option value="TWITTER" label="트위터"/>
							<form:option value="FACEBOOK" label="페이스북"/>
							<form:option value="INSTAGRAM" label="인스타그램"/>
							<form:option value="VINGLE" label="빙글"/>
						</form:select>
					</div>

					<div class="form-group">
						<label for="snsId">SNS ID</label>
						<form:input path="snsId" class="form-control" required="required"/>
					</div>

					<div class="form-group">
						<label for="age">나이</label>
						<form:input path="age" class="form-control" required="required"/>
					</div>

					<div class="form-group">
						<label for="area">지역</label>
						<form:input path="area" class="form-control" required="required"/>
					</div>

					<a class="btn btn-primary" id="saveBtn">저장</a>
				</form:form>
			</div>
		</section>

		<section class="panel">
			<div class="panel-heading">
				<a href="#" id="removeBtn" class="btn btn-danger">삭제</a>
				<br/>
			</div>

			<div class="panel-body table-responsive">
				<table class="table member-form">
					<thead>
						<tr>
							<th></th>
							<th>권한</th>
							<th>아이디</th>
							<%--<th>비밀번호</th>--%>
							<th>닉네임</th>
							<th>성별</th>
							<th>이메일</th>
							<th>전화번호</th>
							<th>SNS</th>
							<th>SNS ID</th>
							<th>나이</th>
							<th>지역</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${members}" var="item">
							<tr data-id="${item.id}">
								<td><input type="checkbox" class="iCheck-red cbMember" /></td>
								<td>
									<c:choose>
										<c:when test="${fn:contains(item.roles, 'ROLE_MAKER')}">메이커</c:when>
										<c:when test="${fn:contains(item.roles, 'ROLE_ADMIN')}">관리자</c:when>
										<c:when test="${fn:contains(item.roles, 'ROLE_MEMBER')}">일반회원</c:when>
										<c:otherwise>알수없음</c:otherwise>
									</c:choose>
								</td>
								<td>${item.loginId}</td>
								<%--<td>암호화되어 알수없음</td>--%>
								<td>${item.nickname}</td>
								<td>${item.sex == 'M' ? '남자' : '여자'}</td>
								<td>${item.email}</td>
								<td>${item.phone}</td>
								<td>${item.snsType}</td>
								<td>${item.snsId}</td>
								<td>${item.age}</td>
								<td>${item.area}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</section>
	</div>
	<!--body wrapper end-->

</body>
</html>
