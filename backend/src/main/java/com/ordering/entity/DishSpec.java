package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("dish_spec")
public class DishSpec extends BaseEntity {

    private Long dishId;
    private String specName;
    private BigDecimal price;
    private Integer stock;
    private Integer status;
}
