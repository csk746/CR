package kr.codeblue.common.upload;

import lombok.Data;

@Data public class AjaxUploadStatus {
	
	private long bytesRead;
	private long contentLength;
	
	public AjaxUploadStatus(){}
	public AjaxUploadStatus(long read, long length){
		this.bytesRead = read;
		this.contentLength = length;
	}
}
