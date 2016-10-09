package kr.co.codiyrabbit.biz.category.repository;

import kr.co.codiyrabbit.biz.category.domain.Category;
import kr.co.codiyrabbit.biz.category.domain.CategorySearch;
import kr.codeblue.core.BaseRepository;
import org.springframework.stereotype.Component;

@Component
public interface CategoryRepository extends BaseRepository<Category, CategorySearch> {

    public void updateForIdx(Category category);
    public void updateAllByIndex(CategorySearch search);
    public String findMaxCode(int depth);
}
