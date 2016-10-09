package kr.co.codiyrabbit.biz.member.domain;

import kr.codeblue.core.BaseSearch;
import lombok.Data;

@Data
public class MemberSearch extends BaseSearch {

    String loginId;
    String password;
    String isAdmin;

}
