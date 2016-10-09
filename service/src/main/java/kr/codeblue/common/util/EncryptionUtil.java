package kr.codeblue.common.util;

public class EncryptionUtil {
	
	public static String encrypt(String txt){
		try {
			return AESCipher.encrypt(txt);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
	
	public static String decrypt(String txt){
		try {
			return AESCipher.decrypt(txt);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
}
