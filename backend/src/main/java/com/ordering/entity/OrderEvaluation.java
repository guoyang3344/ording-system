package com.ordering.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("order_evaluation")
public class OrderEvaluation extends BaseEntity {

    private Long orderId;
    private Long userId;
    private Long storeId;
    private Integer dishRating;
    private Integer serviceRating;
    private Integer deliveryRating;
    private String content;
    private String images;
    private Integer isAnonymous;
    private String replyContent;
    private LocalDateTime replyTime;
}
