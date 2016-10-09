package kr.co.codiyrabbit.biz.product.domain;

import com.google.common.io.Files;
import lombok.Data;
import org.apache.commons.io.FilenameUtils;

import java.util.Date;

@Data
public class ProductImage {

    public enum TYPE { MAIN, CAPTURE }

    long id;
    long productId;
    String fileName;
    String filePath;
    int width;
    int height;
    String type;
    Date createDatetime;

    String viewImageId;     // view 단에서 생성한 가상 아이디

    public String getThumbName(){
        if( fileName != null ){
            return FilenameUtils.removeExtension(fileName) + "-thumb.jpg";
        }
        return null;
    }

    public float getRatio(){
        if (getRatioType().equals("width")) {
            return (Math.round((width/height)*100)/100);
        } else {
            return (Math.round((height/width)*100)/100);
        }
    }

    public String getRatioType(){
        if( width > height ){
            return "width";
        }
        return "height";
    }

    public String getFileNameAddType(String type){
        if( fileName != null ){
            return Files.getNameWithoutExtension(fileName) + "-" + type + "." + Files.getFileExtension(fileName);
        }
        return null;
    }

}
