package kr.codeblue.common.util;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.HttpMethod;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.*;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

public class AmazonS3Util {
	
	private static Logger log = Logger.getLogger(AmazonS3Util.class.getClass());
	
	public static final String ACCESSKEY = "AKIAJKM7NLNJ4PE4FXDA";
	public static final String SECRETKEY = "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";
	
	public static final String URL_TYPE_DOWNLOAD = "download";
	public static final String URL_TYPE_VIEW = "view";
	
	private static void putS3Object(ObjectMetadata meta, PutObjectRequest putObjectRequest){
		BasicAWSCredentials awsCreds = new BasicAWSCredentials(ACCESSKEY, SECRETKEY);
		AmazonS3 s3client = new AmazonS3Client(awsCreds);
		try {
			log.info("Uploading a new object to S3 from a file : " + putObjectRequest.getKey() + "\n");
			s3client.putObject(putObjectRequest);
			
		} catch (AmazonServiceException ase) {
			log.error("Caught an AmazonServiceException, which " +
					"means your request made it " +
					"to Amazon S3, but was rejected with an error response" +
					" for some reason.");
			log.error("Error Message:    " + ase.getMessage());
			log.error("HTTP Status Code: " + ase.getStatusCode());
			log.error("AWS Error Code:   " + ase.getErrorCode());
			log.error("Error Type:       " + ase.getErrorType());
			log.error("Request ID:       " + ase.getRequestId());
		} catch (AmazonClientException ace) {
			log.error("Caught an AmazonClientException, which " +
					"means the client encountered " +
					"an internal error while trying to " +
					"communicate with S3, " +
					"such as not being able to access the network.");
			log.error("Error Message: " + ace.getMessage());
		}
	}
	
	/**
	 * s3 object upload
	 * @param bucketName
	 * @param file
	 * @throws IOException 
	 */
	public static void putS3Object(String bucketName, MultipartFile multipartFile) throws IOException{
		ObjectMetadata meta = new ObjectMetadata();
		meta.setContentLength(multipartFile.getSize());
		meta.setContentType(multipartFile.getContentType());
		meta.setContentEncoding("UTF-8");
		
		PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, multipartFile.getOriginalFilename(), multipartFile.getInputStream(), meta);
		
		AmazonS3Util.putS3Object(meta, putObjectRequest);
	}
	
	/**
	 * s3 object upload
	 * @param bucketName
	 * @param file
	 * @throws IOException 
	 */
	public static void putS3PublicObject(String bucketName, MultipartFile multipartFile, String newFileName) throws IOException{
		
		String subPath = "";
		String[] arrBucketName = bucketName.split("\\/");
		if( arrBucketName.length > 1 ){
			bucketName = arrBucketName[0];
			subPath = arrBucketName[1];
		}
		
		ObjectMetadata meta = new ObjectMetadata();
		meta.setContentLength(multipartFile.getSize());
		meta.setContentType(multipartFile.getContentType());
		meta.setContentEncoding("UTF-8");
		
		PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, subPath + "/" + newFileName, multipartFile.getInputStream(), meta);
		
		AmazonS3Util.putS3Object(meta, putObjectRequest.withCannedAcl( CannedAccessControlList.PublicRead ));
	}
	
	/**
	 * s3 object upload
	 * @param bucketName
	 * @param file
	 * @throws IOException 
	 */
	public static void putS3PublicObject(String bucketName, File file, String newFileName) throws IOException{
		
		String subPath = "";
		String[] arrBucketName = bucketName.split("\\/");
		if( arrBucketName.length > 1 ){
			bucketName = arrBucketName[0];
			subPath = arrBucketName[1];
		}
		ObjectMetadata meta = new ObjectMetadata();
		meta.setContentEncoding("UTF-8");
		PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, subPath + "/" + newFileName, file);
		
		AmazonS3Util.putS3Object(meta, putObjectRequest.withCannedAcl( CannedAccessControlList.PublicRead ));
	}
	
	/**
	 * s3 object upload
	 * @param bucketName
	 * @param file
	 */
	public static void putS3Object(String bucketName, String fileName, InputStream is){
		ObjectMetadata meta = new ObjectMetadata();
		meta.setContentEncoding("UTF-8");
		
		PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, fileName, is, meta);
		
		AmazonS3Util.putS3Object(meta, putObjectRequest);
	}
	
	/**
	 * s3 object upload
	 * @param bucketName
	 * @param file
	 */
	public static void putS3Object(String bucketName, File file){
		ObjectMetadata meta = new ObjectMetadata();
		meta.setContentEncoding("UTF-8");
		
		PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, file.getName(), file);
		
		AmazonS3Util.putS3Object(meta, putObjectRequest);
	}
	
	/**
	 * s3 object download url
	 * @param bucketName
	 * @param fileName
	 * @param second
	 * @return
	 */
	public static String getS3ObjectUrl(String bucketName, String fileName, int second, String downloadName, String urlType){
		if( downloadName == null ){
			downloadName = "thedays-movie.mp4";
		}
		
		String[] arrBucketName = bucketName.split("\\/");
		if( arrBucketName.length > 1 ){
			bucketName = arrBucketName[0];
			fileName = arrBucketName[1] + "/" + fileName;
		}
		
		BasicAWSCredentials awsCreds = new BasicAWSCredentials(ACCESSKEY, SECRETKEY);
		AmazonS3 s3Client = new AmazonS3Client(awsCreds);
		
		java.util.Date expiration = null;
		if( second > 0 ){
			expiration = new java.util.Date();
			long msec = expiration.getTime();
			msec += 1000 * second; // 1 minute.
			expiration.setTime(msec);
		}
		
		GeneratePresignedUrlRequest generatePresignedUrlRequest = 
	              new GeneratePresignedUrlRequest(bucketName, fileName);
		
		if( urlType.equals( AmazonS3Util.URL_TYPE_DOWNLOAD ) ){
			try {
				downloadName = URLEncoder.encode(downloadName, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			//강제 다운로드
			ResponseHeaderOverrides responseHeaders = new ResponseHeaderOverrides();
			responseHeaders.setContentType("application/octet-stream");
			responseHeaders.setContentDisposition("attachment; filename=\"" + downloadName + "\"");
			
			generatePresignedUrlRequest.setResponseHeaders(responseHeaders);
		}
		
		generatePresignedUrlRequest.setMethod(HttpMethod.GET); // Default.
		
		if( expiration != null ){
			generatePresignedUrlRequest.setExpiration(expiration);
		}
		             
		URL downloadUrl = s3Client.generatePresignedUrl(generatePresignedUrlRequest);
		
		log.info("------------ " + downloadUrl.toString());
		
		return downloadUrl.toString();
	}
	
	/**
	 * s3 object delete
	 * @param bucketName
	 * @param fileName
	 */
	public static void deleteS3ObjectUrl(String bucketName, String fileName){
		String[] arrBucketName = bucketName.split("\\/");
		if( arrBucketName.length > 1 ){
			bucketName = arrBucketName[0];
			fileName = arrBucketName[1] + "/" + fileName;
		}
		
		BasicAWSCredentials awsCreds = new BasicAWSCredentials(ACCESSKEY, SECRETKEY);
		AmazonS3 s3Client = new AmazonS3Client(awsCreds);
		s3Client.deleteObject(bucketName, fileName);
	}
}
