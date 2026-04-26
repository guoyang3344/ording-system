package com.ordering.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ordering.entity.Dish;

import java.util.List;

public interface DishService extends IService<Dish> {

    Page<Dish> getDishPage(Integer page, Integer size, String keyword, Long storeId, Long categoryId);

    List<Dish> getDishListByStore(Long storeId);

    List<Dish> getDishListByCategory(Long categoryId);

    Dish getDishDetail(Long id);

    void createDish(Dish dish);

    void updateDish(Dish dish);

    void updateStatus(Long id, Integer status);

    void updateHot(Long id, Integer isHot);

    void updateRecommend(Long id, Integer isRecommend);

    void updateNew(Long id, Integer isNew);
}
