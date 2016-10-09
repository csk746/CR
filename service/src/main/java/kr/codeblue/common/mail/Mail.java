package kr.codeblue.common.mail;

import lombok.Data;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Data
public class Mail {
	private Long rnum;
	private Long id;
	private String memberEmail;
	private String to;
	private String from;
	private String subject;
	private String message;
	private Date sendDatetime;
	private String isSuccess;
	private Date createDatetime;
	private Long boardId;
	
	private List<String> tos = new ArrayList<String>();
	private String htmlFileName;
	private String htmlUrl;
	private HashMap<String, String> replaceContents = new HashMap<String, String>();
	
	public void putReplaceContents(String key, String value){
		this.replaceContents.put(key, value);
	}
}
