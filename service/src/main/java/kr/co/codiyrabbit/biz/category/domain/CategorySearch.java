package kr.co.codiyrabbit.biz.category.domain;

import kr.codeblue.core.BaseSearch;
import lombok.Data;

import java.util.List;

@Data
public class CategorySearch extends BaseSearch {

    String name;
    Integer depth;
    Long parentId;
    Integer idx;

    List<Category> list;

}
