package kr.co.codiyrabbit.biz.product.service;

import com.google.common.io.Files;
import kr.co.codiyrabbit.biz.product.domain.*;
import kr.co.codiyrabbit.biz.product.repository.ProductImageRepository;
import kr.co.codiyrabbit.biz.product.repository.ProductPointRepository;
import kr.co.codiyrabbit.biz.product.repository.ProductRepository;
import kr.codeblue.common.util.FileUploadUtil;
import kr.codeblue.common.util.StringUtil;
import kr.codeblue.core.BaseService;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Service
public class ProductService implements BaseService<Product, ProductSearch> {

    @Autowired
    ProductRepository productRepository;

    @Autowired
    ProductImageRepository productImageRepository;

    @Autowired
    ProductPointRepository productPointRepository;

    @Autowired
    public FileUploadUtil fileUploadUtil;

    @Override
    public Product get(Product obj) {
        return productRepository.findOne(obj);
    }

    @Override
    public List<Product> getList(ProductSearch search) {
        search.setTotal(this.getListTotal(search));
        return productRepository.findList(search);
    }

    @Override
    public long getListTotal(ProductSearch search) {
        return productRepository.findListTotal(search);
    }

    @Override
    public List<Product> getAll(ProductSearch search) {
        return productRepository.findAll(search);
    }

    public List<Product> getAllWithImage(ProductSearch search) {
        return productRepository.findAllWithImage(search);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void save(Product obj) {

        if( obj.getId() == 0 ){
            productRepository.insert(obj);

        } else {
            this.update(obj);

            // 업데이트 일경우 하위데이터 전부 제거
            productRepository.deleteChild(obj.getId());

        }

        if(!CollectionUtils.isEmpty(obj.getImages())){

            String mainImageName = "";
            String mainImageExt = "";

            /**
             * 메인 이미지만 포인터 저장
             * 메인 이미지명에 따라 유형별 저장
             * ex)
             *  메인파일명 : aaaa.png
             *  캡쳐파일명 : aaaa-capture.png
             */

            // 메인 이미지명에 따라 유형별 저장
            //
            for(ProductImage image : obj.getImages()) {
                if (StringUtils.equals(image.getType(), "MAIN")) {
                    mainImageName = Files.getNameWithoutExtension(image.getFileName());
                    mainImageExt = Files.getFileExtension(image.getFileName());

                    image.setProductId(obj.getId());
                    productImageRepository.insert(image);

                    if( !CollectionUtils.isEmpty(obj.getPoints()) && image.getType().equals( "MAIN" ) ){
                        // 이미지에 대한 포인트 저장
                        for(ProductPoint point: obj.getPoints()){

                            if(StringUtils.equals( image.getViewImageId(), point.getViewImageId() )){
                                point.setProductId(obj.getId());
                                point.setProductImageId(image.getId());
                                productPointRepository.insert(point);

                                // 포인트에 대한 아이템 저장
                                if( !CollectionUtils.isEmpty(point.getItems()) ) {
                                    productPointRepository.insertAllItem(point);
                                }

                            }
                        }
                    }

                    break;
                }
            }

            // 이미지 저장
            for(ProductImage image : obj.getImages()){

                // 업로드 디렉토리 생성
                File moveFolder = new File(fileUploadUtil.getUploadPath() + image.getFilePath());
                if( !moveFolder.exists() ){
                    moveFolder.mkdirs();
                }

                // temp 에 저장된 이미지를 옮긴다.
                File tmpFile = new File(System.getProperty("java.io.tmpdir") + "/codiyrabbit" + image.getFilePath() + "/" + image.getFileName());
                File moveFile = null;

                if( StringUtils.equals( image.getType(), "MAIN" ) ){
                    moveFile = new File(fileUploadUtil.getUploadPath() + image.getFilePath() + "/" + image.getFileName());

                } else {
                    // 메인 이미지 파일 기준으로 이름 변경
                    String typeName = image.getType();
                    if(StringUtils.equals(typeName, "CAPTURE")) typeName = "cap";
                    if(StringUtils.equals(typeName, "ORIGINAL")) typeName = "ori";
                    moveFile = new File(fileUploadUtil.getUploadPath() + image.getFilePath() + "/" + mainImageName + "-" + typeName + "." + mainImageExt);
                }

                try {

                    FileUtils.moveFile(tmpFile, moveFile);

                    if( StringUtils.equals( image.getType(), "MAIN" ) ){
                        // 메인 이미지의 경우 썸네일 이미지 생성
//                        File thumbFile = new File(fileUploadUtil.getUploadPath() + image.getFilePath() + "/" + mainImageName + "-thumb" + "." + mainImageExt);

                        //썸네일 생성
//                        fileUploadUtil.resizeImage(moveFile, thumbFile, 240);
                    }

                    if( StringUtils.equals( image.getType(), "ORIGINAL" ) ){
                        // 원본 이미지의 경우 사이즈는 최대 1920
                        fileUploadUtil.resizeImage(moveFile, moveFile, 1920);
                    }

                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
        }
    }

    @Override
    public void update(Product obj) {
        productRepository.update(obj);
    }

    @Override
    public void remove(Product obj) {
        productRepository.delete(obj);
    }

    public String getCode(){
        String code = "";
        String pattern = "abcdefghijklmnopqrstuvwxyz";
        pattern += pattern.toUpperCase();

        for(int i=0; i<10; i++){
            int rndNo = (int)(Math.random() * pattern.length());
            if( rndNo >= pattern.length() ){
                rndNo = pattern.length()-1;
            }
            code = pattern.substring(rndNo, rndNo+1);

            rndNo = (int)(Math.random() * pattern.length());
            if( rndNo >= pattern.length() ){
                rndNo = pattern.length()-1;
            }
            code += pattern.substring(rndNo, rndNo+1);

            rndNo = (int)(Math.random() * 9999);
            String no = String.format("%04d", rndNo);

            code += no;

            ProductSearch search = new ProductSearch();
            search.setCode(code);
            search.setIsDelete("N");

            if( CollectionUtils.isEmpty(productRepository.findAll(search)) ){
                return code;

            }
        }

        return null;
    }

    public Product getByCode(String code){
        return productRepository.findOneByCode(code);
    }

    public void saveViewCount(long id){
        productRepository.updateViewCount(id);
    }

    public void removeByIds(ProductSearch search) {
        for( long id: search.getIds() ){
            productRepository.deleteChild(id);
            productRepository.delete(new Product(id));
        }
    }
}
