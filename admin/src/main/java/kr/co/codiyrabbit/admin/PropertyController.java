package kr.co.codiyrabbit.admin;

import kr.co.codiyrabbit.biz.property.domain.Property;
import kr.co.codiyrabbit.biz.property.domain.PropertySearch;
import kr.co.codiyrabbit.biz.property.service.PropertyService;
import kr.codeblue.common.result.JsonResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/property")
public class PropertyController extends BaseAdminController {

    @Autowired
    PropertyService propertyService;

    /**
     * (JSON) 속성 저장
     * @param property
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public JsonResult save(Property property){
        JsonResult jsonResult = new JsonResult();
        try {

            // 중복 이름 제거
//            PropertySearch search = new PropertySearch();
//            search.setType(property.getType());
//            search.setDepth(property.getDepth());
//            search.setName(property.getName());
//            if( propertyService.getAll(search).size() > 0 ){
//                return new JsonResult(false, "exist");
//            }

            propertyService.save(property);
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }

    /**
     * (JSON) 속성 수정
     * @param property
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public JsonResult update(Property property){
        JsonResult jsonResult = new JsonResult();
        try {
            propertyService.update(property);
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }


    /**
     * (JSON) 속성 리스트
     * @param search
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    public JsonResult list(PropertySearch search){
        JsonResult jsonResult = new JsonResult();
        try {
            search.setOrderBy("ORDER BY T1.id ASC");
            List<Property> propertyList = propertyService.getAll(search);

            // 일반 특성의 경우 하위 아이템을 같이 노출
            if( search.getType().equals( "NORMAL" ) ){
                for(Property property: propertyList){
                    PropertySearch ps = new PropertySearch();
                    ps.setDepth(2);
                    ps.setType("NORMAL");
                    ps.setParentId(property.getId());
                    property.setItems(propertyService.getAll(ps));
                }
            }

            jsonResult.putData("properties", propertyList);
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }

    /**
     * 특성 삭제
     * @param property
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/remove", method = RequestMethod.POST)
    public JsonResult remove(Property property){
        JsonResult jsonResult = new JsonResult();
        try {

            PropertySearch search = new PropertySearch();
            search.setParentId(property.getId());
            List<Property> subList = propertyService.getAll(search);

            if(CollectionUtils.isEmpty(subList)){
                propertyService.remove(property);
                jsonResult.setResult(true);
            } else {
                jsonResult.setMessage("subItem");
            }

        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }
        return jsonResult;
    }
}
