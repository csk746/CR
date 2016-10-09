package kr.co.codiyrabbit.biz.member.service;

import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.co.codiyrabbit.biz.member.domain.MemberSearch;
import kr.co.codiyrabbit.biz.member.repository.MemberRepository;
import kr.codeblue.core.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MemberService implements BaseService<Member, MemberSearch> {

    @Autowired
    private MemberRepository memberRepository;

    @Override
    public Member get(Member obj) {
        return memberRepository.findOne(obj);
    }

    @Override
    public List<Member> getList(MemberSearch search) {
        search.setTotal( memberRepository.findListTotal(search) );
        return memberRepository.findList(search);
    }

    @Override
    public long getListTotal(MemberSearch search) {
        return memberRepository.findListTotal(search);
    }

    @Override
    public List<Member> getAll(MemberSearch search) {
        return memberRepository.findAll(search);
    }

    @Override
    public void save(Member obj) {
        if( obj.getId() == 0 ){
            memberRepository.insert(obj);
        } else {
            memberRepository.update(obj);
        }
    }

    @Override
    public void update(Member obj) {
        memberRepository.update(obj);
    }

    @Override
    public void remove(Member obj) {
        memberRepository.delete(obj);
    }

    public Member getByLoginId(String loginId) {
        return memberRepository.findOneByLoginId(loginId);
    }
}
