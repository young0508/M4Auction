package com.auction.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.auction.common.JDBCTemplate;

public class BidDAO {
	public BidDAO() {this.conn = JDBCTemplate.getConnection();}
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	
	//현재 최고가 조회
	public int getCurrentPrice(int itemId) throws  ClassNotFoundException, SQLException {
		int price = 0;
		String sql="select CURRENT_PRICE from AUCTION_ITEM where ITEM_ID = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, itemId);
		rs = pstmt.executeQuery();
		if(rs.next()) {
			price = rs.getInt("CURRENT_PRICE");
		}
		close(); // 연결정리
		return price;
	}
	// 최고가 및 입찰자 갱신
	public void updateCurrentPriceAndBidder(int itemId, int price, String bidderId) throws ClassNotFoundException, SQLException {
		String sql = "update AUCTION_ITEM set CURRENT_PRICE = ? , HIGHEST_BIDDER_ID = ? where ITEM_ID = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, price);
		pstmt.setString(2, bidderId);
		pstmt.setInt(3, itemId);
		pstmt.executeUpdate();
		close();
	}
	//입찰자 기록 삽입
	public void insertBid(int itemId, String bidderId, int bidPrice) throws ClassNotFoundException, SQLException {
	    String sql = "insert into BID (ITEM_ID, BIDDER_ID, BID_PRICE, BID_TIME) VALUES (?, ?, ?, SYSDATE)";
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, itemId);
	    pstmt.setString(2, bidderId);
	    pstmt.setInt(3, bidPrice);
	    pstmt.executeUpdate();
	    close();
	}
	
	//자원 정리
	private void close() {
	    try { if (rs != null) rs.close(); } catch (Exception e) {}
	    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	    try { if (conn != null) conn.close(); } catch (Exception e) {}
	}

	
}
