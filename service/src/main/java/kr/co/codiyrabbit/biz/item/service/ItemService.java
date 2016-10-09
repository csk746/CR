package kr.co.codiyrabbit.biz.item.service;

import kr.co.codiyrabbit.biz.item.domain.Item;
import kr.co.codiyrabbit.biz.item.domain.ItemSearch;
import kr.co.codiyrabbit.biz.item.repository.ItemRepository;
import kr.codeblue.core.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.List;

@Service
public class ItemService implements BaseService<Item, ItemSearch> {

    @Autowired
    private ItemRepository itemRepository;

    @Override
    public Item get(Item obj) {
        return itemRepository.findOne(obj);
    }

    @Override
    public List<Item> getList(ItemSearch search) {
        search.setTotal(this.getListTotal(search));
        return itemRepository.findList(search);
    }

    @Override
    public long getListTotal(ItemSearch search) {
        return itemRepository.findListTotal(search);
    }

    @Override
    public List<Item> getAll(ItemSearch search) {
        return itemRepository.findAll(search);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void save(Item obj) {
        if( obj.getId() == 0 ){
            itemRepository.insert(obj);
        } else {
            this.update(obj);
        }
    }

    @Override
    public void update(Item obj) {
        itemRepository.update(obj);
    }

    @Override
    public void remove(Item obj) {
        itemRepository.delete(obj);
    }

    public void removeByIds(ItemSearch search){
        itemRepository.deleteByIds(search);
    }
}
