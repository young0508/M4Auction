package com.auction.vo;

import java.sql.Timestamp;
import java.util.Date;

public class ScheduleDTO {
    private int scheduleId;    // 스케줄 고유번호 (PK)
    private int productId;     // 상품 ID (FK)
    private Timestamp startTime;    // 경매 시작 시간
    private Timestamp endTime;      // 경매 종료 시간
    private String status;     // 상태 ('대기', '진행중', '종료')
    private Timestamp createdAt;    // 등록일
    private Timestamp updatedAt;    // 수정일
	
    
    public int getScheduleId() {
		return scheduleId;
	}
	public void setScheduleId(int scheduleId) {
		this.scheduleId = scheduleId;
	}
	public int getProductId() {
		return productId;
	}
	public void setProductId(int productId) {
		this.productId = productId;
	}
	public Timestamp getStartTime() {
		return startTime;
	}
	  public void setStartTime(Date startTime) {
	        this.startTime = (startTime != null
	            ? new Timestamp(startTime.getTime())
	            : null);
	    }
	public Timestamp getEndTime() {
		return endTime;
	}
	public void setEndTime(Date endTime) {
        this.endTime = (endTime != null
            ? new Timestamp(endTime.getTime())
            : null);
    }
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public Timestamp getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
    
}
