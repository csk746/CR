package kr.co.codiyrabbit.biz.product.repository;

import kr.co.codiyrabbit.biz.product.domain.ProductImage;
import kr.co.codiyrabbit.biz.product.domain.ProductImageSearch;
import kr.codeblue.core.BaseRepository;
import org.springframework.stereotype.Component;

@Component
public interface ProductImageRepository extends BaseRepository<ProductImage, ProductImageSearch> {
}
