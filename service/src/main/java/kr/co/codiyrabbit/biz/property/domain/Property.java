package kr.co.codiyrabbit.biz.property.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class Property {

    public enum TYPE { DETAIL, NORMAL }

    long id;
    String type;
    String name;
    int depth;
    long parentId;
    Date createDatetime;

    List<Property> items;
    int subCount;

}
