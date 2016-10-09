package kr.co.codiyrabbit.biz.property.domain;

import kr.codeblue.core.BaseSearch;
import lombok.Data;

@Data
public class PropertySearch extends BaseSearch {

    String type;
    String name;
    Integer depth;
    Long parentId;
    Integer subCount;
}
