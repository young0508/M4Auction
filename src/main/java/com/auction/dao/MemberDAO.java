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
	
	  public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
	        MemberDTO loginUser = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT * FROM USERS \r\n WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, userId);
	            pstmt.setString(2, userPwd);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                loginUser = new MemberDTO();
	                loginUser.setMemberId(rs.getString("MEMBER_ID"));
	                loginUser.setMemberName(rs.getString("MEMBER_NAME"));
	                loginUser.setEmail(rs.getString("EMAIL"));
	                loginUser.setTel(rs.getString("TEL"));
	                loginUser.setEnrollDate(rs.getDate("ENROLL_DATE"));
	                loginUser.setBirthdate(rs.getString("BIRTHDATE"));
	                loginUser.setGender(rs.getString("GENDER"));
	                loginUser.setMobileCarrier(rs.getString("MOBILE_CARRIER"));
	                loginUser.setMileage(rs.getInt("MILEAGE"));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(rs);
	            close(pstmt);
	        }
	        return loginUser;
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
