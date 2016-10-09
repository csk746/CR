package kr.codeblue.core;

import java.util.List;

public interface BaseService<T, SearchClass> {
	
	/**
	 * 한개의 결과
	 * @param obj
	 * @return
	 */
	public T get(T obj);

	/**
	 * 리스트 결과
	 * @param obj
	 * @return
	 */
	public List<T> getList(SearchClass search);
	
	/**
	 * 리스트 결과 개수
	 * @param obj
	 * @return
	 */
	public long getListTotal(SearchClass search);
	
	/**
	 * 전체 리스트 결과
	 * @param obj
	 * @return
	 */
	public List<T> getAll(SearchClass search);
	
	/**
	 * 저장 혹은 수정
	 * @param obj
	 * @return
	 */
	public void save(T obj);
	
	/**
	 * 수정
	 * @param obj
	 * @return
	 */
	public void update(T obj);
	
	/**
	 * 삭제
	 * @param obj
	 * @return
	 */
	public void remove(T obj);
}
