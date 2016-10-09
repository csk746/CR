package kr.codeblue.common.result;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;

public class FileUploadResult {

	private String fullPathFileName;
	
	private String fullFileName;
	
	private String fileName;
	
	private String originalFileName;
	
	private String fileExt;
	
	private Long fileSize;
	
	private String realPath;
	
	private String webPath;
	
	private String contentType;
	
	private File file;
	
	public FileUploadResult(){}
	
	public FileUploadResult(MultipartFile multipartFile, String path, String newFileName){
	
		this.fullPathFileName = path + newFileName;
		this.fullFileName = newFileName;
		this.originalFileName = multipartFile.getOriginalFilename();
		this.fileSize = multipartFile.getSize();
		this.realPath = path;
		this.contentType = multipartFile.getContentType();
		
		int extIdx = newFileName.lastIndexOf(".");
		String name = newFileName.substring(0, extIdx);
		String ext = newFileName.substring(extIdx, newFileName.length());
		
		this.fileName = name;
		this.fileExt = ext;
	}

	public String getFullPathFileName() {
		return fullPathFileName;
	}

	public void setFullPathFileName(String fullPathFileName) {
		this.fullPathFileName = fullPathFileName;
	}

	public String getFullFileName() {
		return fullFileName;
	}

	public void setFullFileName(String fullFileName) {
		this.fullFileName = fullFileName;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public Long getFileSize() {
		return fileSize;
	}

	public void setFileSize(Long fileSize) {
		this.fileSize = fileSize;
	}

	public String getOriginalFileName() {
		return originalFileName;
	}

	public void setOriginalFileName(String originalFileName) {
		this.originalFileName = originalFileName;
	}

	public String getRealPath() {
		return realPath;
	}

	public void setRealPath(String realPath) {
		this.realPath = realPath;
	}

	public String getWebPath() {
		return webPath;
	}

	public void setWebPath(String webPath) {
		this.webPath = webPath;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	
	public File getFile() {
		if( fullPathFileName != null ){
			this.file = new File(fullPathFileName);
		}
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	@Override
	public String toString() {
		return "FileUploadResult [fullPathFileName=" + fullPathFileName
				+ ", fullFileName=" + fullFileName + ", fileName=" + fileName
				+ ", originalFileName=" + originalFileName + ", fileExt="
				+ fileExt + ", fileSize=" + fileSize + ", realPath=" + realPath
				+ ", webPath=" + webPath + ", contentType=" + contentType + "]";
	}

	public void fileDelete(){
		File file = new File(getFullPathFileName());
		if( file.isFile() ) file.delete();
	}
}
