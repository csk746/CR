package kr.co.codiyrabbit.biz.member.repository;

import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.co.codiyrabbit.biz.member.domain.MemberSearch;
import kr.codeblue.core.BaseRepository;
import org.springframework.stereotype.Component;

@Component
public interface MemberRepository extends BaseRepository<Member, MemberSearch> {

    public String findAllRole(Member member);
    public Member findOneByLoginId(String loginId);
}
