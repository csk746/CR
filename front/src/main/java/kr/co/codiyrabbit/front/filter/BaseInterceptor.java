package kr.co.codiyrabbit.front.filter;

import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.co.codiyrabbit.front.security.LoginMember;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.util.ClassUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.resource.ResourceHttpRequestHandler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Created by taesuz on 2016. 7. 6..
 */
public class BaseInterceptor extends HandlerInterceptorAdapter {


    @Value("#{serviceProp['upload.webPath']}")
    public String uploadWebPath;

    @Value("#{serviceProp['environment']}")
    public String env;

    @Value("#{serviceProp['base.front.url']}")
    public String baseFrontUrl;

    @Value("#{serviceProp['base.admin.url']}")
    public String baseAdminUrl;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (ClassUtils.isAssignableValue(ResourceHttpRequestHandler.class, handler)) {
            return true;
        }

        HttpSession session = request.getSession();
        SecurityContext securityContext = (SecurityContext) session.getAttribute("SPRING_SECURITY_CONTEXT");
        LoginMember principal = null;
        Member member = null;

        if( securityContext != null ){
            Authentication authentication = securityContext.getAuthentication();
            principal = (LoginMember) authentication.getPrincipal();
            member = principal.getMember();
            request.setAttribute("loginMember", member);
        }

        String servletPath = request.getServletPath();
        if( !servletPath.startsWith("/main") && servletPath.startsWith("/m") ){
            request.setAttribute("isMobile", true);
        }

        request.setAttribute("uploadWebPath", uploadWebPath);
        request.setAttribute("env", env);
        request.setAttribute("baseFrontUrl", baseFrontUrl);
        request.setAttribute("baseAdminUrl", baseAdminUrl);

        return super.preHandle(request, response, handler);
    }
}
