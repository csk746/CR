package kr.co.codiyrabbit.biz.property.service;

import kr.co.codiyrabbit.biz.property.domain.Property;
import kr.co.codiyrabbit.biz.property.domain.PropertySearch;
import kr.co.codiyrabbit.biz.property.repository.PropertyRepository;
import kr.codeblue.core.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PropertyService implements BaseService<Property, PropertySearch> {

    @Autowired
    PropertyRepository propertyRepository;

    @Override
    public Property get(Property obj) {
        return propertyRepository.findOne(obj);
    }

    @Override
    public List<Property> getList(PropertySearch search) {
        search.setTotal(this.getListTotal(search));
        return propertyRepository.findList(search);
    }

    @Override
    public long getListTotal(PropertySearch search) {
        return propertyRepository.findListTotal(search);
    }

    @Override
    public List<Property> getAll(PropertySearch search) {
        return propertyRepository.findAll(search);
    }

    @Override
    public void save(Property obj) {
        if( obj.getId() == 0 ){
            propertyRepository.insert(obj);
        } else {
            this.update(obj);
        }
    }

    @Override
    public void update(Property obj) {
        propertyRepository.update(obj);
    }

    @Override
    public void remove(Property obj) {
        propertyRepository.delete(obj);
    }
}
