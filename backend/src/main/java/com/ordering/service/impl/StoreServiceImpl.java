package com.ordering.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ordering.entity.Store;
import com.ordering.exception.BusinessException;
import com.ordering.mapper.StoreMapper;
import com.ordering.service.StoreService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class StoreServiceImpl extends ServiceImpl<StoreMapper, Store> implements StoreService {

    @Override
    public Page<Store> getStorePage(Integer page, Integer size, String keyword, Long merchantId) {
        Page<Store> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Store> wrapper = new LambdaQueryWrapper<>();

        if (StringUtils.hasText(keyword)) {
            wrapper.like(Store::getStoreName, keyword);
        }
        if (merchantId != null) {
            wrapper.eq(Store::getMerchantId, merchantId);
        }
        wrapper.orderByDesc(Store::getSort, Store::getCreateTime);

        return page(pageParam, wrapper);
    }

    @Override
    public List<Store> getStoreList(String keyword) {
        LambdaQueryWrapper<Store> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Store::getStatus, 1);
        if (StringUtils.hasText(keyword)) {
            wrapper.like(Store::getStoreName, keyword);
        }
        wrapper.orderByDesc(Store::getSort, Store::getSalesCount);
        return list(wrapper);
    }

    @Override
    public Store getStoreDetail(Long id) {
        Store store = getById(id);
        if (store == null) {
            throw new BusinessException("店铺不存在");
        }
        return store;
    }

    @Override
    public List<Store> getMerchantStores(Long merchantId) {
        LambdaQueryWrapper<Store> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Store::getMerchantId, merchantId);
        wrapper.orderByDesc(Store::getSort, Store::getCreateTime);
        return list(wrapper);
    }

    @Override
    public void createStore(Store store, Long merchantId) {
        store.setMerchantId(merchantId);
        store.setStatus(1);
        store.setSalesCount(0);
        store.setRating(new java.math.BigDecimal("5.0"));
        save(store);
    }

    @Override
    public void updateStore(Store store) {
        Store existStore = getById(store.getId());
        if (existStore == null) {
            throw new BusinessException("店铺不存在");
        }
        updateById(store);
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        Store store = getById(id);
        if (store == null) {
            throw new BusinessException("店铺不存在");
        }
        store.setStatus(status);
        updateById(store);
    }
}
