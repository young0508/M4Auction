package com.auction.dao;

import com.auction.vo.ProductDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.auction.common.JDBCTemplate.*;

public class AdminDAO {

    /** 전체 상품 수 조회 */
    public int selectTotalProducts(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tbl_product";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /** 승인 대기 상품 수 조회 (status = 'W') */
    public int selectPendingProducts(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tbl_product WHERE status = 'W'";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /** 전체 입찰 건수 조회 */
    public int selectTotalBids(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bid";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /** 총 낙찰 금액 합계 조회 (status = 'F') */
    public long selectTotalRevenue(Connection conn) throws SQLException {
        String sql = "SELECT NVL(SUM(final_price), 0) FROM tbl_product WHERE status = 'F'";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return 0L;
    }

    /** 승인 대기 중인 상품 목록 조회 (status = 'W') */
    public List<ProductDTO> selectPendingProductsList(Connection conn) throws SQLException {
        String sql = "SELECT product_id, product_name, start_price, image_renamed_name, seller_id "
                   + "FROM tbl_product WHERE status = 'W' ORDER BY product_id DESC";
        List<ProductDTO> list = new ArrayList<>();
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                ProductDTO dto = new ProductDTO();
                dto.setProductId(rs.getInt("product_id"));
                dto.setProductName(rs.getString("product_name"));
                dto.setStartPrice(rs.getInt("start_price"));
                dto.setImageRenamedName(rs.getString("image_renamed_name"));
                dto.setSellerId(rs.getString("seller_id"));
                list.add(dto);
            }
        }
        return list;
    }
}
