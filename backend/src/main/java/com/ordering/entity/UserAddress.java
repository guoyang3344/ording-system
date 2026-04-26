package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("user_address")
public class UserAddress extends BaseEntity {

    private Long userId;
    private String consigneeName;
    private String consigneePhone;
    private String province;
    private String city;
    private String district;
    private String address;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private Integer isDefault;
}
