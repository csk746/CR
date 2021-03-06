<jsp:directive.page contentType="text/html;charset=UTF-8" />
<jsp:directive.include file="/WEB-INF/include/taglib.jsp" />

<!-- header section start-->
 <div class="header-section">

     <!--logo and logo icon start-->
     <div class="logo dark-logo-bg hidden-xs hidden-sm">
         <a href="<spring:url value="/main"/>">
             <img src="${baseUrl }/resources/images/logo.png" alt="">
             <!--<i class="fa fa-maxcdn"></i>-->
             <%--<span class="brand-name">Codiyrabbit Admin</span>--%>
         </a>
     </div>

     <div class="icon-logo dark-logo-bg hidden-xs hidden-sm">
         <a href="index.html">
             <img src="${slickLabHome}/img/logo-icon.png" alt="">
             <!--<i class="fa fa-maxcdn"></i>-->
         </a>
     </div>
     <!--logo and logo icon end-->

     <!--toggle button start-->
     <a class="toggle-btn"><i class="fa fa-outdent"></i></a>
     <!--toggle button end-->

     <div class="notification-wrap">


      <!--right notification start-->
      <div class="right-notification">
          <ul class="notification-menu">
              <!-- <li>
                  <form class="search-content" action="index.html" method="post">
                      <input type="text" class="form-control" name="keyword" placeholder="Search...">
                  </form>
              </li> -->

              <li>
                  <a href="javascript:;" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                      <%-- <img src="${slickLabHome}/img/avatar-mini.jpg" alt=""> --%>${loginAdmin.name }
                      <span class=" fa fa-angle-down"></span>
                  </a>
                  <ul class="dropdown-menu dropdown-usermenu purple pull-right">
                      <%--<li>--%>
                          <%--<a href="<spring:url value="/modify"/>">--%>
                              <%--<span>회원정보 수정</span>--%>
                          <%--</a>--%>
                      <%--</li>--%>
                      <li><a href="${baseUrl }/logout"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
                  </ul>
              </li>
              <!-- 
                 <li>
                     <div class="sb-toggle-right">
                         <i class="fa fa-indent"></i>
                     </div>
                 </li>
-->
          </ul>
      </div>
      <!--right notification end-->
     </div>

 </div>
 <!-- header section end-->
