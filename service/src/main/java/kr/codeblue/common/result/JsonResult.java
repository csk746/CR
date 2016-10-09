package kr.codeblue.common.result;

import lombok.Data;
import org.codehaus.jackson.map.annotate.JsonSerialize;
import org.codehaus.jackson.map.annotate.JsonSerialize.Inclusion;

import java.util.HashMap;

@Data
@JsonSerialize(include = Inclusion.NON_NULL)
public class JsonResult {

	private boolean result;
	private String message;
	private String text;
	private HashMap<String, Object> data = new HashMap<String, Object>();
	
	public JsonResult(){}
	public JsonResult(boolean result){
		this.result = result;
	}
	
	public JsonResult(boolean result, String message){
		this.result = result;
		this.message = message;
	}
	
	public JsonResult(boolean result, String message, String text){
		this.result = result;
		this.message = message;
		this.text = text;
	}
	
	public JsonResult(boolean result, HashMap<String, Object> data){
		this.result = result;
		this.data = data;
	}
	
	public JsonResult(boolean result, String message, HashMap<String, Object> data){
		this.result = result;
		this.message = message;
		this.data = data;
	}
	
	public void putData(String key, Object value){
		this.data.put(key, value);
	}
}
