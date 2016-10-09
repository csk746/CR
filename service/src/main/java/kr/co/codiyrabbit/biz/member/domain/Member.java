package kr.co.codiyrabbit.biz.member.domain;

import lombok.Data;

import java.io.Serializable;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Data
public class Member implements Serializable {

    long id;
    String loginId;
    String password;
    String role;
    String nickname;
    String sex;
    String email;
    String phone;
    String snsType;
    String snsId;
    int age;
    String area;
    Date createDatetime;
    String isAdmin;

    List<String> roles;

    public Member(){}
    public Member(long id){
        this.id = id;
    }

    public String getName(){
        if( nickname != null )
            return nickname;
        return null;
    }

    public List<String> getRoles(){
        if( role != null )
            return Arrays.asList( role.split(",") );
        return null;
    }
}
