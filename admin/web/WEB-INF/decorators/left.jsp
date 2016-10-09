<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

		<!-- sidebar left start-->
        <div class="sidebar-left">
            <!--responsive view logo start-->
            <div class="logo dark-logo-bg visible-xs-* visible-sm-*">
                <a href="<spring:url value="/main"/>">
                    <img src="${baseUrl }/resources/images/logo.png" alt="">
                    <!--<i class="fa fa-maxcdn"></i>-->
                    <%--<span class="brand-name">Codiyrabbit Admin</span>--%>
                </a>
            </div>
            <!--responsive view logo end-->

            <div class="sidebar-left-info">
                <!-- visible small devices start-->
                <div class=" search-field">  </div>
                <!-- visible small devices end-->

                <!--sidebar nav start-->
                <ul class="nav nav-pills nav-stacked side-navigation" id="adminLeftMenu">

                    <!-- badge : <span class="badge noti-arrow bg-success pull-right">3</span> -->
                    <!-- label : <span class="label noti-arrow bg-danger pull-right">4 Unread</span> -->
                    
					<li class="menu-single">
                        <sec:authorize ifAnyGranted="ROLE_ADMIN,ROLE_MAKER">
                            <a href="<spring:url value="/product/products"/>"><i class="fa fa-male"></i> <span>코디 관리</span></a>
                        </sec:authorize>
                    </li>
                    <li class="menu-single">
                        <sec:authorize ifAnyGranted="ROLE_ADMIN,ROLE_MAKER">
                            <a href="<spring:url value="http://google.co.kr/analytics"/>" target="_blank"><i class="fa fa-bar-chart-o"></i> <span>통계</span></a>
                        </sec:authorize>
                    </li>
                    <li class="menu-single">
                        <sec:authorize ifAnyGranted="ROLE_ADMIN">
                            <a href="<spring:url value="/item/items"/>"><i class="fa fa-cube"></i> <span>아이템 관리</span></a>
                        </sec:authorize>
                    </li>
                    <li class="menu-single">
                        <sec:authorize ifAnyGranted="ROLE_ADMIN">
                            <a href="<spring:url value="/category"/>"><i class="fa fa-th-list"></i> <span>카테고리 관리</span></a>
                        </sec:authorize>
                    </li>
                    <li class="menu-single">
                        <sec:authorize ifAnyGranted="ROLE_ADMIN">
                            <a href="<spring:url value="/member/members"/>"><i class="fa fa-group"></i> <span>회원 관리</span></a>
                        </sec:authorize>
                    </li>

                    <%--<li class="menu-list">--%>
                        <%--<a href="">--%>
                        	<%--<i class="fa fa-mobile"></i>서비스--%>
                        <%--</a>--%>
                        <%--<ul class="child-list">--%>
                            <%--<li><a href="<spring:url value="/service/updateCheck"/>">앱 업데이트 및 점검</a></li>--%>
                            <%--<li><a href="<spring:url value="/service/push/form"/>">푸시 관리</a></li>--%>
                            <%--<li><a href="<spring:url value="/board/boards?code1=A01&code2=A01007"/>">앱 공지사항</a></li>--%>
                            <%--<li><a href="<spring:url value="/member/members"/>">회원 관리</a></li>--%>
                            <%--<li><a href="<spring:url value="/service/etc"/>">기타 관리</a></li>--%>
                            <%--<li><a href="<spring:url value="/bot/account"/>">채팅 봇 관리</a></li>--%>
                            <%--<li><a href="<spring:url value="/board/boards?code1=A01&code2=A01008"/>">이벤트 관리</a></li>--%>
                        <%--</ul>--%>
                    <%--</li>--%>
                    
                </ul>
                <!--sidebar nav end-->

            </div>
        </div>
        <!-- sidebar left end-->
