package kr.codeblue.common.util;

import com.twelvemonkeys.image.ResampleOp;
import org.apache.commons.fileupload.FileItem;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;

public class ImageTransformation {
    public static final String PNG = "png";

    public static byte[] resize(FileItem fileItem, int width, int height) {

        try {
            ResampleOp resampleOp = new ResampleOp(width, height);
            BufferedImage scaledImage = resampleOp.filter(ImageIO.read(fileItem.getInputStream()), null);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(scaledImage, PNG, baos);

            return baos.toByteArray();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public static byte[] resizeAdjustMax(FileItem fileItem, int maxWidth, int maxHeight) {

        try {
            BufferedInputStream bis = new BufferedInputStream(fileItem.getInputStream());
            BufferedImage bufimg = ImageIO.read(bis);

            //check size of image
            int img_width = bufimg.getWidth();
            int img_height = bufimg.getHeight();
            if(img_width > maxWidth || img_height > maxHeight) {
                float factx = (float) img_width / maxWidth;
                float facty = (float) img_height / maxHeight;
                float fact = (factx>facty) ? factx : facty;
                img_width = (int) ((int) img_width / fact);
                img_height = (int) ((int) img_height / fact);
            }

            return resize(fileItem,img_width, img_height);

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
}
