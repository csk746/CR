package kr.co.codiyrabbit.front.security;

import kr.co.codiyrabbit.biz.member.domain.Member;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

/**
 * 사용자 로그인 회원
 * @author taesuz
 *
 */
@EqualsAndHashCode(callSuper=false)
@Data public class LoginMember extends User {
	
	private Member member;

	public LoginMember(String username, String password, boolean enabled,
			boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities) {
		super(username, password, enabled, accountNonExpired, credentialsNonExpired,
				accountNonLocked, authorities);
	}
	
	public LoginMember(Member member, boolean enabled,
			boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities) {
		super(String.valueOf(member.getId()), member.getPassword(), enabled, accountNonExpired, credentialsNonExpired,
				accountNonLocked, authorities);
		
		this.member = member;
	}

	private static final long serialVersionUID = 1L;

}

