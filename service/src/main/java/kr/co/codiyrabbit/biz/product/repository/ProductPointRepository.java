package kr.co.codiyrabbit.biz.product.repository;

import kr.co.codiyrabbit.biz.product.domain.ProductPoint;
import kr.co.codiyrabbit.biz.product.domain.ProductPointSearch;
import kr.codeblue.core.BaseRepository;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface ProductPointRepository extends BaseRepository<ProductPoint, ProductPointSearch> {

    public void insertAllItem(ProductPoint productPoint);
    public List<ProductPoint> findAllWithItem(ProductPointSearch search);

}
