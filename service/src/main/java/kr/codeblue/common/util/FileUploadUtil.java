package kr.codeblue.common.util;

import kr.codeblue.common.result.FileUploadResult;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.*;
import java.util.Random;

@Component
public class FileUploadUtil {

	private Logger log = Logger.getLogger(getClass());

	@Value("#{serviceProp['uploadWebPath']}")
	private String uploadWebPath;

	@Value("#{serviceProp['upload.path']}")
	public String uploadPath;

	private String tempDir;

	public static final int RATIO = 0;
	public static final int SAME = -1;

	/**
	 * multipartfile 객체를 통해 업로드한다.
	 * 
	 * @param formFile
	 * @param realPath
	 * @param isRandomName
	 * @return
	 */
	public FileUploadResult uploadFormFile(MultipartFile formFile, String realPath, boolean isRandomName) {
		InputStream stream;
		String newFileName = null;
		FileUploadResult result = null;

		try {
			if (realPath == null)
				realPath = uploadPath;

			File directory = new File(realPath);
			if (!directory.exists()) {
				directory.mkdirs();
			}

			if (isRandomName)
				newFileName = newRndFileName(realPath,
						formFile.getOriginalFilename());
			else
				newFileName = newFileName(realPath,
						formFile.getOriginalFilename());

			stream = formFile.getInputStream();

			OutputStream bos = new FileOutputStream(realPath + newFileName);
			int bytesRead = 0;
			byte[] buffer = new byte[8192];
			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}

			bos.close();
			stream.close();

			result = new FileUploadResult(formFile, realPath, newFileName);

			log.debug("파일 업로드: " + result.toString());

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * multipartfile 객체를 통해 업로드한다.
	 * 
	 * @param formFile
	 * @param realPath
	 * @param isRandomName
	 * @return
	 */
	public FileUploadResult uploadFormFile(MultipartFile formFile, String realPath, boolean isRandomName, boolean isOverwrite) {
		InputStream stream;
		String newFileName = null;
		FileUploadResult result = null;
		
		try {
			if (realPath == null)
				realPath = uploadPath;
			
			File directory = new File(realPath);
			if (!directory.exists()) {
				directory.mkdirs();
			}
			
			if (isRandomName){
				newFileName = newRndFileName(realPath,
						formFile.getOriginalFilename());
			} else {
				if( isOverwrite ){
					newFileName = formFile.getOriginalFilename();
				} else {
					newFileName = newFileName(realPath, formFile.getOriginalFilename());
				}
			}
			
			stream = formFile.getInputStream();
			
			OutputStream bos = new FileOutputStream(realPath + newFileName);
			int bytesRead = 0;
			byte[] buffer = new byte[8192];
			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			bos.close();
			stream.close();
			
			result = new FileUploadResult(formFile, realPath, newFileName);
			
			log.debug("파일 업로드: " + result.toString());
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * multipartfile 객체를 통해 업로드한다.
	 * @param formFile
	 * @param realPath
	 * @param fileName
	 * @param isOverwrite
	 * @return
	 */
	public FileUploadResult uploadFormFile(MultipartFile formFile, String realPath, String fileName, boolean isOverwrite) {
		InputStream stream;
		String newFileName = null;
		FileUploadResult result = null;
		
		try {
			if (realPath == null)
				realPath = uploadPath;
			
			File directory = new File(realPath);
			if (!directory.exists()) {
				directory.mkdirs();
			}
			
			if( isOverwrite ){
				newFileName = fileName;
			} else {
				newFileName = newFileName(realPath, fileName);
			}
			
			stream = formFile.getInputStream();
			
			OutputStream bos = new FileOutputStream(realPath + newFileName);
			int bytesRead = 0;
			byte[] buffer = new byte[8192];
			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			bos.close();
			stream.close();
			
			result = new FileUploadResult(formFile, realPath, newFileName);
			
			log.debug("파일 업로드: " + result.toString());
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * currentTimeMillis 를 이용한 이름을 가져온다. 확장자는 보존.
	 * 2013-10-25 : 빠른시간으로 저장될때, 같은이름이 붙을수 있음. 뒤에 랜덤한 5자리 숫자 붙임
	 * @param realPath
	 * @param orgFileFullName
	 * @return
	 */
	public String newRndFileName(String realPath, String orgFileFullName) {
		// orgFileFullName = StringUtil.encodingKo(11, orgFileFullName);

		int extIdx = orgFileFullName.lastIndexOf(".");
		String orgFileName = orgFileFullName.substring(0, extIdx);
		String orgFileExtName = orgFileFullName.substring(extIdx,
				orgFileFullName.length());
		String newFileName = "";

		String[] alphabat = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		String addRndName = "";
		Random random = new Random();
		for(int i=0; i<5; i++){
			addRndName += alphabat[random.nextInt(alphabat.length)];
		}
		newFileName = System.currentTimeMillis() + addRndName + orgFileExtName;

		return newFileName;
	}
	
	/**
	 * currentTimeMillis 를 이용한 이름을 가져온다. 확장자는 보존.
	 * @param orgFileFullName
	 * @return
	 */
	public String newRndFileName(String orgFileFullName) {
		// orgFileFullName = StringUtil.encodingKo(11, orgFileFullName);

		int extIdx = orgFileFullName.lastIndexOf(".");
		String orgFileName = orgFileFullName.substring(0, extIdx);
		String orgFileExtName = orgFileFullName.substring(extIdx,
				orgFileFullName.length());
		String newFileName = "";

		String[] alphabat = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		String addRndName = "";
		Random random = new Random();
		for(int i=0; i<5; i++){
			addRndName += alphabat[random.nextInt(alphabat.length)];
		}
		newFileName = System.currentTimeMillis() + addRndName + orgFileExtName;

		return newFileName;
	}

	/**
	 * 기존 파일이 존재 하는지 체크 하고 있으면 (숫자) 로 추가된다.
	 * 
	 * @param realPath
	 * @param orgFileFullName
	 * @return
	 */
	public String newFileName(String realPath, String orgFileFullName) {
		int extIdx = orgFileFullName.lastIndexOf(".");
		String orgFileName = orgFileFullName.substring(0, extIdx);
		String orgFileExtName = orgFileFullName.substring(extIdx,
				orgFileFullName.length());
		String newFileName = "";

		boolean isFile = false;

		File file = new File(realPath + orgFileFullName);

		int fileCnt = 0;

		if (file.isFile()) {
			while (!isFile) {
				newFileName = orgFileName + "(" + fileCnt + ")"
						+ orgFileExtName;

				File tmp = new File(realPath + newFileName);

				if (tmp.isFile())
					isFile = false;
				else
					isFile = true;

				fileCnt++;
			}

		} else {
			newFileName = orgFileFullName;

		}

		return newFileName;
	}

	public String getUploadWebPath() {
		return uploadWebPath;
	}

	public void setUploadWebPath(String uploadWebPath) {
		this.uploadWebPath = uploadWebPath;
	}

	public String getUploadPath() {
		return uploadPath;
	}
	
	public String getUploadPath(String subPath){
		return uploadPath + File.separator + subPath + File.separator;
	}

	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}

	/**
	 * java 기본 temp 폴더를 가져온다.
	 * 
	 * @param subDir
	 * @return
	 */
	public String getTempDir(String subDir) {
		String tmpDir = System.getProperty("java.io.tmpdir");
		if (subDir != null && !subDir.equals("")) {
			tmpDir += subDir + File.separator;
			File tmp = new File(tmpDir);
			if (!tmp.exists())
				tmp.mkdirs();
		}
		return tmpDir;
	}

	// 소스파일, 타겟파일, 최대값
	public void resizeImage(File src, File dest, int boxsize)
			throws IOException {
		int width = 0;
		int height = 0;
		Image srcImg = getImage(src);
		int srcWidth = srcImg.getWidth(null);
		int srcHeight = srcImg.getHeight(null);
		if (srcWidth > srcHeight) {
			width = boxsize;
			height = (int) ((double) boxsize / (double) srcWidth);
		} else if (srcWidth < srcHeight) {
			width = (int) ((double) boxsize / (double) srcHeight);
			height = boxsize;
		} else {
			width = boxsize;
			height = boxsize;
		}
		try {
			if (srcWidth <= boxsize && srcHeight <= boxsize)
				resizeImage(src, dest, -1, -1);
			else
				resizeImage(src, dest, width, height);
		} catch (IOException e) {
			throw e;
		}
	}

	// 소스파일, 타겟파일, 넓이, 높이
	public void resizeImage(File src, File dest, int width, int height)
			throws IOException {
		Image srcImg = getImage(src);
		int srcWidth = srcImg.getWidth(null);
		int srcHeight = srcImg.getHeight(null);
		int destWidth = -1, destHeight = -1;
		if (width == SAME)
			destWidth = srcWidth;
		else if (width > 0)
			destWidth = width;
		if (height == SAME)
			destHeight = srcHeight;
		else if (height > 0)
			destHeight = height;
		if (width == RATIO && height == RATIO) {
			destWidth = srcWidth;
			destHeight = srcHeight;
		} else if (width == RATIO) {
			double ratio = ((double) destHeight) / ((double) srcHeight);
			destWidth = (int) ((double) srcWidth * ratio) - 1;
		} else if (height == RATIO) {
			double ratio = ((double) destWidth) / ((double) srcWidth);
			destHeight = (int) ((double) srcHeight * ratio) - 1;
		}
		Image imgTarget = srcImg.getScaledInstance(destWidth, destHeight,
				Image.SCALE_SMOOTH);
		int pixels[] = new int[destWidth * destHeight];
		PixelGrabber pg = new PixelGrabber(imgTarget, 0, 0, destWidth,
				destHeight, pixels, 0, destWidth);
		try {
			pg.grabPixels();
		} catch (InterruptedException e) {
			throw new IOException(e.getMessage());
		}
		BufferedImage destImg = new BufferedImage(destWidth, destHeight,
				BufferedImage.TYPE_INT_RGB);
		destImg.setRGB(0, 0, destWidth, destHeight, pixels, 0, destWidth);
		ImageIO.write(destImg, "jpg", dest);
	}

	// 소스파일, 타겟파일, 최대값
	public void resizeImageCropCenter(File src, File dest, int newWidth, int newHeight)
			throws IOException {

		Image srcImg = getImage(src);
		int sourceWidth = srcImg.getWidth(null);
		int sourceHeight = srcImg.getHeight(null);

		// Compute the scaling factors to fit the new height and width, respectively.
		// To cover the final image, the final scaling will be the bigger
		// of these two.
		float xScale = (float) newWidth / sourceWidth;
		float yScale = (float) newHeight / sourceHeight;
		float scale = Math.max(xScale, yScale);

		// Now get the size of the source bitmap when scaled
		Float scaledWidth = scale * sourceWidth;
		Float scaledHeight = scale * sourceHeight;

		int destWidth = scaledWidth.intValue();
		int destHeight = scaledHeight.intValue();

		// Let's find out the upper left coordinates if the scaled bitmap
		// should be centered in the new size give by the parameters
		float left = (newWidth - scaledWidth) / 2;
		float top = (newHeight - scaledHeight) / 2;

		Image imgTarget = srcImg.getScaledInstance(destWidth, destHeight, Image.SCALE_SMOOTH);
		int pixels[] = new int[destWidth * destHeight];
		PixelGrabber pg = new PixelGrabber(imgTarget, -(int)left, -(int)top, newWidth, newHeight, pixels, 0, destWidth);
		try {
			pg.grabPixels();
		} catch (InterruptedException e) {
			throw new IOException(e.getMessage());
		}

		BufferedImage destImg = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
		destImg.setRGB(0, 0, newWidth, newHeight, pixels, 0, destWidth);
		ImageIO.write(destImg, "jpg", dest);
	}

	public Image getImage(File src) throws IOException {
		Image srcImg = null;
		String suffix = src.getName()
				.substring(src.getName().lastIndexOf('.') + 1).toLowerCase();
		if (suffix.equals("bmp"))
			srcImg = ImageIO.read(src);
		else
			srcImg = new ImageIcon(src.toURI().toURL()).getImage();
		return srcImg;
	}

}