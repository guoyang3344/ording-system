package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("merchant")
public class Merchant extends BaseEntity {

    private Long userId;
    private String merchantName;
    private String merchantLogo;
    private String contactPerson;
    private String contactPhone;
    private String businessLicense;
    private Integer status;
    private Integer auditStatus;
    private String auditRemark;
}
