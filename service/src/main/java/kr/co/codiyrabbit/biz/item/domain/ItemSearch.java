package kr.co.codiyrabbit.biz.item.domain;

import kr.codeblue.core.BaseSearch;
import lombok.Data;

import java.util.List;

@Data
public class ItemSearch extends BaseSearch {

    String category;
    String detailProperty;
    String normalProperty;
    String colorProperty;
    List<String> normalProperties;
    Long pointId;
    List<Long> pointIds;
    String isPublish;

}
