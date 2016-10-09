package kr.co.codiyrabbit.biz.product.domain;

import kr.co.codiyrabbit.biz.item.domain.Item;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class ProductPoint {

    long id;
    long productId;
    long productImageId;
    String name;
    int left;
    int top;
    String type;
    String color;
    Date createDatetime;

    String viewImageId;     // view 단에서 생성한 가상 아이디
    List<Item> items;

    String isPublish;     // join 하기 위해서
}
