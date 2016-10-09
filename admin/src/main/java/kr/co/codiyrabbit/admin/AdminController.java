package kr.co.codiyrabbit.admin;

import eu.bitwalker.useragentutils.UserAgent;
import kr.codeblue.common.result.JsonResult;
import org.apache.commons.codec.binary.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
public class AdminController extends BaseAdminController {

    /**
     * 관리자 초기 페이지
     * @return
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String index(){
        return "redirect:/login";
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
    public String main(){
        return "redirect:/product/products";
    }

}
