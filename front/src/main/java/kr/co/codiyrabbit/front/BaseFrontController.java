package kr.co.codiyrabbit.front;

import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.co.codiyrabbit.biz.product.domain.Product;
import kr.co.codiyrabbit.biz.product.service.ProductService;
import kr.co.codiyrabbit.front.security.LoginMember;
import kr.co.codiyrabbit.front.security.MyUserDetailsService;
import kr.codeblue.common.util.FileUploadUtil;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BaseFrontController {
	
	@Autowired
	public HttpServletRequest request;
	
	@Autowired
	private MyUserDetailsService userDetailsService;
	
	//@Value("#{pathProp['upload.s3.environment']}")
	public String s3Environment = "real";

	@Autowired
	public FileUploadUtil fileUploadUtil;

	@Autowired
	ProductService productService;

	@Value("#{serviceProp['base.admin.url']}")
	public String baseAdminUrl;

	@Value("#{serviceProp['base.front.url']}")
	public String baseFrontUrl;

	@Value("#{serviceProp['mail.gmail.email']}")
	public String mailAccount;
	
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

	/**
	 * 뷰 카운트 증가
	 * @param id
     */
	public void addViewCountCookie(long id, HttpServletResponse response){
		Product product = new Product(id);
		boolean isViewAdd = false;
		Cookie codiynaviViewId = new Cookie("codiynaviViewId", "");
		codiynaviViewId.setPath("/");
		// view 증가
		for(Cookie cookie: request.getCookies()){
			if( StringUtils.equals("codiynaviViewId", cookie.getName()) ){
				if(new String(Base64.decodeBase64(cookie.getValue())).indexOf( product.getId() + "," ) > -1 ){
					isViewAdd = true;
					break;
				} else {
					codiynaviViewId.setValue( Base64.encodeBase64String((cookie.getValue() + product.getId() + ",").getBytes()) );
				}
			} else {
				isViewAdd = false;
				codiynaviViewId.setValue( Base64.encodeBase64String((product.getId() + ",").getBytes()) );
			}
		}
		if( !isViewAdd ){
			response.addCookie(codiynaviViewId);
			productService.saveViewCount(product.getId());
		}
	}

	/**
	 * 뷰 카운트 증가
	 * @param id
	 */
	public void addViewCountSession(long id){
		Product product = new Product(id);
		boolean isViewAdd = false;

		HttpSession session = request.getSession();
		String viewCount = "";
		if( session.getAttribute("codiynaviViewId") != null ){
			viewCount = (String)session.getAttribute("codiynaviViewId");
		}

		// view 증가
		if( !StringUtils.equals(viewCount, "") ){
			if(viewCount.indexOf( product.getId() + "," ) > -1 ){
				isViewAdd = true;
			} else {
				viewCount += product.getId() + ",";
			}
		} else {
			isViewAdd = false;
			viewCount += product.getId() + ",";
		}

		if( !isViewAdd ){
			session.setAttribute("codiynaviViewId", viewCount);
			productService.saveViewCount(product.getId());
		}
	}
}