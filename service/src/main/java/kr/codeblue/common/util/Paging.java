package kr.codeblue.common.util;

import kr.codeblue.core.BaseSearch;

import java.util.List;

public class Paging {

	public String prevLink;
	public String firstPrevLink;
	public String nextLink;
	public String lastNextLink;
	public String pageName;
	public String searchType;
	public String searchText;
	
	public String look;
	
	public int pageStartNo;
	public int pageEndNo;
	public int pageNo = 1;
	public int pageGNo = 0;
	public long totalCount;
	public int totalPage;
	public int splitNo = 10;
	public int startNo;
	public int endNo;
	public int showSplitNo = 10;
	
	public String link1;
	public String link2;
	
	public List<String> pagingNoList;
	public List<String> pagingNoList2;
	public List<String> pagingNoOnlyList;
	public String userParam = "";
	
	public int prevGNo;
	public int nextGNo;
	
	public int prevPNo;
	public int nextPNo;
	
	public Paging paging;
	
	public Paging(){
		
	}
	
	public Paging(long totalCount, String pageName){
		if( paging == null ) paging = new Paging();
		this.totalCount = totalCount;
		this.pageName = pageName;
	}
	
	public Paging(long totalCount, String pageName, BaseSearch baseSearch){
		if( paging == null ) paging = new Paging();
		this.totalCount = totalCount;
		this.pageName = pageName;
		this.pageNo = baseSearch.getPageNo();
		this.pageGNo = baseSearch.getPageGNo();
		this.splitNo = baseSearch.getLimit();
	}
	
	public String getPrevLink() {
		return prevLink;
	}
	public void setPrevLink(String prevLink) {
		this.prevLink = prevLink;
	}
	public String getFirstPrevLink() {
		return firstPrevLink;
	}
	public void setFirstPrevLink(String firstPrevLink) {
		this.firstPrevLink = firstPrevLink;
	}
	public String getNextLink() {
		return nextLink;
	}
	public void setNextLink(String nextLink) {
		this.nextLink = nextLink;
	}
	public String getLastNextLink() {
		return lastNextLink;
	}
	public void setLastNextLink(String lastNextLink) {
		this.lastNextLink = lastNextLink;
	}
	public String getPageName() {
		return pageName;
	}
	public void setPageName(String pageName) {
		this.pageName = pageName;
	}
	public int getPageStartNo() {
		return pageStartNo;
	}
	public void setPageStartNo(int pageStartNo) {
		this.pageStartNo = pageStartNo;
	}
	public int getPageEndNo() {
		return pageEndNo;
	}
	public void setPageEndNo(int pageEndNo) {
		this.pageEndNo = pageEndNo;
	}
	public int getPageNo() {
		return pageNo;
	}
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	public int getPageGNo() {
		return pageGNo;
	}
	public void setPageGNo(int pageGNo) {
		this.pageGNo = pageGNo;
	}
	public long getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getSplitNo() {
		return splitNo;
	}
	public void setSplitNo(int splitNo) {
		this.splitNo = splitNo;
	}
	public int getStartNo() {
		return startNo;
	}
	public void setStartNo(int startNo) {
		this.startNo = startNo;
	}
	public int getEndNo() {
		return endNo;
	}
	public void setEndNo(int endNo) {
		this.endNo = endNo;
	}
	public int getShowSplitNo() {
		return showSplitNo;
	}
	public void setShowSplitNo(int showSplitNo) {
		this.showSplitNo = showSplitNo;
	}
	public String getLink1() {
		return link1;
	}
	public void setLink1(String link1) {
		this.link1 = link1;
	}
	public String getLink2() {
		return link2;
	}
	public void setLink2(String link2) {
		this.link2 = link2;
	}
	public List<String> getPagingNoList() {
		return pagingNoList;
	}
	public void setPagingNoList(List<String> pagingNoList) {
		this.pagingNoList = pagingNoList;
	}
	public List<String> getPagingNoList2() {
		return pagingNoList2;
	}
	public void setPagingNoList2(List<String> pagingNoList2) {
		this.pagingNoList2 = pagingNoList2;
	}
	public List<String> getPagingNoOnlyList() {
		return pagingNoOnlyList;
	}
	public void setPagingNoOnlyList(List<String> pagingNoOnlyList) {
		this.pagingNoOnlyList = pagingNoOnlyList;
	}
	public String getUserParam() {
		return userParam;
	}
	public void setUserParam(String userParam) {
		this.userParam = userParam;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchText() {
		return searchText;
	}

	public void setSearchText(String searchText) {
		this.searchText = searchText;
	}

	public String getLook() {
		return look;
	}

	public void setLook(String look) {
		this.look = look;
	}

	public Paging getPaging() {
		return paging;
	}

	public void setPaging(Paging paging) {
		this.paging = paging;
	}
	
	public int getPrevGNo() {
		return prevGNo;
	}

	public void setPrevGNo(int prevGNo) {
		this.prevGNo = prevGNo;
	}

	public int getNextGNo() {
		return nextGNo;
	}

	public void setNextGNo(int nextGNo) {
		this.nextGNo = nextGNo;
	}
	
	public int getPrevPNo() {
		return prevPNo;
	}

	public void setPrevPNo(int prevPNo) {
		this.prevPNo = prevPNo;
	}

	public int getNextPNo() {
		return nextPNo;
	}

	public void setNextPNo(int nextPNo) {
		this.nextPNo = nextPNo;
	}

	@Override
	public String toString() {
		return "Paging [prevLink=" + prevLink + ", firstPrevLink="
				+ firstPrevLink + ", nextLink=" + nextLink + ", lastNextLink="
				+ lastNextLink + ", pageName=" + pageName + ", searchType="
				+ searchType + ", searchText=" + searchText + ", look=" + look
				+ ", pageStartNo=" + pageStartNo + ", pageEndNo=" + pageEndNo
				+ ", pageNo=" + pageNo + ", pageGNo=" + pageGNo
				+ ", totalCount=" + totalCount + ", totalPage=" + totalPage
				+ ", splitNo=" + splitNo + ", startNo=" + startNo + ", endNo="
				+ endNo + ", showSplitNo=" + showSplitNo + ", link1=" + link1
				+ ", link2=" + link2 + ", pagingNoList=" + pagingNoList
				+ ", pagingNoList2=" + pagingNoList2 + ", pagingNoOnlyList="
				+ pagingNoOnlyList + ", userParam=" + userParam + ", paging="
				+ paging + "]";
	}
	
	
}
