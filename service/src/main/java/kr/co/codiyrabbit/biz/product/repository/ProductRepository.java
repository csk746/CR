package kr.co.codiyrabbit.biz.product.repository;

import kr.co.codiyrabbit.biz.product.domain.Product;
import kr.co.codiyrabbit.biz.product.domain.ProductImage;
import kr.co.codiyrabbit.biz.product.domain.ProductSearch;
import kr.codeblue.core.BaseRepository;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface ProductRepository extends BaseRepository<Product, ProductSearch> {

    public List<Product> findAllWithImage(ProductSearch search);
    public void deleteChild(long id);
    public void updateViewCount(long id);
    public Product findOneByCode(String code);

}
