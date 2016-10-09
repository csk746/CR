package kr.co.codiyrabbit.admin;

import kr.co.codiyrabbit.biz.category.domain.Category;
import kr.co.codiyrabbit.biz.category.domain.CategorySearch;
import kr.co.codiyrabbit.biz.category.service.CategoryService;
import kr.codeblue.common.result.JsonResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping(value = "/category")
public class CategoryController extends BaseAdminController {

    @Autowired
    CategoryService categoryService;

    /**
     * 메인 페이지
     * @return
     */
    @RequestMapping(value = "")
    public String index(Model model){
        model.addAttribute("category", new Category());
        return "category/index";
    }

    /**
     * (JSON) 카테고리 리스트
     * @param search
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    public JsonResult list(CategorySearch search){
        JsonResult jsonResult = new JsonResult();
        try {
            search.setOrderBy("ORDER BY T1.idx ASC");
            jsonResult.putData("categories", categoryService.getAll(search));
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }

    /**
     * (JSON) 카테고리 저장
     * @param category
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public JsonResult save(Category category){
        JsonResult jsonResult = new JsonResult();
        try {

            CategorySearch search = new CategorySearch();
            search.setDepth(category.getDepth());
            search.setName(category.getName());
            search.setParentId(category.getParentId());
            if( categoryService.getAll(search).size() > 0 ){
                return new JsonResult(false, "exist");
            }

            categoryService.save(category);
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }

    /**
     * (JSON) 카테고리 수정
     * @param category
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public JsonResult update(Category category){
        JsonResult jsonResult = new JsonResult();
        try {
            categoryService.update(category);
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }

    /**
     * (JSON) 카테고리 순서 저장
     * @param search
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/saveIndex", method = RequestMethod.POST)
    public JsonResult saveIndex(@RequestBody CategorySearch search){
        JsonResult jsonResult = new JsonResult();
        try {
            categoryService.updateAllByIndex(search);
            jsonResult.setResult(true);
        } catch(Exception e) {
            jsonResult.putData("error", e);
            e.printStackTrace();
        }

        return jsonResult;
    }

    /**
     * (JSON) 카테고리 삭제
     * @param category
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/remove", method = RequestMethod.POST)
    public JsonResult remove(Category category){
        JsonResult jsonResult = new JsonResult();
        try {
            CategorySearch search = new CategorySearch();
            search.setParentId(category.getId());
            List<Category> subList = categoryService.getAll(search);

            if(CollectionUtils.isEmpty(subList)){
                categoryService.remove(category);
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
