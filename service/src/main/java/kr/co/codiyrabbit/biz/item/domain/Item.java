package kr.co.codiyrabbit.biz.item.domain;

import kr.co.codiyrabbit.biz.property.domain.Property;
import lombok.Data;
import org.apache.commons.io.FilenameUtils;

import java.util.Date;
import java.util.List;

@Data
public class Item {

    long id;
    String title;
    String name;
    int price;
    String link;
    String thumbName;
    String thumbPath;
    String isDelete;
    String category;
    String colorProperty;
    String detailProperty;
    String normalProperty;
    Date createDatetime;

    String isPublish;
    long useCount;

    long pointId;

    List<Property> colorProperties;

    public Item(){}
    public Item(long id){
        this.id = id;
    }

    public String getThumbUrl(){
        if( thumbName != null && thumbPath != null ){
            return thumbPath + "/" + thumbName;
        }
        return null;
    }

    public String getThumbSUrl(){
        if( thumbName != null && thumbPath != null ){
            return thumbPath + "/" + FilenameUtils.removeExtension(thumbName) + "-thumb." + FilenameUtils.getExtension(thumbName);
        }
        return null;
    }
}
