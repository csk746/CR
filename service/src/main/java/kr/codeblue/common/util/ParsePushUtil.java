package kr.codeblue.common.util;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.util.Map;

public class ParsePushUtil {
	
	private static final String APPLICATION_ID = "MJ0u5pDC5LjRjhWNFlxOMKx3umTyfBKjzLRnsGzv";
	private static final String REST_API_KEY = "dDqO4TcPD9JkUaCw1hyLNXu7UMi8AsMJhfrh6gxP";
	private static final String PUSH_URL = "https://api.parse.com/1/push";

	public static String sendEveryone(String type, Map<String, String> data) throws Exception {
		JSONObject jo = new JSONObject();
		JSONObject where = new JSONObject();
		if(type != null) {
			if( "all".equals(type) ){
				JSONObject types = new JSONObject();
				types.put("$in", new String[]{ "android", "ios" });
				where.put("", types);
			} else {
				where.put("deviceType", type);
			}
		}
		jo.put("where", where);
		jo.put("data", data);
		
		String msg = jo.toString();
		System.out.println(msg);
		return ParsePushUtil.pushData(msg);
	}
	
	public static String sendChat(String memberId, String message) throws Exception {
		JSONObject jo = new JSONObject();
		
		JSONObject data = new JSONObject();
		JSONObject inData = new JSONObject();
		JSONObject where = new JSONObject();
		
		inData.put("type", "CHAT");
		inData.put("title", "");
		inData.put("content", message);
		
		where.put("memberId", memberId);
		
		data.put("data", inData);
		data.put("alert", message);
		
		data.put("badge", "Increment");

		jo.put("where", where);
		jo.put("data", data);
		
		String msg = jo.toString();
		System.out.println(msg);
		return ParsePushUtil.pushData(msg);
	}
	
	public static String sendChannels(String[] channels, String type, Map<String, String> data) throws Exception {
	    JSONObject jo = new JSONObject();
	    
	    if( channels == null ){
	    	jo.put("channels", new String[]{""});
	    } else {
	    	jo.put("channels", channels);
	    }
	    
	    if(type != null) {
	    	if( "all".equals(type) ){
	    		JSONObject types = new JSONObject();
	    		types.put("$in", new String[]{ "android", "ios" });
	    		jo.put("type", types);
	    	} else {
	    		jo.put("type", type);
	    	}
	    }
	    jo.put("data", data);

	    return ParsePushUtil.pushData(jo.toString());
	}
	
	public static String pushData(String msg){
		String result = "";
		
		try {
			DefaultHttpClient httpclient = new DefaultHttpClient();
		    HttpResponse response = null;
		    HttpEntity entity = null;
		    HttpPost httpost = new HttpPost(PUSH_URL); 
		    httpost.addHeader("X-Parse-Application-Id", APPLICATION_ID);
		    httpost.addHeader("X-Parse-REST-API-Key", REST_API_KEY);
		    httpost.addHeader("Content-Type", "application/json; charset=utf-8");
		    StringEntity reqEntity = new StringEntity(msg, "utf-8");
		    httpost.setEntity(reqEntity);
		    response = httpclient.execute(httpost);
		    entity = response.getEntity();
		    if (entity != null) {
		    	result = EntityUtils.toString(response.getEntity());  
		    }
		} catch(Exception e) {
			
		}
		
		return result;
	}
	
}
