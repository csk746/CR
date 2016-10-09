package kr.co.codiyrabbit.admin;

import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.co.codiyrabbit.biz.member.domain.MemberSearch;
import kr.co.codiyrabbit.biz.member.service.MemberService;
import kr.codeblue.common.result.JsonResult;
import kr.codeblue.common.util.Paging;
import kr.codeblue.common.util.PagingUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping(value = "/member")
public class MemberController extends BaseAdminController {

    @Autowired
    MemberService memberService;

    @Autowired
    private ShaPasswordEncoder passwordEncoder;

    /**
     * 회원 리스트
     * @param search
     * @param model
     * @return
     */
    @RequestMapping(value = "/members", method = RequestMethod.GET)
    public String members(MemberSearch search, Model model){
        search.setOrderBy("ORDER BY T1.id ASC");
        search.setIsAdmin("N");
        List<Member> members = memberService.getAll(search);

        model.addAttribute("members", members);
        model.addAttribute("search", search);
        model.addAttribute("member", new Member());

//        PagingUtil.createBoardPaging(request, search);

        return "/member/members";
    }

    /**
     * (JSON) 회원 정보 처리
     * @param member
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public JsonResult memberSave(Member member){
        JsonResult jsonResult = new JsonResult();
        try {

            if( memberService.getByLoginId(member.getLoginId()) != null ){
                return new JsonResult(false, "exist");
            }

            if( StringUtils.isNotEmpty(member.getPassword()) ){
                member.setPassword( passwordEncoder.encodePassword(member.getPassword(), null) );
            }

            memberService.save(member);
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }

    /**
     * (JSON) 회원 삭제 처리
     * @param search
     * @param model
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/removeForChoice", method = RequestMethod.POST)
    public JsonResult removeForChoice(@RequestBody MemberSearch search, Model model){
        JsonResult jsonResult = new JsonResult();
        try {

            if( !CollectionUtils.isEmpty(search.getIds()) ){
                for(Long memberId : search.getIds()){
                    memberService.remove( new Member(memberId) );
                }
            }

            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }
}
