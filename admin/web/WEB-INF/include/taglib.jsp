<%@page import="java.util.HashMap"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- <%@ taglib prefix="cfn" uri="/WEB-INF/tlds/customFunction.tld" %> --%>
<%
pageContext.setAttribute("cr", "\r"); //Space
pageContext.setAttribute("cn", "\n"); //Enter
pageContext.setAttribute("crcn", "\r\n"); //Space, Enter

%>
<c:set var="serverName" value="<%=request.getServerName() %>" />
<c:set var="serverPort" value="" />
<c:if test="${serverPort != 80 }"><c:set var="serverPort" value="<%=':' + String.valueOf(request.getServerPort()) %>" /></c:if>
<c:set var="contextPath" value="<%=request.getContextPath() %>" />
<c:set var="baseUrl" value="http://${serverName }${serverPort }${contextPath }" />

<c:set var="slickLabHome" value="${baseUrl }/resources/slicklab" />
