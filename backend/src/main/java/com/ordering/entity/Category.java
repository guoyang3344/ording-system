package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("category")
public class Category extends BaseEntity {

    private Long storeId;
    private String categoryName;
    private String icon;
    private Integer sort;
    private Integer status;
}
