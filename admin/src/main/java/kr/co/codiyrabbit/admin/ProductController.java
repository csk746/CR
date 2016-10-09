package kr.co.codiyrabbit.admin;

import kr.co.codiyrabbit.biz.item.domain.Item;
import kr.co.codiyrabbit.biz.item.domain.ItemSearch;
import kr.co.codiyrabbit.biz.member.domain.Member;
import kr.co.codiyrabbit.biz.product.domain.Product;
import kr.co.codiyrabbit.biz.product.domain.ProductPoint;
import kr.co.codiyrabbit.biz.product.domain.ProductPointSearch;
import kr.co.codiyrabbit.biz.product.domain.ProductSearch;
import kr.co.codiyrabbit.biz.product.service.ProductImageService;
import kr.co.codiyrabbit.biz.product.service.ProductPointService;
import kr.co.codiyrabbit.biz.product.service.ProductService;
import kr.codeblue.common.result.JsonResult;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.awt.*;
import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/product")
public class ProductController extends BaseAdminController {

    @Autowired
    ProductService productService;

    @Autowired
    ProductImageService productImageService;

    @Autowired
    ProductPointService productPointService;

    /**
     * 상품 리스트
     * @return
     */
    @RequestMapping(value = "/products")
    public String list(ProductSearch search, Model model){

        Member member = getMember(request);
        if( member.getRoles().contains("ROLE_MAKER") ){
            search.setMemberId(member.getId());
        }

        search.setIsDelete("N");
        List<Product> products = productService.getAllWithImage(search);

        model.addAttribute("products", products);

        return "product/products";
    }

    /**
     * 상품 등록폼
     * @param model
     * @return
     */
    @RequestMapping(value = "/form")
    public String form(Model model){
        model.addAttribute("product", new Product());
        return "product/form";
    }

    /**
     * 상품 수정폼
     * @param model
     * @return
     */
    @RequestMapping(value = "/form/{id}")
    public String form(@PathVariable Long id, Model model){
        ProductSearch search = new ProductSearch();
        search.setIds(Arrays.asList(id));
        List<Product> products = productService.getAllWithImage(search);

        Product product = null;
        if(!CollectionUtils.isEmpty(products)){
            product = products.get(0);
        }

        model.addAttribute("product", product);
        return "product/form";
    }

    /**
     * 이미지 저장
     * @param type
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveImage/{type}", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult saveImage(@PathVariable String type, HttpServletRequest request){
        JsonResult jsonResult = new JsonResult();
        try {
            int boxsize = 1920;
            System.out.print("boxsize : " + boxsize);
            String path = "/product/" + new SimpleDateFormat("yyyyMMdd").format(new Date());
            String savePath = "";
            if( type.equals("temp") ){
                savePath = System.getProperty("java.io.tmpdir") + "/codiyrabbit" + path;
            } else {
                savePath = fileUploadUtil.getUploadPath() + path;
            }

            File uploadFolder = new File(savePath);
            if(!uploadFolder.exists()){
                uploadFolder.mkdirs();
            }

            HttpServletRequestWrapper wrappedRequest = new HttpServletRequestWrapper(request);
            HttpServletRequestWrapper requestWithWrapper = (HttpServletRequestWrapper) wrappedRequest.getRequest();
            String imageString = requestWithWrapper.getParameter("myImg");
            imageString = imageString.substring("data:image/png;base64,".length());
            byte[] contentData = imageString.getBytes();
            byte[] decodedData = Base64.decodeBase64( contentData );
            String fileName = fileUploadUtil.newRndFileName("image.jpg");
            FileOutputStream fos = new FileOutputStream(savePath + "/" + fileName);
            fos.write(decodedData);
            fos.close();

            Image image = fileUploadUtil.getImage(new File(savePath + "/" + fileName));
            File uploaded = new File(savePath + "/" + fileName);
            if( boxsize > 0 && image.getWidth(null) > boxsize ){
                fileUploadUtil.resizeImage(uploaded, uploaded, boxsize);
            }

            jsonResult.setResult(true);
            jsonResult.putData("filePath", path);
            jsonResult.putData("fileName", fileName);
            jsonResult.putData("width", image.getWidth(null));
            jsonResult.putData("height", image.getHeight(null));

        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }

    /**
     * (JSON) 상품 저장
     * @return
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult save(@RequestBody Product product){
        JsonResult jsonResult = new JsonResult();
        try {

            if( product.getId() == 0 ) {
                // 자동 생성 코드 10회 생성 후 남은 코드가 없으면 에러
                String code = productService.getCode();
                if (code == null) {
                    return new JsonResult(false, "code");
                }
                product.setCode(code);
                product.setMemberId(getMember(request).getId());
                product.setIsDelete("N");
            }

            // 메이커의 경우 상품 매칭 3개만 가능
            if( getMember(request).getRoles().contains("ROLE_MAKER") ){
                if( !CollectionUtils.isEmpty(product.getPoints()) ){
                    for(ProductPoint productPoint: product.getPoints()){
                        if( !CollectionUtils.isEmpty(productPoint.getItems()) ){
                            if( productPoint.getItems().size() > 3 ){
                                return new JsonResult(false, "maxItem");
                            }

                        }
                    }
                }

            }

            productService.save(product);
            jsonResult.putData("product", product);
            jsonResult.setResult(true);

        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }

    /**
     * 상품의 포인트 정보
     * @param search
     * @return
     */
    @RequestMapping(value = "/points", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult points(ProductPointSearch search){
        JsonResult jsonResult = new JsonResult();
        try {
            List<ProductPoint> points = productPointService.getAllWithItem(search);
            jsonResult.setResult(true);
            jsonResult.putData("points", points);
        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }

    /**
     * 코디나비
     * @param product
     * @param model
     * @return
     */
    @RequestMapping(value = "/codiynavi")
    public String codiynavi(Product product, String saveType, Model model){
        model.addAttribute("saveType", saveType);
        ProductSearch search = new ProductSearch();
        if( product.getId() > 0 ){
            search.setId(product.getId());
        }
        if( product.getCode() != null ){
            search.setCode(product.getCode());
        }

        List<Product> products = productService.getAllWithImage(search);
        if( !CollectionUtils.isEmpty(products) ){
            product = products.get(0);
        }

        if( product != null ){
            ProductPointSearch pointSearch = new ProductPointSearch();
            pointSearch.setProductId(product.getId());
            pointSearch.setIsPublish("Y");
            List<ProductPoint> points = productPointService.getAllWithItem(pointSearch);
            model.addAttribute("points", points);
        }

        model.addAttribute("product", product);
        return "product/codiynavi";
    }

    /**
     * 코디나비
     * @param product
     * @param model
     * @return
     */
    @RequestMapping(value = "/codiynavi-source")
    public String codiynaviSource(Product product,  Model model){
        ProductSearch search = new ProductSearch();
        if( product.getId() > 0 ){
            search.setId(product.getId());
        }
        if( product.getCode() != null ){
            search.setCode(product.getCode());
        }

        List<Product> products = productService.getAllWithImage(search);
        if( !CollectionUtils.isEmpty(products) ){
            product = products.get(0);
        }

        if( product != null ){
            ProductPointSearch pointSearch = new ProductPointSearch();
            pointSearch.setProductId(product.getId());
            pointSearch.setIsPublish("Y");
            List<ProductPoint> points = productPointService.getAllWithItem(pointSearch);
            model.addAttribute("points", points);
        }

        model.addAttribute("product", product);
        return "product/codiynavi-source";
    }

    /**
     * 상품 삭제
     * @param search
     * @return
     */
    @RequestMapping(value = "/remove", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult remove(@RequestBody ProductSearch search){
        JsonResult jsonResult = new JsonResult();
        try {

            if( search.getId() != null ){
                productService.remove(new Product(search.getId()));
                jsonResult.setResult(true);
            }
            if(!CollectionUtils.isEmpty(search.getIds())){
                productService.removeByIds(search);
                jsonResult.setResult(true);
            }

        } catch (Exception e){
            e.printStackTrace();
            return jsonResult;
        }
        return jsonResult;
    }
}
