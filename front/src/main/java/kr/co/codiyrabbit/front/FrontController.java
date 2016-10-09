package kr.co.codiyrabbit.front;

import com.dmurph.tracking.AnalyticsConfigData;
import com.dmurph.tracking.JGoogleAnalyticsTracker;
import eu.bitwalker.useragentutils.UserAgent;
import kr.co.codiyrabbit.biz.item.domain.Item;
import kr.co.codiyrabbit.biz.product.domain.Product;
import kr.co.codiyrabbit.biz.product.domain.ProductPoint;
import kr.co.codiyrabbit.biz.product.domain.ProductPointSearch;
import kr.co.codiyrabbit.biz.product.domain.ProductSearch;
import kr.co.codiyrabbit.biz.product.service.ProductPointService;
import kr.co.codiyrabbit.biz.product.service.ProductService;
import kr.co.codiyrabbit.biz.property.domain.Property;
import kr.co.codiyrabbit.biz.property.domain.PropertySearch;
import kr.co.codiyrabbit.biz.property.service.PropertyService;
import kr.codeblue.common.mail.Mail;
import kr.codeblue.common.mail.MailService;
import kr.codeblue.common.result.JsonResult;
import org.apache.commons.codec.binary.StringUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

@Controller
public class FrontController extends BaseFrontController {

    @Autowired
    ProductService productService;

    @Autowired
    ProductPointService productPointService;

    @Autowired
    PropertyService propertyService;

    @Autowired
    MailService mailService;

    @Autowired
    ServletContext servletContext;

    /**
     * 초기 페이지
     * @return
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String index(){
        return "redirect:/main";
    }

    /**
     * 접근 불가 페이지
     * @return
     */
    @RequestMapping(value = "/access-denied", method = RequestMethod.GET)
    public String accessDenied(){
        return "error/access-denied";
    }

    /**
     * 로그인 페이지
     * @return
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login(HttpServletRequest request, Model model){
        UserAgent userAgent = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
        String browser = userAgent.getBrowser().toString();
        model.addAttribute("browser", browser);
        if(StringUtils.equals(browser, "CHROME") ){
            return "login";
        } else {
            return "browser";
        }

    }

    /**
     * 로그인 결과
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/login/result")
    public JsonResult loginResult(HttpServletRequest request){
        if( isLogin(request) ){
            return new JsonResult(true);
        } else {
            return new JsonResult(false);
        }
    }

    /**
     * 메인 페이지
     * @return
     */
    @RequestMapping(value="/main")
    public String main(ProductSearch search, Model model){
        search.setIsDelete("N");

        model.addAttribute("viewId", search.getViewId());
        search.setViewId(null);

        String orderBy = search.getOrderBy();
        if( orderBy == null || StringUtils.equals(orderBy, "viewCount") ){
            orderBy = "viewCount";
            search.setOrderBy("ORDER BY T1.viewCount DESC");

        } else if( StringUtils.equals(orderBy, "recent") ){
            search.setOrderBy(null);
        }

        List<Product> products = productService.getAllWithImage(search);

        search.setOrderBy(orderBy);

        model.addAttribute("products", products);
        model.addAttribute("productSearch", search);
        return "main";
    }

    /**
     * 코디나비 뷰
     * @param id
     * @return
     */
    @RequestMapping(value="/codiynavi/{id}")
    public String codinaviView(@PathVariable long id, Model model, HttpServletResponse response){
        Product product = productService.get(new Product(id));
        ProductSearch search = new ProductSearch();
        search.setId(product.getId());
        List<Product> products = productService.getAllWithImage(search);
        if( !CollectionUtils.isEmpty(products) ){
            product = products.get(0);
        }

        if( product != null ){
            ProductPointSearch pointSearch = new ProductPointSearch();
            pointSearch.setProductId(product.getId());
            List<ProductPoint> points = productPointService.getAllWithItem(pointSearch);

            // 아이템의 속성
            if( !CollectionUtils.isEmpty(points) ){
                for(ProductPoint point: points){

                    if( !CollectionUtils.isEmpty(point.getItems()) ){

                        for(Item item: point.getItems()){
                            List<String> propertyIds = Arrays.asList(item.getColorProperty().split(","));
                            PropertySearch propertySearch = new PropertySearch();
                            propertySearch.setType("COLOR");
                            propertySearch.setStrIds(propertyIds);
                            List<Property> propertyList = propertyService.getAll(propertySearch);
                            item.setColorProperties(propertyList);

                        }

                    }

                }
            }

            model.addAttribute("points", points);
        }

//        addViewCountCookie(product.getId(), response);
        addViewCountSession(product.getId());

        model.addAttribute("product", product);
        return "codiynavi";
    }

    /**
     * 코디나비 소스 복사를 위한 프래임
     * @param product
     * @param model
     * @return
     */
    @RequestMapping(value = "/codiynavi-source")
    public String codiynaviSource(Product product, Model model){
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
//            if( !CollectionUtils.isEmpty(points) ){
//                points.sort(new Comparator<ProductPoint>(){
//                    @Override
//                    public int compare(ProductPoint o1, ProductPoint o2) {
//                        int result = o1.getName().compareTo(o2.getName());
//                        return result;
//                    }
//                });
//            }
            model.addAttribute("points", points);
        }

        model.addAttribute("product", product);
        return "codiynavi-source";
    }

    /**
     * feedback 전송
     * @param email
     * @param contents
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/feedback/send", method=RequestMethod.POST)
    public JsonResult emailSend(String email, String contents){
        JsonResult jsonResult = new JsonResult(true);
        try {

            Mail mail = new Mail();
            mail.setSubject("[codiyrabbit] 문의 메일이 도착하였습니다.");
            mail.setFrom(mailAccount);
            mail.setTo(mailAccount);

            String message = "<br/><br/><strong>%s</strong>: %s<br/><br/><hr/><br/>%s";
            message = String.format(message, "문의 이메일", email, contents.replaceAll("\\r?\\n", "<br />"));
            mail.setMessage(message);
            mailService.sendMail(mail);

        } catch(Exception e) {
            jsonResult.setResult(false);
            e.printStackTrace();
        }
        return jsonResult;
    }

    /**
     * view count 를 위한 더미 이미지
     * @param name (p-{id}.gif)
     * @return
     */
    @RequestMapping("/codiynavi/images/{name}")
    public @ResponseBody byte[] codiynaviPublishViewCount(@PathVariable String name, HttpServletResponse response) throws IOException {
        String referer = request.getHeader("referer");
        String host = request.getRemoteHost();

        long productId = 0;
        if( !referer.startsWith(baseFrontUrl) && !referer.startsWith(baseAdminUrl) ) {
            if (name != null) {
                String[] arr = name.split("-");
                if (arr.length == 2) {
                    String sid = arr[1].replace(".gif", "");
                    long id = productId = Long.parseLong(sid);
//                    addViewCountCookie(product.getId(), response);
                    addViewCountSession(id);
                }
            }
        }

        if( productId > 0 ) {
            Product product = productService.get(new Product(productId));

            // GA
            AnalyticsConfigData config = new AnalyticsConfigData("UA-55459434-2");
            JGoogleAnalyticsTracker tracker = new JGoogleAnalyticsTracker(config, JGoogleAnalyticsTracker.GoogleAnalyticsVersion.V_4_7_2);

            tracker.trackPageViewFromReferrer("/codiynavi/" + productId, product.getTitle(), host, referer, referer);
            tracker.trackPageViewFromReferrer("/share/codiynavi/" + productId, product.getTitle(), host, referer, referer);
        }

        InputStream in = servletContext.getResourceAsStream("/resources/images/blank.gif");
        return IOUtils.toByteArray(in);
    }

}
