// File: src/main/java/com/auction/dao/MemberDAO.java
// 역할: 회원과 관련된 모든 DB 작업을 처리하는 클래스입니다.
package com.auction.dao;

import static com.auction.common.JDBCTemplate.*;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
 

import com.auction.vo.MemberDTO;

public class MemberDAO {

	public MemberDAO() {}
	
	public MemberDTO loginMember(Connection conn, String memberId, String memberPwd) {
	    MemberDTO member = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    try {
	        String sql = "SELECT MEMBER_ID, MEMBER_NAME, EMAIL, MILEAGE FROM USERS WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, memberId);
	        pstmt.setString(2, memberPwd);
	        
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            member = new MemberDTO();
	            member.setMemberId(rs.getString("MEMBER_ID"));
	            member.setMemberName(rs.getString("MEMBER_NAME"));
	            member.setEmail(rs.getString("EMAIL"));
	            
	            // ★ 중요: getInt() 대신 getLong() 사용
	            // 44번째 줄 근처에서 오류가 발생하는 부분
	            try {
	                // 기존 코드 (오류 발생)
	                // member.setMileage(rs.getInt("MILEAGE")); 
	                
	                // 수정된 코드 (오버플로우 방지)
	                member.setMileage(rs.getLong("MILEAGE"));
	                
	            } catch (SQLException e) {
	                System.out.println("마일리지 값 오버플로우 발생: " + e.getMessage());
	                // 오버플로우 발생 시 0으로 설정하거나 다른 처리
	                member.setMileage(0L);
	            }
	        }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        close(rs);
	        close(pstmt);
	    }
	    
	    return member;
	}

    /**
     * 회원가입 기능 (상세 정보 버전) - 최종 수정됨
     */
	  public int enrollMember(Connection conn, MemberDTO m) {
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "INSERT INTO USERS (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, EMAIL, TEL,"
	    		     + "BIRTHDATE, GENDER, MOBILE_CARRIER, ENROLL_DATE, MILEAGE)"
	    			 + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, 0)";

	        try {
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setString(1, m.getMemberId());
	            pstmt.setString(2, m.getMemberPwd());
	            pstmt.setString(3, m.getMemberName());
	            pstmt.setString(4, m.getEmail());
	            pstmt.setString(5, m.getTel());
	            pstmt.setString(6, m.getBirthdate());
	            pstmt.setString(7, m.getGender());
	            pstmt.setString(8, m.getMobileCarrier());

	            result = pstmt.executeUpdate();

	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        return result;
	    }
    
	  public int updateMember(Connection conn, MemberDTO m) {
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE USERS\r\n SET MEMBER_NAME = ?,\r\n EMAIL = ?,\r\n TEL = ?\r\n WHERE MEMBER_ID = ?";
	        
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, m.getMemberName());
	            pstmt.setString(2, m.getEmail());
	            pstmt.setString(3, m.getTel());
	            pstmt.setString(4, m.getMemberId());
	            
	            result = pstmt.executeUpdate();
	            
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        
	        return result;
	    }

	  public int updateMileage(Connection conn, String userId, int amount) {
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE USERS\r\n"
	        		+ "		   SET MILEAGE = MILEAGE + ?\r\n"
	        		+ "		 WHERE MEMBER_ID = ?";
	        
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, amount);
	            pstmt.setString(2, userId);
	            
	            result = pstmt.executeUpdate();
	            
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        
	        return result;
	    }
    
	  public int deductMileage(Connection conn, String userId, int amount) {
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE USERS\r\n"
	        		+ "		   SET MILEAGE = MILEAGE - ?\r\n"
	        		+ "		 WHERE MEMBER_ID = ?";
	        
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, amount);
	            pstmt.setString(2, userId);
	            
	            result = pstmt.executeUpdate();
	            
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        
	        return result;
	    }
	}