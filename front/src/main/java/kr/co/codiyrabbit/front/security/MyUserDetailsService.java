package kr.co.codiyrabbit.front.security;

import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.co.codiyrabbit.biz.member.repository.MemberRepository;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MyUserDetailsService implements UserDetailsService {
		
	private Logger log = Logger.getLogger(getClass());
	public LoginMember loginMember = null;
	
	@Value("#{serviceProp['base.url']}")
	public String baseUrl;
	
	@Autowired
	private MemberRepository memberRepository;
	
	@Override
	public UserDetails loadUserByUsername(String username)
			throws UsernameNotFoundException {
		
		boolean accountNonExpired = true;
		boolean credentialsNonExpired = true;
		boolean accountNonLocked = true;
		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		
		try{
			Member member = memberRepository.findOneByLoginId(username);
			
			List<String> roles = null;
			
			if( member == null ){
				throw new Exception();
			} else {
				String role = member.getRole();
				if( role != null ){
					roles = Arrays.asList( role.split(",") );
					member.setRoles( roles );
				}
			}
			
			//권한 설정
			if( !CollectionUtils.isEmpty( roles ) ){
				for(String role : member.getRoles()){
					authorities.add(new SimpleGrantedAuthority( role ));
				}
				authorities.add(new SimpleGrantedAuthority( "ROLE_ANONYMOUS" ));
				log.debug("로그인 회원 권한들 : " + roles);
			}
			
			loginMember = new LoginMember(member, true, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
			
		} catch(Exception e){
			e.printStackTrace();
			throw new UsernameNotFoundException("User Not Founded");
		}
		
		return loginMember;
	}
	
	public LoginMember getLoginMember(){
		return loginMember;
	}
}
