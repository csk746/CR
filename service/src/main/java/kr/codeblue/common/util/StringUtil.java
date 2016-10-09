package kr.codeblue.common.util;

import com.google.gson.Gson;
import org.apache.commons.lang3.StringUtils;

import java.util.HashMap;
import java.util.Map;

public class StringUtil {

	public static Map<String, String> jsonToMap(String json){
		Gson gson = new Gson();
		Map<String, String> data = new HashMap<String, String>();
		data = (Map<String,String>) gson.fromJson(json, data.getClass());
		return data;
	}
	
	/**
     * <p>XXXXXX - XXXXXXX 형식의 법인번호 앞, 뒤 문자열 2개 입력 받아 유효한 법인번호인지 검사.</p>
     * 
     * 
     * @param   6자리 법인앞번호 문자열 , 7자리 법인뒷번호 문자열
     * @return  유효한 법인번호인지 여부 (True/False)
     */
    public static boolean checkBubinNumber(String bubin1, String bubin2) {
        
        String bubinNumber = bubin1 + bubin2;
        
        int hap = 0;
        int temp = 1;   //유효검증식에 사용하기 위한 변수
        
        if(bubinNumber.length() != 13) return false;    //법인번호의 자리수가 맞는 지를 확인                   
        
        for(int i=0; i < 13; i++){
            if (bubinNumber.charAt(i) < '0' || bubinNumber.charAt(i) > '9') //숫자가 아닌 값이 들어왔는지를 확인
                    return false;                   
        }
        
        for ( int i=0; i<13; i++){
            if(temp ==3) temp = 1;                  
            hap = hap + (Character.getNumericValue(bubinNumber.charAt(i)) * temp);
            temp++;
        }       //검증을 위한 식의 계산
                                
        if ((10 - (hap%10))%10 == Character.getNumericValue(bubinNumber.charAt(12))) //마지막 유효숫자와 검증식을 통한 값의 비교
            return true;
        else
            return false;                                   
    }
    
    
    /**
     * <p>XXX - XX - XXXXX 형식의 사업자번호 앞,중간, 뒤 문자열 3개 입력 받아 유효한 사업자번호인지 검사.</p>
     *     
     * 
     * @param   3자리 사업자앞번호 문자열 , 2자리 사업자중간번호 문자열, 5자리 사업자뒷번호 문자열
     * @return  유효한 사업자번호인지 여부 (True/False)
     */
    public static boolean checkCompNumber(String comp1, String comp2, String comp3) {
        String compNumber = comp1 + comp2 + comp3;
        
        int hap = 0;
        int temp = 0;
        int check[] = {1,3,7,1,3,7,1,3,5};  //사업자번호 유효성 체크 필요한 수

        if(compNumber.length() != 10)    //사업자번호의 길이가 맞는지를 확인한다.
                return false;

        for(int i=0; i < 9; i++){
            if(compNumber.charAt(i) < '0' || compNumber.charAt(i) > '9')  //숫자가 아닌 값이 들어왔는지를 확인한다.
                    return false; 
            
            hap = hap + (Character.getNumericValue(compNumber.charAt(i)) * check[temp]); //검증식 적용
            temp++;
        }
                
        hap += (Character.getNumericValue(compNumber.charAt(8))*5)/10;

        if ((10 - (hap%10))%10 == Character.getNumericValue(compNumber.charAt(9))) //마지막 유효숫자와 검증식을 통한 값의 비교
                return true;
        else
                return false;
    }

    public static String shuffle(String string) {
        StringBuilder sb = new StringBuilder(string.length());
        double rnd;
        for (char c: string.toCharArray()) {
            rnd = Math.random();
            if (rnd < 0.34)
                sb.append(c);
            else if (rnd < 0.67)
                sb.insert(sb.length() / 2, c);
            else
                sb.insert(0, c);
        }       
        return sb.toString();
    }
    
    public static float extractRest(float num){
    	float result = 0f;
    	
    	if( num > 0 ){
    		String str = String.valueOf(num);
    		String[] arrStr = str.split("\\.");
    		if( arrStr.length == 2 ){
    			String tmp = "0." + arrStr[1];
    			result = Float.parseFloat(tmp);
    		}
    	}
    	
    	return result;
    }
    
    public static String replaceBr(String txt){
    	txt = txt.replaceAll("\n", "<br/>");
    	txt = txt.replaceAll("\r", "<br/>");
    	txt = txt.replaceAll("\r\n", "<br/>");
    	return txt;
    }
    
    public static String maskingField(String type, String txt){
    	if( StringUtils.isNotEmpty(type) && StringUtils.isNotEmpty(txt) ){
    		if( "name".equals(type) ){
    			txt = txt.substring(0, 1) + "*" + txt.substring(1, txt.length());
    		}
    		if( "mobile".equals(type) ){
    			if( txt.length() == 10 ){
    				txt = txt.substring(0, 3) + "***" + txt.substring(6, 10);
    			}
    			if( txt.length() == 11 ){
    				txt = txt.substring(0, 3) + "****" + txt.substring(7, 11);
    			}
    		}
    		if( "email".equals(type) ){
    			String[] arr = txt.split("@");
    			if( arr.length == 2 ){
    				txt = arr[0].substring(0, 3);
    				for(int i=0; i<arr[0].length()-3; i++){
    					txt += "*";
    				}
    				txt += "@" + arr[1];
    			}
    		}
    		if( "birthday".equals(type) ){
    			String[] arr = txt.split("-");
   				txt = arr[0] + "-*-*";
    		}
    	}
    	return txt;
    }
    
    public static Map<String, String> getQueryMap(String query)
    {
        String[] params = query.split("&");
        Map<String, String> map = new HashMap<String, String>();
        for (String param : params)
        {
            String name = param.split("=")[0];
            String value = param.split("=")[1];
            map.put(name, value);
        }
        return map;
    }
}
