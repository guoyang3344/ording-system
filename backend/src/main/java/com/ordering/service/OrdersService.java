package com.ordering.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ordering.entity.Orders;

import java.util.List;

public interface OrdersService extends IService<Orders> {

    Page<Orders> getOrderPage(Integer page, Integer size, Integer orderStatus, Long userId, Long storeId);

    List<Orders> getUserOrders(Long userId, Integer orderStatus);

    List<Orders> getStoreOrders(Long storeId, Integer orderStatus);

    Orders getOrderDetail(Long id);

    Orders getOrderByNo(String orderNo);

    String createOrder(Orders order);

    void updateOrderStatus(Long id, Integer orderStatus);

    void cancelOrder(Long id, String reason);

    void confirmReceive(Long id);
}
