package kr.co.codiyrabbit.biz.product.domain;

import kr.codeblue.core.BaseSearch;
import lombok.Data;

@Data
public class ProductSearch extends BaseSearch {

    String code;
    Long memberId;
    Long viewId;
    String title;
    String isDelete;

}
