package kr.co.codiyrabbit.biz.product.domain;

import kr.co.codiyrabbit.biz.member.domain.Member;
import lombok.Data;
import org.springframework.util.CollectionUtils;

import java.util.Date;
import java.util.List;

@Data
public class Product {

    long id;
    long memberId;
    long viewCount;
    String code;
    String title;
    String description;
    String isDelete;
    Date createDatetime;

    ProductImage mainImage;
    ProductImage captureImage;
    ProductImage originalImage;

    String memberNickName;
    List<ProductImage> images;
    List<ProductPoint> points;

    public Product(){}
    public Product(long id){
        this.id = id;
    }

    public ProductImage getMainImage(){
        if( mainImage == null && !CollectionUtils.isEmpty(images)){
            for(ProductImage image: images){
                if( image.type.equals( "MAIN" ) ){
                    return image;
                }
            }
        }
        return mainImage;
    }

    public ProductImage getCaptureImage(){
        if( captureImage == null && !CollectionUtils.isEmpty(images)){
            for(ProductImage image: images){
                if( image.type.equals( "CAPTURE" ) ){
                    return image;
                }
            }
        }
        return captureImage;
    }

    public ProductImage getOriginalImage(){
        if( captureImage == null && !CollectionUtils.isEmpty(images)){
            for(ProductImage image: images){
                if( image.type.equals( "ORIGINAL" ) ){
                    return image;
                }
            }
        }
        return originalImage;
    }
}
