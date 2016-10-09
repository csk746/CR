<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />
<nav class="text-center">
	<ul class="pagination" id="pagingNoList">
		<li>
			<a href="#" aria-label="Previous" id="pagingPrevBtn" data-pno="${paging.prevPNo }" data-gno="${paging.prevGNo }">
				<span aria-hidden="true">Prev</span>
			</a>
		</li>

		<c:if test="${fn:length(paging.pagingNoOnlyList) == 0 }">
			<li class="active"><a href="#">1</a></li>
		</c:if>
		<c:if test="${fn:length(paging.pagingNoOnlyList) > 0 }">
			<c:forEach items="${paging.pagingNoOnlyList }" var="no">
				<c:if test="${paging.pageNo == no }">
					<li class="active"><a href="#">${no }</a></li>
				</c:if>
				<c:if test="${paging.pageNo != no }">
					<li>
						<%-- <a href="${paging.link1 }${no }${paging.link2 }">${no }</a> --%>
						<a href="#" data-pno="${no }" data-gno="${paging.pageGNo }">${no }</a>
					</li>
				</c:if>
			</c:forEach>
		</c:if>

		<li>
			<a href="#" aria-label="Next" id="pagingNextBtn" data-pno="${paging.nextPNo }" data-gno="${paging.nextGNo }">
				<span aria-hidden="true">Next</span>
			</a>
		</li>
	</ul>
</nav>
