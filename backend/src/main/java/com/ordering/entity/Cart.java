package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("cart")
public class Cart implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long userId;
    private Long storeId;
    private Long dishId;
    private Long specId;
    private Integer quantity;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
