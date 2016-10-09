package kr.co.codiyrabbit.biz.property.repository;

import kr.co.codiyrabbit.biz.property.domain.Property;
import kr.co.codiyrabbit.biz.property.domain.PropertySearch;
import kr.codeblue.core.BaseRepository;
import org.springframework.stereotype.Component;

@Component
public interface PropertyRepository extends BaseRepository<Property, PropertySearch> {
}
