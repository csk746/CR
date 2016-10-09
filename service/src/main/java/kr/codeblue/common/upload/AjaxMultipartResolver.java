package kr.codeblue.common.upload;

import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.ProgressListener;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpSession;

public class AjaxMultipartResolver extends CommonsMultipartResolver {
	
	private HttpSession session = null;
	
	@Override
	public org.springframework.web.multipart.MultipartHttpServletRequest resolveMultipart(javax.servlet.http.HttpServletRequest request) throws org.springframework.web.multipart.MultipartException {
		session = request.getSession();
		return super.resolveMultipart(request);
	};
	
	@Override
	protected FileUpload prepareFileUpload(String encoding) {
		FileUpload fileUpload = super.prepareFileUpload(encoding);
		ProgressListener progressListener = new ProgressListener() {
			public void update(long pBytesRead, long pContentLength, int pItems) {
				//System.out.println("We are currently reading item " + pItems);
				
				AjaxUploadStatus ajaxUploadStatus = new AjaxUploadStatus(pBytesRead, pContentLength);
				session.setAttribute("ajaxUploadStatus", ajaxUploadStatus);
				
//				if (pContentLength == -1) {
//					System.out.println("So far, " + pBytesRead + " bytes have been read.");
//				} else {
//					long percent = ( pBytesRead / pContentLength * 100 );
//					Long bytesRead = pBytesRead;
//					Long contentLength = pContentLength;
//					System.out.println( bytesRead.intValue() / contentLength.intValue() );
//					System.out.println("So far, " + pBytesRead + " of " + pContentLength + " ( " + percent + "% ) bytes have been read.");
//				}
			}
		};
		fileUpload.setProgressListener(progressListener);
		return fileUpload;
	}
	
}
