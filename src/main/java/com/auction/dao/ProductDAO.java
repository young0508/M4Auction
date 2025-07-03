// File: src/main/java/com/auction/dao/ProductDAO.java
// 역할: PRODUCT 및 BID 테이블과 관련된 SQL문을 실행하고 결과를 반환하는 클래스입니다.
package com.auction.dao;

import static com.auction.common.JDBCTemplate.*;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import com.auction.common.PageInfo;
import com.auction.vo.Bid;
import com.auction.vo.ProductDTO;

public class ProductDAO {

	public ProductDAO() {}
        
    // --- (다른 메소드들은 기존과 동일) ---

    /**
     * 내가 입찰한 상품 목록을 조회하는 기능 (최종 수정)
     * 이제 이미지 파일 이름도 정확하게 가져옵니다.
     */
    public List<ProductDTO> selectProductsByBidder(Connection conn, String bidderId) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "	SELECT DISTINCT\r\n"
        		+ "		       P.PRODUCT_ID,\r\n"
        		+ "		       P.PRODUCT_NAME,\r\n"
        		+ "		       P.CURRENT_PRICE,\r\n"
        		+ "		       P.IMAGE_RENAMED_NAME\r\n"
        		+ "		  FROM PRODUCT P\r\n"
        		+ "		  JOIN BID B ON (P.PRODUCT_ID = B.PRODUCT_ID)\r\n"
        		+ "		 WHERE B.BIDDER_ID = ?\r\n"
        		+ "		   AND P.STATUS != 'C'\r\n"
        		+ "		 ORDER BY P.PRODUCT_ID DESC";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bidderId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                
                // ======== 수정된 부분! 빠뜨렸던 이미지 파일 이름을 추가합니다. ========
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return list;
    }

    // --- (이하 다른 모든 메소드들은 기존과 동일합니다) ---
    public int selectProductCountByCategory(Connection conn, String category) {
        int listCount = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS COUNT\r\n"
        		+ "		  FROM PRODUCT\r\n"
        		+ "		 WHERE STATUS = 'A'\r\n"
        		+ "		   AND CATEGORY = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                listCount = rs.getInt("COUNT");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return listCount;
    }

    public List<ProductDTO> selectProductListByCategory(Connection conn, String category, PageInfo pi) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql =
            "SELECT * FROM (" +
            "  SELECT ROWNUM RN, T.* FROM (" +
            "    SELECT PRODUCT_ID, PRODUCT_NAME, ARTIST_NAME, PRODUCT_DESC," +
            "           START_PRICE, BUY_NOW_PRICE, CURRENT_PRICE, END_TIME," +
            "           IMAGE_ORIGINAL_NAME, IMAGE_RENAMED_NAME, CATEGORY, SELLER_ID," +
            "           REG_DATE, STATUS" +
            "      FROM PRODUCT" +
            "     WHERE STATUS = 'A'" +
            "       AND CATEGORY = ?" +
            "     ORDER BY PRODUCT_ID DESC" +
            "  ) T" +
            ") WHERE RN BETWEEN ? AND ?";
        try {
            pstmt = conn.prepareStatement(sql);
            int start = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
            int end   = start + pi.getBoardLimit() - 1;
            pstmt.setString(1, category);
            pstmt.setInt(2, start);
            pstmt.setInt(3, end);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(        rs.getInt("PRODUCT_ID"));
                p.setProductName(      rs.getString("PRODUCT_NAME"));
                p.setArtistName(       rs.getString("ARTIST_NAME"));
                p.setProductDesc(      rs.getString("PRODUCT_DESC"));
                p.setStartPrice(       rs.getInt("START_PRICE"));
                p.setBuyNowPrice(      rs.getInt("BUY_NOW_PRICE"));
                p.setCurrentPrice(     rs.getInt("CURRENT_PRICE"));
                p.setEndTime(          rs.getTimestamp("END_TIME"));
                p.setImageOriginalName(rs.getString("IMAGE_ORIGINAL_NAME"));
                p.setImageRenamedName( rs.getString("IMAGE_RENAMED_NAME"));
                p.setCategory(         rs.getString("CATEGORY"));
                p.setSellerId(         rs.getString("SELLER_ID"));
                p.setRegDate(          rs.getDate("REG_DATE"));
                p.setStatus(           rs.getString("STATUS"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return list;
    }
    
    public int searchProductCount(Connection conn, String keyword) {
        int listCount = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS COUNT\r\n"
        		+ "FROM PRODUCT\r\n"
        		+ "WHERE STATUS = 'A'\r\n"
        		+ "AND (PRODUCT_NAME LIKE ? OR ARTIST_NAME LIKE ?)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            if(rs.next()) { listCount = rs.getInt("COUNT"); }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return listCount;
    }

 // 2) 키워드 검색 페이지 처리
    public List<ProductDTO> searchProductList(Connection conn, String keyword, PageInfo pi) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql =
            "SELECT * FROM (" +
            "  SELECT ROWNUM RN, T.* FROM (" +
            "    SELECT PRODUCT_ID, PRODUCT_NAME, ARTIST_NAME, PRODUCT_DESC," +
            "           START_PRICE, BUY_NOW_PRICE, CURRENT_PRICE, END_TIME," +
            "           IMAGE_ORIGINAL_NAME, IMAGE_RENAMED_NAME, CATEGORY, SELLER_ID," +
            "           REG_DATE, STATUS" +
            "      FROM PRODUCT" +
            "     WHERE STATUS = 'A'" +
            "       AND (PRODUCT_NAME LIKE ? OR ARTIST_NAME LIKE ?)" +
            "     ORDER BY PRODUCT_ID DESC" +
            "  ) T" +
            ") WHERE RN BETWEEN ? AND ?";
        try {
            pstmt = conn.prepareStatement(sql);
            int start = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
            int end   = start + pi.getBoardLimit() - 1;
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setInt(3, start);
            pstmt.setInt(4, end);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(        rs.getInt("PRODUCT_ID"));
                p.setProductName(      rs.getString("PRODUCT_NAME"));
                p.setArtistName(       rs.getString("ARTIST_NAME"));
                p.setProductDesc(      rs.getString("PRODUCT_DESC"));
                p.setStartPrice(       rs.getInt("START_PRICE"));
                p.setBuyNowPrice(      rs.getInt("BUY_NOW_PRICE"));
                p.setCurrentPrice(     rs.getInt("CURRENT_PRICE"));
                p.setEndTime(          rs.getTimestamp("END_TIME"));
                p.setImageOriginalName(rs.getString("IMAGE_ORIGINAL_NAME"));
                p.setImageRenamedName( rs.getString("IMAGE_RENAMED_NAME"));
                p.setCategory(         rs.getString("CATEGORY"));
                p.setSellerId(         rs.getString("SELLER_ID"));
                p.setRegDate(          rs.getDate("REG_DATE"));
                p.setStatus(           rs.getString("STATUS"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return list;
    }

    public int selectProductCount(Connection conn) {
        int listCount = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS COUNT\r\n"
        		+ "FROM PRODUCT \r\n"
        		+ "WHERE STATUS = 'A'";
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if(rs.next()) { listCount = rs.getInt("COUNT"); }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return listCount;
    }

    public List<ProductDTO> selectProductList(Connection conn, PageInfo pi) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql =
            "SELECT * FROM (" +
            "  SELECT ROWNUM RN, T.* FROM (" +
            "    SELECT PRODUCT_ID, PRODUCT_NAME, ARTIST_NAME, PRODUCT_DESC," +
            "           START_PRICE, BUY_NOW_PRICE, CURRENT_PRICE, END_TIME," +
            "           IMAGE_ORIGINAL_NAME, IMAGE_RENAMED_NAME, CATEGORY, SELLER_ID," +
            "           REG_DATE, STATUS" +
            "      FROM PRODUCT" +
            "     WHERE STATUS = 'A'" +
            "     ORDER BY PRODUCT_ID DESC" +
            "  ) T" +
            ") WHERE RN BETWEEN ? AND ?";
        try {
            pstmt = conn.prepareStatement(sql);
            int start = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
            int end   = start + pi.getBoardLimit() - 1;
            pstmt.setInt(1, start);
            pstmt.setInt(2, end);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(        rs.getInt("PRODUCT_ID"));
                p.setProductName(      rs.getString("PRODUCT_NAME"));
                p.setArtistName(       rs.getString("ARTIST_NAME"));
                p.setProductDesc(      rs.getString("PRODUCT_DESC"));
                p.setStartPrice(       rs.getInt("START_PRICE"));
                p.setBuyNowPrice(      rs.getInt("BUY_NOW_PRICE"));
                p.setCurrentPrice(     rs.getInt("CURRENT_PRICE"));
                p.setEndTime(          rs.getTimestamp("END_TIME"));
                p.setImageOriginalName(rs.getString("IMAGE_ORIGINAL_NAME"));
                p.setImageRenamedName( rs.getString("IMAGE_RENAMED_NAME"));
                p.setCategory(         rs.getString("CATEGORY"));
                p.setSellerId(         rs.getString("SELLER_ID"));
                p.setRegDate(          rs.getDate("REG_DATE"));
                p.setStatus(           rs.getString("STATUS"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return list;
    }

    public ProductDTO selectProductById(Connection conn, int productId) {
        ProductDTO p = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM PRODUCT\r\n WHERE PRODUCT_ID = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setArtistName(rs.getString("ARTIST_NAME"));
                p.setProductDesc(rs.getString("PRODUCT_DESC"));
                p.setStartPrice(rs.getInt("START_PRICE"));
                p.setBuyNowPrice(rs.getInt("BUY_NOW_PRICE"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                p.setEndTime(rs.getTimestamp("END_TIME"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                p.setSellerId(rs.getString("SELLER_ID"));
                p.setRegDate(rs.getDate("REG_DATE"));
                p.setStatus(rs.getString("STATUS"));
                p.setCategory(rs.getString("CATEGORY"));
                p.setWinnerId(rs.getString("WINNER_ID"));
                p.setFinalPrice(rs.getInt("FINAL_PRICE"));
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return p;
    }
    
    public int insertBid(Connection conn, Bid b) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO BID (BID_ID, PRODUCT_ID, BIDDER_ID, BID_PRICE, BID_TIME)\r\n"
        		+ "		VALUES (SEQ_BID_ID.NEXTVAL, ?, ?, ?, SYSDATE)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, b.getProductId());
            pstmt.setString(2, b.getBidderId());
            pstmt.setInt(3, b.getBidPrice());
            result = pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(pstmt); }
        return result;
    }
    
    public int updateCurrentPrice(Connection conn, int productId, int bidPrice) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "	UPDATE PRODUCT\r\n SET CURRENT_PRICE = ?\r\n WHERE PRODUCT_ID = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, bidPrice);
            pstmt.setInt(2, productId);
            result = pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(pstmt); }
        return result;
    }

    public int insertProduct(Connection conn, ProductDTO p) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO PRODUCT (\r\n"
        		+ "			PRODUCT_ID, PRODUCT_NAME, ARTIST_NAME, PRODUCT_DESC, \r\n"
        		+ "			START_PRICE, BUY_NOW_PRICE, CURRENT_PRICE, END_TIME, \r\n"
        		+ "			IMAGE_ORIGINAL_NAME, IMAGE_RENAMED_NAME, CATEGORY, SELLER_ID, \r\n"
        		+ "			REG_DATE, STATUS\r\n"
        		+ "		) VALUES (\r\n"
        		+ "			SEQ_PRODUCT_ID.NEXTVAL, ?, ?, ?,\r\n"
        		+ "			?, ?, 0, ?,\r\n"
        		+ "			?, ?, ?, ?, \r\n"
        		+ "			SYSDATE, 'P'\r\n"
        		+ "		)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, p.getProductName());
            pstmt.setString(2, p.getArtistName());
            pstmt.setString(3, p.getProductDesc());
            pstmt.setInt(4, p.getStartPrice());
            if (p.getBuyNowPrice() > 0) {
                pstmt.setInt(5, p.getBuyNowPrice());
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            pstmt.setTimestamp(6, p.getEndTime());
            pstmt.setString(7, p.getImageOriginalName());
            pstmt.setString(8, p.getImageRenamedName());
            pstmt.setString(9, p.getCategory());
            pstmt.setString(10, p.getSellerId());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        return result;
    }

    public List<ProductDTO> selectProductsBySeller(Connection conn, String sellerId) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT PRODUCT_ID, PRODUCT_NAME, CURRENT_PRICE, IMAGE_RENAMED_NAME\r\n"
        		+ "		  FROM PRODUCT\r\n"
        		+ "		 WHERE SELLER_ID = ?\r\n"
        		+ "		   AND STATUS = 'A' \r\n"
        		+ "		 ORDER BY PRODUCT_ID DESC";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sellerId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return list;
    }
    
    public int deleteProduct(Connection conn, int productId, String memberId) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "	UPDATE PRODUCT\r\n"
        		+ "		   SET STATUS = 'C'\r\n"
        		+ "		 WHERE PRODUCT_ID = ?\r\n"
        		+ "		   AND SELLER_ID = ?";
        
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            pstmt.setString(2, memberId);
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        
        return result;
    }

    public Bid findWinner(Connection conn, int productId) {
        Bid winner = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT *\r\n"
        		+ "		  FROM (\r\n"
        		+ "		        SELECT BIDDER_ID, BID_PRICE\r\n"
        		+ "		          FROM BID\r\n"
        		+ "		         WHERE PRODUCT_ID = ?\r\n"
        		+ "		         ORDER BY BID_PRICE DESC\r\n"
        		+ "		       )\r\n"
        		+ "		 WHERE ROWNUM = 1";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                winner = new Bid();
                winner.setBidderId(rs.getString("BIDDER_ID"));
                winner.setBidPrice(rs.getInt("BID_PRICE"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return winner;
    }

    public int updateProductWinner(Connection conn, int productId, String winnerId, int finalPrice) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "UPDATE PRODUCT\r\n SET WINNER_ID = ?,\r\n FINAL_PRICE = ?\r\n WHERE PRODUCT_ID = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, winnerId);
            pstmt.setInt(2, finalPrice);
            pstmt.setInt(3, productId);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        return result;
    }
    
    public int updateProductStatus(Connection conn, int productId, String status) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "	UPDATE PRODUCT\r\n SET STATUS = ?\r\n WHERE PRODUCT_ID = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, productId);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        return result;
    }
    public List<ProductDTO> selectWonProducts(Connection conn, String winnerId) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "		SELECT \r\n"
        		+ "		       PRODUCT_ID,\r\n"
        		+ "		       PRODUCT_NAME,\r\n"
        		+ "		       FINAL_PRICE,\r\n"
        		+ "		       IMAGE_RENAMED_NAME,\r\n"
        		+ "		       STATUS\r\n"
        		+ "		  FROM PRODUCT\r\n"
        		+ "		 WHERE WINNER_ID = ?\r\n"
        		+ "		 ORDER BY PRODUCT_ID DESC";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, winnerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setFinalPrice(rs.getInt("FINAL_PRICE"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                p.setStatus(rs.getString("STATUS")); // 결제 여부 확인을 위해 상태 추가
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return list;
    }
    
    // 가장 최근에 시퀀스로 생성된 PRODUCT_ID를 반환 (insert 직후에 호출해야 함)
    public int selectLastInsertedProductId(Connection conn) throws SQLException {
        String sql = "SELECT SEQ_PRODUCT_ID.CURRVAL FROM DUAL";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1; // 실패 시 -1 반환
    }
    /** 1) 입찰 처리: 마일리지 차감 + BID 테이블 저장 */
    public boolean placeBid(Connection conn, int memberId, int productId, int bidAmount) throws SQLException {
        MemberDAO mDao = new MemberDAO();
        BidDAO bDao       = new BidDAO();   // 기존에 BidDAO가 없으면 ProductDAO 내부에 삽입해도 무방
        // 1. 마일리지 차감
        int updated = mDao.updateMileage(conn, memberId, -bidAmount);
        if (updated != 1) return false;

        // 2. BID 테이블에 저장
        int inserted = bDao.insertBid(conn, memberId, productId, bidAmount);
        return inserted == 1;
    }
    /** 2) 경매 마감 처리: 낙찰 + 환불 + 스케줄 상태 변경 */
    public void closeAuction(Connection conn, int productId, int scheduleId) throws SQLException {
        BidDAO bDao       = new BidDAO();
        ScheduleDAO sDao  = new ScheduleDAO();
        MemberDAO mDao    = new MemberDAO();

        // 1) 최고 입찰자 가져오기
        BidDTO winner = bDao.selectHighestBid(conn, productId);
        if (winner != null) {
            // 낙찰 처리
            bDao.markSuccessful(conn, winner.getBidId());

            // 2) 나머지 입찰자들 환불
            List<BidDTO> losers = bDao.selectLosingBids(conn, productId);
            for (BidDTO loser : losers) {
                mDao.updateMileage(conn, loser.getMemberId(), loser.getBidAmount());
                bDao.markRefunded(conn, loser.getBidId());
            }
        }

        // 3) SCHEDULE 상태 “종료됨”으로 변경
        sDao.updateScheduleStatus(conn, scheduleId, "종료됨");
    }
}
    
}
