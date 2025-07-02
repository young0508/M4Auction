// File: src/main/java/com/auction/vo/Member.java
// 역할: 회원 한 명의 정보를 담는 '이름표' 양식입니다. (최종 업그레이드 버전)
package com.auction.vo;

import java.sql.Date;

public class MemberDTO {
    // 기존 필드
    private String memberId;
    private String memberPwd;
    private String memberName;
    private String email;
    private String tel;
    private Date enrollDate;
    private String birthdate;
    private String gender;
    private String mobileCarrier;
    private Long mileage; // 마일리지

    public MemberDTO() {}

    // 회원가입용 생성자
    public MemberDTO(String memberId, String memberPwd, String memberName, String email, String tel,
                  String birthdate, String gender, String mobileCarrier) {
        this.memberId = memberId;
        this.memberPwd = memberPwd;
        this.memberName = memberName;
        this.email = email;
        this.tel = tel;
        this.birthdate = birthdate;
        this.gender = gender;
        this.mobileCarrier = mobileCarrier;
    }

	// --- Getters and Setters ---
    
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }
    public String getMemberPwd() { return memberPwd; }
    public void setMemberPwd(String memberPwd) { this.memberPwd = memberPwd; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTel() { return tel; }
    public void setTel(String tel) { this.tel = tel; }
    public Date getEnrollDate() { return enrollDate; }
    public void setEnrollDate(Date enrollDate) { this.enrollDate = enrollDate; }
    public String getBirthdate() { return birthdate; }
    public void setBirthdate(String birthdate) { this.birthdate = birthdate; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getMobileCarrier() { return mobileCarrier; }
    public void setMobileCarrier(String mobileCarrier) { this.mobileCarrier = mobileCarrier; }
    
    // ======== 새로 추가된 마일리지 Getter/Setter ========
    public long getMileage() {return mileage;}
    public void setMileage(long mileage) {this.mileage = mileage;}
}