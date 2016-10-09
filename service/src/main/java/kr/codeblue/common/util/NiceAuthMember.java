package kr.codeblue.common.util;

import lombok.Data;

@Data public class NiceAuthMember {

	String vNumber; // 가상주민번호 (13자리이며, 숫자 또는 문자 포함)
	String name;	// 이름
	String dupInfo;	// 중복가입코드 (DI - 64 byt고유값)
	String ageCode;	// 연령대 코드 (개발 가이드 참조)
	String genderCode;// 성별 코드 (개발 가이드 참조)
	String birthDate;// 생년월일 (YYYYMMDD)
	String nationalInfo;	// 내/외국인 정보 
	String requestNum;// CP 요청번호
	
}
