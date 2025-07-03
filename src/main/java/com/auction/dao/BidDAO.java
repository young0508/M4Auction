package com.auction.dao;

import com.auction.vo.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BidDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private Connection getConnection() throws ClassNotFoundException, SQLException {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		return DriverManager.getConnection(
				"jdbc:oracle:thin:@192.168.219.198:1521:orcl", "team01", "1234");
	}
	
	//현재 최고가 조회
	public int getCurrentPrice(int itemId) throws  ClassNotFoundException, SQLException {
		int price = 0;
		String sql="select CURRENT_PRICE from AUCTION_ITEM where ITEM_ID = ?";
		conn = getConnection();
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
		conn = getConnection();
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
	    conn = getConnection();
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, itemId);
	    pstmt.setString(2, bidderId);
	    pstmt.setInt(3, bidPrice);
	    pstmt.executeUpdate();
	    close();
	}
	
	//특정 경매 물품 입찰 내역 조회
	public List<BidDTO> getBidsItemId(int itemId){
		List<BidDTO> bidList = new ArrayList<>();
		String sql = "select BID_ID, ITEM_ID, BIDDER_ID, BID_PRICE, BID_TIME from BID where ITEM_ID = ? order by BID_TIME desc";

		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, itemId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BidDTO bid = new BidDTO();
				bid.setBidId(rs.getInt("BID_ID"));
				bid.setItemId(rs.getInt("ITEM_ID"));
				bid.setBidderId(rs.getString("BIDDER_ID"));
				bid.setBidPrice(rs.getInt("BID_PRICE"));
				bid.setBidTime(rs.getTimestamp("BID_TIME"));
				bidList.add(bid);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close();
		}
		return bidList;
	}
	
	
	//자원 정리
	private void close() {
	    try { if (rs != null) rs.close(); } catch (Exception e) {}
	    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	    try { if (conn != null) conn.close(); } catch (Exception e) {}
	}
	
	public int insertBid(Connection conn, int memberId, int productId, int amount) throws SQLException {
        String sql = "INSERT INTO BID (BID_ID, MEMBER_ID, PRODUCT_ID, BID_AMOUNT, IS_SUCCESSFUL, BID_AT) "
                   + "VALUES (BID_SEQ.NEXTVAL, ?, ?, ?, 0, SYSDATE)";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, memberId);
            p.setInt(2, productId);
            p.setInt(3, amount);
            return p.executeUpdate();
        }
    }

    public BidDTO selectHighestBid(Connection conn, int productId) throws SQLException {
        String sql = "SELECT * FROM (SELECT * FROM BID WHERE PRODUCT_ID=? ORDER BY BID_AMOUNT DESC) WHERE ROWNUM=1";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, productId);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) return map(r);
            }
        }
        return null;
    }

    public List<BidDTO> selectLosingBids(Connection conn, int productId) throws SQLException {
        String sql = "SELECT * FROM BID WHERE PRODUCT_ID=? AND IS_SUCCESSFUL=0";
        List<BidDTO> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, productId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) list.add(map(r));
            }
        }
        return list;
    }

    public int markSuccessful(Connection conn, int bidId) throws SQLException {
        String sql = "UPDATE BID SET IS_SUCCESSFUL=1 WHERE BID_ID=?";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, bidId);
            return p.executeUpdate();
        }
    }

    public int markRefunded(Connection conn, int bidId) throws SQLException {
        String sql = "UPDATE BID SET IS_SUCCESSFUL=2 WHERE BID_ID=?";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, bidId);
            return p.executeUpdate();
        }
    }

    private BidDTO map(ResultSet r) throws SQLException {
        BidDTO b = new BidDTO();
        b.setBidId(r.getInt("BID_ID"));
        b.setMemberId(r.getInt("MEMBER_ID"));
        b.setProductId(r.getInt("PRODUCT_ID"));
        b.setBidAmount(r.getInt("BID_AMOUNT"));
        b.setIsSuccessful(r.getInt("IS_SUCCESSFUL"));
        b.setBidAt(r.getTimestamp("BID_AT"));
        return b;
    }
}
	
	
	
}
