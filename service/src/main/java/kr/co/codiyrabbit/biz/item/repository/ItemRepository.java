package kr.co.codiyrabbit.biz.item.repository;

import kr.co.codiyrabbit.biz.item.domain.Item;
import kr.co.codiyrabbit.biz.item.domain.ItemSearch;
import kr.codeblue.core.BaseRepository;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface ItemRepository extends BaseRepository<Item, ItemSearch> {

    public void insertAllCategory(Item item);
    public void insertAllProperty(Item item);
    public void deleteByIds(ItemSearch search);
    public List<Item> findAllByPointId(ItemSearch itemSearch);
}
