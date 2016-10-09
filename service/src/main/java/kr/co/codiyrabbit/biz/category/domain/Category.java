package kr.co.codiyrabbit.biz.category.domain;

import lombok.Data;

import java.util.Date;

@Data
public class Category {

    long id;
    String name;
    int depth;
    long parentId;
    int idx;
    Date createDatetime;

}
