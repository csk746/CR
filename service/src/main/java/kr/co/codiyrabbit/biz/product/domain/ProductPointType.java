package kr.co.codiyrabbit.biz.product.domain;

/**
 * Created by taesuz on 2016. 7. 16..
 */
public enum ProductPointType {

    SHORT("short"),
    LONG("long");

    private String name;

    private ProductPointType(){}

    private ProductPointType(String name){
        this.name = name;
    }

    public String getName(){
        return name;
    }

}
