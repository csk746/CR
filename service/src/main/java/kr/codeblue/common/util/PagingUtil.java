package kr.codeblue.common.util;

import kr.codeblue.core.BaseSearch;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

public class PagingUtil {

	public static void createBoardPaging(HttpServletRequest request, BaseSearch search){
		Paging paging = new Paging(search.getTotal(), request.getRequestURI(), search);
        paging = PagingUtil.createBoardPaging(paging);
		request.setAttribute("paging", paging);
	}
	
	public static Paging createBoardPaging(Paging paging) {
		
		String linkPageName = paging.pageName + "?";
		
		String pageNoParam = "pageNo=";
		String pageGNoParam = "pageGNo=";		
		
		String n = "&";	
		
		paging.pageNo -= 1;

		int totalPage = (int) (paging.totalCount / paging.splitNo + (paging.totalCount % paging.splitNo > 0 ? 1 : 0));
//		totalPage += 1;
		int startNo = (paging.pageGNo == 0 ? 1 : (paging.pageGNo * paging.showSplitNo)+1);
		int endNo = startNo + paging.showSplitNo - 1;
		endNo = (endNo > totalPage) ? totalPage : endNo;
		
		int pageStartNo = (paging.pageNo*paging.splitNo)+1;
		int pageEndNo = pageStartNo + (paging.splitNo-1); 
		
		List<String> pagingNoList = new ArrayList<String>();
		List<String> pagingNoList2 = new ArrayList<String>();
		for(int i = startNo; i <= endNo; i++){
			if( i<=totalPage ){
				pagingNoList.add("<a href='" + linkPageName + pageNoParam + i + n + pageGNoParam + paging.pageGNo + n + "splitNo=" + paging.splitNo + n + paging.userParam + "'>" + i + "</a>");
				pagingNoList2.add(String.valueOf(i));
			}
		}
		
		if( paging.pageGNo == 0 ){
			paging.prevLink = "#";
			paging.prevGNo = 0;
			paging.prevPNo = 0;
		} else {
			paging.prevLink = linkPageName + pageNoParam + (startNo - 1) + n + pageGNoParam + (paging.pageGNo - 1);
			paging.prevGNo = paging.pageGNo - 1;
			paging.prevPNo = (startNo - 1);
		}
		paging.firstPrevLink = linkPageName + "1";
		
		if( endNo >= totalPage ){
			paging.nextLink = "#";
			paging.nextGNo = paging.pageGNo;
			paging.nextPNo = endNo;
		} else {
			paging.nextLink = linkPageName + pageNoParam + (endNo + 1) + n + pageGNoParam + (paging.pageGNo + 1);
			paging.nextGNo = paging.pageGNo + 1;
			paging.nextPNo = (endNo + 1);
		}
		paging.lastNextLink = linkPageName + totalPage;
		
		paging.pageStartNo = pageStartNo;
		paging.pageEndNo = pageEndNo;
		paging.pageNo = paging.pageNo+1;
		//paging.pageGNo = paging.pageGNo;
		paging.totalCount = paging.totalCount;
		paging.totalPage = totalPage;
		//paging.splitNo = paging.splitNo;
		paging.endNo = endNo;
		
		paging.link1 = linkPageName + pageNoParam;
		paging.link2 = n + pageGNoParam + paging.pageGNo + n + paging.userParam;
		
		if( paging.pageGNo > 0 ) paging.prevLink = paging.prevLink + n + paging.userParam;
		if( paging.pageGNo > 0 ) paging.firstPrevLink = paging.firstPrevLink + n + paging.userParam;
		
		if( endNo < totalPage ) paging.nextLink = paging.nextLink + n + paging.userParam;
		if( endNo < totalPage ) paging.lastNextLink = paging.lastNextLink + n + paging.userParam;
				
		paging.pagingNoList = pagingNoList;
		paging.pagingNoOnlyList = pagingNoList2;

		
		/*
		// 이전 버튼 링크 생성
		pagingMap.put("prevLink", (pageGNo == 0 ? "#" : linkPageName + pageNoParam + (startNo - 1) + n + pageGNoParam + (pageGNo - 1)));
		pagingMap.put("firstPrevLink", linkPageName + "1");

		// 다음 버튼 링크 생성
		pagingMap.put("nextLink", (endNo >= totalPage ? "#" : linkPageName + pageNoParam + (endNo + 1) + n + pageGNoParam + (pageGNo + 1)));
		pagingMap.put("lastNextLink", linkPageName + totalPage);
		
		pagingMap.put("pageStartNo", pageStartNo);
		pagingMap.put("pageEndNo", pageEndNo);
		
		pagingMap.put("pageNo", pageNo+1);
		pagingMap.put("pageGNo", pageGNo);
		pagingMap.put("totalCount", totalCount);
		pagingMap.put("totalPage", totalPage);
		pagingMap.put("splitNo", splitNo);
		pagingMap.put("startNo", startNo);
		pagingMap.put("endNo", endNo);
		
		pagingMap.put("link1", linkPageName + pageNoParam);
		pagingMap.put("link2", n + pageGNoParam + pageGNo + n + userParam);
		
		
		//link add user param
		if( pageGNo > 0 ) pagingMap.put("prevLink", pagingMap.get("prevLink") + n + userParam);
		if( pageGNo > 0 ) pagingMap.put("firstPrevLink", pagingMap.get("firstPrevLink") + n + userParam);
		
		if( endNo < totalPage ) pagingMap.put("nextLink", pagingMap.get("nextLink") + n + userParam);
		if( endNo < totalPage ) pagingMap.put("lastNextLink", pagingMap.get("lastNextLink") + n + userParam);
				

		pagingMap.put("pagingNoList", pagingNoList);
		pagingMap.put("pagingNoOnlyList", pagingNoList2);
		*/
		
		
		return paging;
		
	}
	
	public static void pagingTest(Map<Object, Object> testMap) {
		
		System.out.println("--------------------------------------------------------------\n");
		
		Iterator<Entry<Object, Object>> itr = testMap.entrySet().iterator();
		while (itr.hasNext()) {
			Entry<Object, Object> entry = (Entry<Object, Object>) itr.next();
			System.out.println("\t" + entry.getKey() + " = " + entry.getValue());
		}

		System.out.println("\n--------------------------------------------------------------");
		
	}
}
