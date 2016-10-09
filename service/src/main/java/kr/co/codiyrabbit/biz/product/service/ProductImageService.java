package kr.co.codiyrabbit.biz.product.service;

import kr.co.codiyrabbit.biz.product.domain.ProductImage;
import kr.co.codiyrabbit.biz.product.domain.ProductImageSearch;
import kr.co.codiyrabbit.biz.product.repository.ProductImageRepository;
import kr.codeblue.core.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductImageService implements BaseService<ProductImage,ProductImageSearch> {

    @Autowired
    ProductImageRepository productImageRepository;

    @Override
    public ProductImage get(ProductImage obj) {
        return productImageRepository.findOne(obj);
    }

    @Override
    public List<ProductImage> getList(ProductImageSearch search) {
        search.setTotal(this.getListTotal(search));
        return productImageRepository.findList(search);
    }

    @Override
    public long getListTotal(ProductImageSearch search) {
        return productImageRepository.findListTotal(search);
    }

    @Override
    public List<ProductImage> getAll(ProductImageSearch search) {
        return productImageRepository.findAll(search);
    }

    @Override
    public void save(ProductImage obj) {
        if( obj.getId() == 0 ){
            productImageRepository.insert(obj);
        } else {
            this.update(obj);
        }
    }

    @Override
    public void update(ProductImage obj) {
        productImageRepository.update(obj);
    }

    @Override
    public void remove(ProductImage obj) {
        productImageRepository.delete(obj);
    }
}
