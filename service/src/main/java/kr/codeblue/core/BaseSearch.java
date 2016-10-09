package kr.codeblue.core;

import lombok.Data;

import java.util.List;

@Data public class BaseSearch {

	private Long id;
	private int limit;
	private int offset;
	private long total;
	private int totalPage;
	private int pageNo;
	private int pageGNo;
	private int query;
	private String pageType;
	private String orderBy;

	List<Long> ids;
	List<String> strIds;

	public int getLimit() {
		if( limit == 0 ) limit = 10;
		return limit;
	}
	public int getOffset() {
		if( pageNo != 0 ){
			offset = (pageNo-1) * limit;
		}
		return offset;
	}
	public int getPageNo() {
		if( pageNo == 0 ) pageNo = 1;
		return pageNo;
	}
	public int getTotalPage() {
		if( total < getLimit() ){
			return 1;
		} else {
			return (int)(Math.floor(total / getLimit()) + (total % getLimit() > 0 ? 1 : 0));
		}
	}
}
