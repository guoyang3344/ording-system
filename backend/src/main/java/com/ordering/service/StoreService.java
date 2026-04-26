package com.ordering.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ordering.entity.Store;

import java.util.List;

public interface StoreService extends IService<Store> {

    Page<Store> getStorePage(Integer page, Integer size, String keyword, Long merchantId);

    List<Store> getStoreList(String keyword);

    Store getStoreDetail(Long id);

    List<Store> getMerchantStores(Long merchantId);

    void createStore(Store store, Long merchantId);

    void updateStore(Store store);

    void updateStatus(Long id, Integer status);
}
