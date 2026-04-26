package com.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ordering.entity.Dish;
import com.ordering.exception.BusinessException;
import com.ordering.mapper.DishMapper;
import com.ordering.service.DishService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class DishServiceImpl extends ServiceImpl<DishMapper, Dish> implements DishService {

    @Override
    public Page<Dish> getDishPage(Integer page, Integer size, String keyword, Long storeId, Long categoryId) {
        Page<Dish> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Dish> wrapper = new LambdaQueryWrapper<>();

        if (StringUtils.hasText(keyword)) {
            wrapper.like(Dish::getDishName, keyword);
        }
        if (storeId != null) {
            wrapper.eq(Dish::getStoreId, storeId);
        }
        if (categoryId != null) {
            wrapper.eq(Dish::getCategoryId, categoryId);
        }
        wrapper.orderByDesc(Dish::getSort, Dish::getSales);

        return page(pageParam, wrapper);
    }

    @Override
    public List<Dish> getDishListByStore(Long storeId) {
        LambdaQueryWrapper<Dish> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Dish::getStoreId, storeId);
        wrapper.eq(Dish::getStatus, 1);
        wrapper.orderByDesc(Dish::getSort, Dish::getSales);
        return list(wrapper);
    }

    @Override
    public List<Dish> getDishListByCategory(Long categoryId) {
        LambdaQueryWrapper<Dish> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Dish::getCategoryId, categoryId);
        wrapper.eq(Dish::getStatus, 1);
        wrapper.orderByDesc(Dish::getSort, Dish::getSales);
        return list(wrapper);
    }

    @Override
    public Dish getDishDetail(Long id) {
        Dish dish = getById(id);
        if (dish == null) {
            throw new BusinessException("菜品不存在");
        }
        return dish;
    }

    @Override
    public void createDish(Dish dish) {
        dish.setSales(0);
        dish.setRating(new java.math.BigDecimal("5.0"));
        dish.setStatus(1);
        save(dish);
    }

    @Override
    public void updateDish(Dish dish) {
        Dish existDish = getById(dish.getId());
        if (existDish == null) {
            throw new BusinessException("菜品不存在");
        }
        updateById(dish);
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        Dish dish = getById(id);
        if (dish == null) {
            throw new BusinessException("菜品不存在");
        }
        dish.setStatus(status);
        updateById(dish);
    }

    @Override
    public void updateHot(Long id, Integer isHot) {
        Dish dish = getById(id);
        if (dish == null) {
            throw new BusinessException("菜品不存在");
        }
        dish.setIsHot(isHot);
        updateById(dish);
    }

    @Override
    public void updateRecommend(Long id, Integer isRecommend) {
        Dish dish = getById(id);
        if (dish == null) {
            throw new BusinessException("菜品不存在");
        }
        dish.setIsRecommend(isRecommend);
        updateById(dish);
    }

    @Override
    public void updateNew(Long id, Integer isNew) {
        Dish dish = getById(id);
        if (dish == null) {
            throw new BusinessException("菜品不存在");
        }
        dish.setIsNew(isNew);
        updateById(dish);
    }
}
