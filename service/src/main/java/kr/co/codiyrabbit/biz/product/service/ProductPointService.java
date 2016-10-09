package kr.co.codiyrabbit.biz.product.service;

import kr.co.codiyrabbit.biz.item.domain.ItemSearch;
import kr.co.codiyrabbit.biz.item.repository.ItemRepository;
import kr.co.codiyrabbit.biz.product.domain.ProductPoint;
import kr.co.codiyrabbit.biz.product.domain.ProductPointItem;
import kr.co.codiyrabbit.biz.product.domain.ProductPointSearch;
import kr.co.codiyrabbit.biz.product.repository.ProductPointRepository;
import kr.codeblue.core.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
public class ProductPointService implements BaseService<ProductPoint, ProductPointSearch> {

    @Autowired
    ProductPointRepository productPointRepository;

    @Autowired
    ItemRepository itemRepository;

    @Override
    public ProductPoint get(ProductPoint obj) {
        return productPointRepository.findOne(obj);
    }

    @Override
    public List<ProductPoint> getList(ProductPointSearch search) {
        search.setTotal(this.getListTotal(search));
        return productPointRepository.findList(search);
    }

    @Override
    public long getListTotal(ProductPointSearch search) {
        return productPointRepository.findListTotal(search);
    }

    @Override
    public List<ProductPoint> getAll(ProductPointSearch search) {
        return productPointRepository.findAll(search);
    }

    @Override
    public void save(ProductPoint obj) {
        if( obj.getId() == 0 ){
            productPointRepository.insert(obj);
        } else {
            this.update(obj);
        }
    }

    @Override
    public void update(ProductPoint obj) {
        productPointRepository.update(obj);
    }

    @Override
    public void remove(ProductPoint obj) {
        productPointRepository.delete(obj);
    }

    public List<ProductPoint> getAllWithItem(ProductPointSearch search) {
        search.setOrderBy("ORDER BY T1.name ASC");
        List<ProductPoint> points = productPointRepository.findAll(search);
        for(ProductPoint point: points){
            ItemSearch itemSearch = new ItemSearch();
            itemSearch.setPointId(point.getId());
            itemSearch.setIsPublish(search.getIsPublish());
            point.setItems(itemRepository.findAllByPointId(itemSearch));
        }

        return points;
    }
}
