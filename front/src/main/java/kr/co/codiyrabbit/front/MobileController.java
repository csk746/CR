package kr.co.codiyrabbit.front;

import kr.co.codiyrabbit.biz.product.domain.ProductSearch;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping(value = "/m")
public class MobileController {

    @Autowired
    FrontController frontController;

    /**
     * 초기 페이지
     * @return
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String index(){
        return "redirect:/m/main";
    }

    /**
     * 메인 페이지
     * @param search
     * @param model
     * @return
     */
    @RequestMapping(value = "/main")
    public String main(ProductSearch search, Model model){
        frontController.main(search, model);
        return "/m/main";
    }

    /**
     * 피드백
     * @return
     */
    @RequestMapping(value = "/feedback", method= RequestMethod.GET)
    public String feedback(){
        return "/m/feedback";
    }

    /**
     * 코디나비 뷰
     * @param id
     * @return
     */
    @RequestMapping(value="/codiynavi/{id}")
    public String codinaviView(@PathVariable long id, Model model, HttpServletResponse response){
        frontController.codinaviView(id, model, response);
        return "/m/codiynavi";
    }
}
