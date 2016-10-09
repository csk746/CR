package kr.co.codiyrabbit.admin;

import kr.co.codiyrabbit.biz.item.domain.Item;
import kr.co.codiyrabbit.biz.item.domain.ItemSearch;
import kr.co.codiyrabbit.biz.item.service.ItemService;
import kr.codeblue.common.result.FileUploadResult;
import kr.codeblue.common.result.JsonResult;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.awt.*;
import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/item")
public class ItemController extends BaseAdminController {

    @Autowired
    ItemService itemService;

    /**
     * 아이템 목록
     * @return
     */
    @RequestMapping(value = "/items")
    public String list(){
        return "item/items";
    }

    /**
     * 아이템 목록
     * @return
     */
    @RequestMapping(value = "/items/popup")
    public String popupList(){
        return "item/items-popup";
    }

    /**
     * (JSON) 아이템 목록
     * @return
     */
    @RequestMapping(value = "/items/json")
    @ResponseBody
    public JsonResult listJson(@RequestBody ItemSearch search){
        JsonResult jsonResult = new JsonResult();
        try {

            if(StringUtils.equals(search.getCategory(), ","))
                search.setCategory(null);
            if(StringUtils.equals(search.getDetailProperty(), ","))
                search.setDetailProperty(null);
            if(StringUtils.equals(search.getColorProperty(), ","))
                search.setColorProperty(null);

            List<Item> items = itemService.getAll(search);
            jsonResult.putData("items", items);
            jsonResult.setResult(true);
        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }

    /**
     * 아이템 업로드 폼
     * @return
     */
    @RequestMapping(value = {"/form", "/form/iframe"})
    public String uploadForm(Model model){
        model.addAttribute("item", new Item());
        model.addAttribute("layoutType", "iframe");
        return "item/form";
    }

    /**
     * 아이템 업로드 수정 폼
     * @return
     */
    @RequestMapping(value = "/form/{id}")
    public String modifyForm(@PathVariable long id, Model model){
        Item item = itemService.get(new Item(id));
        model.addAttribute("item", item);
        return "item/form";
    }

    /**
     * (JSON) 아이템 저장
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult upload(Item item, HttpServletRequest request){
        JsonResult jsonResult = new JsonResult();
        try {
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
            MultipartFile uploadFile = multiRequest.getFile("uploadFile");
            if (uploadFile != null) {
//                String path = "/item/thumb";
                String path = "/item/" + new SimpleDateFormat("yyyyMMdd").format(new Date());
                FileUploadResult uploadResult = fileUploadUtil.uploadFormFile(uploadFile, fileUploadUtil.getUploadPath() + path + "/", true);
                item.setThumbName(uploadResult.getFullFileName());
                item.setThumbPath(path);

                File src = new File(uploadResult.getFullPathFileName());
                File dest = new File(fileUploadUtil.getUploadPath() + path + "/" + uploadResult.getFileName() + "-thumb" + uploadResult.getFileExt());
                fileUploadUtil.resizeImageCropCenter(src, dest, 77, 77);

                jsonResult.putData("uploadResult", uploadResult);
            }
            itemService.save(item);
            jsonResult.putData("item", item);
            jsonResult.setResult(true);

        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }

    /**
     * 아이템 삭제
     * @param search
     * @return
     */
    @RequestMapping(value = "/remove", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult remove(@RequestBody ItemSearch search){
        JsonResult jsonResult = new JsonResult();
        try {

            if( search.getId() != null ){
                itemService.remove(new Item(search.getId()));
                jsonResult.setResult(true);
            }
            if(!CollectionUtils.isEmpty(search.getIds())){
                itemService.removeByIds(search);
                jsonResult.setResult(true);
            }

        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }

    /**
     * 이미지 저장
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveImage/{itemId}", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult saveImage(@PathVariable long itemId, HttpServletRequest request){
        JsonResult jsonResult = new JsonResult();
        try {

            Item item = itemService.get(new Item(itemId));
            String thumbUrl = item.getThumbUrl();
            int idx = thumbUrl.lastIndexOf("/");
            String fileFullName = thumbUrl.substring(idx+1, thumbUrl.length());

            String path = thumbUrl.substring(0, idx);
            String fileName = FilenameUtils.removeExtension(fileFullName);
            String fileExt = "." + FilenameUtils.getExtension(fileFullName);

            String savePath = fileUploadUtil.getUploadPath() + path;
            String saveFile = savePath + "/" + fileName + "-thumb" + fileExt;

            HttpServletRequestWrapper wrappedRequest = new HttpServletRequestWrapper(request);
            HttpServletRequestWrapper requestWithWrapper = (HttpServletRequestWrapper) wrappedRequest.getRequest();
            String imageString = requestWithWrapper.getParameter("myImg");
            imageString = imageString.substring("data:image/png;base64,".length());
            byte[] contentData = imageString.getBytes();
            byte[] decodedData = Base64.decodeBase64( contentData );
            FileOutputStream fos = new FileOutputStream(saveFile);
            fos.write(decodedData);
            fos.close();

            jsonResult.setResult(true);
            jsonResult.putData("saveFile", saveFile);

        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }
}
