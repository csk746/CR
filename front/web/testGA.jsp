<%@ page import="com.dmurph.tracking.AnalyticsConfigData" %>
<%@ page import="com.dmurph.tracking.JGoogleAnalyticsTracker" %>
<%
    String referer = request.getHeader("referer");
    String host = request.getRemoteHost();

    // GA
    AnalyticsConfigData analyticsConfigData = new AnalyticsConfigData("UA-81214290-1");
    JGoogleAnalyticsTracker tracker = new JGoogleAnalyticsTracker(analyticsConfigData, JGoogleAnalyticsTracker.GoogleAnalyticsVersion.V_4_7_2);

    tracker.trackPageViewFromReferrer("/share/codiynavi/116", "test", host, referer, referer);
%>