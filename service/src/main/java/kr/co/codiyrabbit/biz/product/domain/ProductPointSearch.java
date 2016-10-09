package kr.co.codiyrabbit.biz.product.domain;

import kr.codeblue.core.BaseSearch;
import lombok.Data;

import java.util.List;

@Data
public class ProductPointSearch extends BaseSearch {

    Long productId;
    List<ProductPointItem> pointItems;
    String isPublish;

}
