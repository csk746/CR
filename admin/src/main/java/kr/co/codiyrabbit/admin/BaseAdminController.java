package kr.co.codiyrabbit.admin;

import kr.co.codiyrabbit.admin.security.LoginMember;
import kr.co.codiyrabbit.admin.security.MyUserDetailsService;
import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.codeblue.common.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.util.CollectionUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

public class BaseAdminController {
	
	@Autowired
	public HttpServletRequest request;
	
	@Autowired
	private MyUserDetailsService userDetailsService;
	
	//@Value("#{pathProp['upload.s3.environment']}")
	public String s3Environment = "real";

	@Autowired
	public FileUploadUtil fileUploadUtil;
	
	public boolean isLogin(HttpServletRequest request){
		HttpSession session = request.getSession();
		SecurityContext securityContext = (SecurityContext) session.getAttribute("SPRING_SECURITY_CONTEXT");
		
		if( securityContext != null && securityContext.getAuthentication() != null ){
			return true;
		}
		
		return false;
	}
	
	public Member getMember(HttpServletRequest request){
		HttpSession session = request.getSession();
		SecurityContext securityContext = (SecurityContext) session.getAttribute("SPRING_SECURITY_CONTEXT");
		LoginMember principal = null;
		Member member = null;
		
		if( securityContext != null ){
			Authentication authentication = securityContext.getAuthentication();
			principal = (LoginMember) authentication.getPrincipal();
			member = principal.getMember();
		}
		
		return member;
	}

	/**
	 * 로그아웃 처리
	 * @param response
	 */
	public void logout(HttpServletResponse response){
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    SecurityContextLogoutHandler ctxLogOut = new SecurityContextLogoutHandler();
        ctxLogOut.logout(request, response, auth); // concern you
	}
	
	/**
	 * 세션에 있는 회원정보를 DB에 있는 정보로 갱신한다.
	 * @param member
	 */
	public void refreshSession(Member member){
		UserDetails userDetails = userDetailsService.loadUserByUsername(member.getEmail());
		Authentication authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
		LoginMember loginMember = (LoginMember)authentication.getPrincipal();
		request.getSession().setAttribute("loginAdmin", loginMember.getMember());
		SecurityContextHolder.getContext().setAuthentication(authentication);
	}
	
}