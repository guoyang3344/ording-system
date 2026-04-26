package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("orders")
public class Orders extends BaseEntity {

    private String orderNo;
    private Long userId;
    private Long storeId;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal payAmount;
    private BigDecimal deliveryFee;
    private Integer orderStatus;
    private Integer payType;
    private LocalDateTime payTime;
    private String consigneeName;
    private String consigneePhone;
    private String province;
    private String city;
    private String district;
    private String address;
    private String remark;
    private LocalDateTime expectedTime;
    private LocalDateTime deliveryTime;
    private LocalDateTime cancelTime;
    private String cancelReason;
}
