// File: src/main/java/com/auction/vo/Bid.java
// 역할: BID 테이블의 한 행의 데이터를 저장하고 옮기는 데 사용되는 객체 (Value Object)
package com.auction.vo;
import java.sql.Date;

public class BidDTO {
    // 필드는 BID 테이블의 컬럼과 1:1로 매핑되도록 작성합니다.
    private int bidId;
    private int productId;      // product_id -> productId로 수정 (자바 네이밍 컨벤션)
    private String memberId;    // member_id -> memberId로 수정 (자바 네이밍 컨벤션)
    private int bidPrice;
    private Date bidTime;
    private int isSuccessful;
    
    // 기본 생성자
    public BidDTO() {}
    
    // Getter/Setter 메서드들
    public int getBidId() {
        return bidId;
    }
    
    public void setBidId(int bidId) {
        this.bidId = bidId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public String getMemberId() {
        return memberId;
    }
    
    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }
    
    public int getBidPrice() {
        return bidPrice;
    }
    
    public void setBidPrice(int bidPrice) {
        this.bidPrice = bidPrice;
    }
    
    public Date getBidTime() {
        return bidTime;
    }
    
    public void setBidTime(Date bidTime) {
        this.bidTime = bidTime;
    }
    
    public int getIsSuccessful() {
        return isSuccessful;
    }
    
    public void setIsSuccessful(int isSuccessful) {
        this.isSuccessful = isSuccessful;
    }
    
    @Override
    public String toString() {
        return "Bid{" +
                "bidId=" + bidId +
                ", productId=" + productId +
                ", memberId='" + memberId + '\'' +
                ", bidPrice=" + bidPrice +
                ", bidTime=" + bidTime +
                ", isSuccessful=" + isSuccessful +
                '}';
    }
}