package kr.codeblue.common.util;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;

import java.io.IOException;
import java.util.List;

public class HttpClientUtil {

	/**
	 * URL을 호출 한 데이터
	 * @param url
	 * @param params
	 * @return
	 */
	public static String urlToString(String url, List<NameValuePair> params) {
		// Create an instance of HttpClient.
		HttpClient client = new HttpClient();
		client.getParams().setParameter("http.protocol.content-charset", "UTF-8");

		// Create a method instance.
		PostMethod method = new PostMethod(url);

		// Provide custom retry handler is necessary
		method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
				new DefaultHttpMethodRetryHandler(3, false));
		
		if( params != null ){
			for(NameValuePair param: params){
				method.addParameter(param);
			}
		}

		String result = "";
		
		try {
			// Execute the method.
			int statusCode = client.executeMethod(method);

			if (statusCode != HttpStatus.SC_OK) {
				System.err.println("Method failed: " + method.getStatusLine());
			}

			// Read the response body.
			byte[] responseBody = method.getResponseBody();

			// Deal with the response.
			// Use caution: ensure correct character encoding and is not binary
			// data
//			result = new String(responseBody);
			result = new String(responseBody, "UTF-8");

		} catch (HttpException e) {
			System.err.println("Fatal protocol violation: " + e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			System.err.println("Fatal transport error: " + e.getMessage());
			e.printStackTrace();
		} finally {
			// Release the connection.
			method.releaseConnection();
		}
		
		return result;
	}
	
}
