package kr.codeblue.core;

import java.util.List;

public interface BaseRepository<T, SEARCH> {

	/**
	 * 저장
	 * @param obj
	 */
	public void insert(T obj);
	
	/**
	 * 배열 저장
	 * @param obj
	 */
	public void insertAll(SEARCH search);
	
	/**
	 * 업데이트
	 * @param obj
	 */
	public void update(T obj);
	
	/**
	 * 삭제
	 * @param obj
	 */
	public void delete(T obj);
	
	/**
	 * 전체 삭제
	 * @param obj
	 */
	public void deleteAll();
	
	/**
	 * 한개의 결과
	 * @param obj
	 * @return T
	 */
	public T findOne(T obj);
	
	/**
	 * 리스트
	 * @param search
	 * @return List<T>
	 */
	public List<T> findList(SEARCH search);
	
	/**
	 * 리스트 개수
	 * @param search
	 * @return
	 */
	public long findListTotal(SEARCH search);
	
	/**
	 * 전체 리스트
	 * @param search
	 * @return List<T>
	 */
	public List<T> findAll(SEARCH search);
	
	/**
	 * 전체 리스트 개수
	 * @param search
	 * @return
	 */
	public long findAllTotal(SEARCH search);
}
