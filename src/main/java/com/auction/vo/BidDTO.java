package com.auction.vo;

import java.util.Date;

public class BidDTO {
	private int bidId;          // 입찰 고유 번호
	private int PRODUCT_ID;         // 입찰한 상품 번호
	private String member_id;    // 입찰자 아이디
	private int bidPrice;       // 입찰 가격
	private Date bidTime;       // 입찰 시간
	private int isSuccessful;   // 낙찰 여부 (0: 실패, 1: 낙찰)
	public int getBidId() {
		return bidId;
	}
	public void setBidId(int bidId) {
		this.bidId = bidId;
	}
	public int getPRODUCT_ID() {
		return PRODUCT_ID;
	}
	public void setPRODUCT_ID(int pRODUCT_ID) {
		PRODUCT_ID = pRODUCT_ID;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
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

}