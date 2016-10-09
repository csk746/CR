package kr.co.codiyrabbit.admin.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;

public class MyAuthenticationProvider implements AuthenticationProvider {

	@Autowired
	private MyUserDetailsService userDetailsService;
	
//	@Autowired
//	private MemberRepository memberRepository;
//	
//	@Autowired
//	private MemberLogRepository memberLogRepository;

	@Override
	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		
		String username = authentication.getName();
        String password = (String) authentication.getCredentials();
        ShaPasswordEncoder md5PasswordEncoder = new ShaPasswordEncoder();
		
		WebAuthenticationDetails wad = (WebAuthenticationDetails) authentication.getDetails();
        String userIPAddress         = wad.getRemoteAddress();
//      boolean isAuthenticatedByIP  = false;

        LoginMember user = (LoginMember) userDetailsService.loadUserByUsername(username);
        
        if( user == null ){
        	throw new BadCredentialsException("Username not found.");
        }
        
        password = md5PasswordEncoder.encodePassword(password, null);
        if (!password.equals(user.getPassword())) {
            throw new BadCredentialsException("Wrong password.");
        }

        Authentication auth = new UsernamePasswordAuthenticationToken(user, password, user.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(auth);
        
        //로그인 로그 남기기
//        MemberLog memberLog = new MemberLog(user.getMember().getId(), CodeMemberLog.LOGIN, userIPAddress);
//        memberLogRepository.insert(memberLog);
        
        //최근 로그인 업데이트
//        Member lastLoginMember = new Member(user.getMember().getId());
//        lastLoginMember.setLastLoginDatetime(new Date());
//        memberRepository.update(lastLoginMember);
        
        return auth;
	}

	@Override
	public boolean supports(Class<? extends Object> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}
	
}
