package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("store")
public class Store extends BaseEntity {

    private Long merchantId;
    private String storeName;
    private String storeLogo;
    private String description;
    private String province;
    private String city;
    private String district;
    private String address;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private String contactPhone;
    private String businessHours;
    private BigDecimal minOrderAmount;
    private BigDecimal deliveryFee;
    private String deliveryTime;
    private Integer status;
    private Integer sort;
    private Integer salesCount;
    private BigDecimal rating;
}
