package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_item")
public class OrderItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long orderId;
    private String orderNo;
    private Long storeId;
    private Long dishId;
    private Long specId;
    private String dishName;
    private String specName;
    private String image;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal totalAmount;
    private LocalDateTime createTime;
}
