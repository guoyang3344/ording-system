package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("dish")
public class Dish extends BaseEntity {

    private Long storeId;
    private Long categoryId;
    private String dishName;
    private String description;
    private String image;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private String unit;
    private Integer stock;
    private Integer sales;
    private BigDecimal rating;
    private Integer isHot;
    private Integer isNew;
    private Integer isRecommend;
    private Integer status;
    private Integer sort;
}
