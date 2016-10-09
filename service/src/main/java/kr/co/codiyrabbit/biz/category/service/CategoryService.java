package kr.co.codiyrabbit.biz.category.service;

import kr.co.codiyrabbit.biz.category.domain.Category;
import kr.co.codiyrabbit.biz.category.domain.CategorySearch;
import kr.co.codiyrabbit.biz.category.repository.CategoryRepository;
import kr.codeblue.core.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService implements BaseService<Category, CategorySearch> {

    @Autowired
    CategoryRepository categoryRepository;

    @Override
    public Category get(Category obj) {
        return categoryRepository.findOne(obj);
    }

    @Override
    public List<Category> getList(CategorySearch search) {
        search.setTotal(this.getListTotal(search));
        return categoryRepository.findList(search);
    }

    @Override
    public long getListTotal(CategorySearch search) {
        return categoryRepository.findListTotal(search);
    }

    @Override
    public List<Category> getAll(CategorySearch search) {
        return categoryRepository.findAll(search);
    }

    @Override
    public void save(Category obj) {
        if( obj.getId() == 0 ){
            categoryRepository.insert(obj);
        } else {
            this.update(obj);
        }
    }

    @Override
    public void update(Category obj) {
        categoryRepository.update(obj);
    }

    @Override
    public void remove(Category obj) {
        categoryRepository.delete(obj);
    }

    public void updateForIdx(Category obj){
        categoryRepository.updateForIdx(obj);
    }

    public void updateAllByIndex(CategorySearch search){
        categoryRepository.updateAllByIndex(search);
    }
}
