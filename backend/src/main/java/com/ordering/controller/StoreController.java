package com.ordering.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ordering.common.PageResult;
import com.ordering.common.Result;
import com.ordering.entity.Store;
import com.ordering.service.StoreService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@Api(tags = "店铺接口")
public class StoreController {

    @Autowired
    private StoreService storeService;

    @GetMapping("/public/store/list")
    @ApiOperation("获取店铺列表（公开）")
    public Result<List<Store>> getStoreList(@RequestParam(required = false) String keyword) {
        List<Store> stores = storeService.getStoreList(keyword);
        return Result.success(stores);
    }

    @GetMapping("/public/store/{id}")
    @ApiOperation("获取店铺详情（公开）")
    public Result<Store> getStoreDetail(@PathVariable Long id) {
        Store store = storeService.getStoreDetail(id);
        return Result.success(store);
    }

    @GetMapping("/store/page")
    @ApiOperation("分页获取店铺列表")
    public Result<PageResult<Store>> getStorePage(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long merchantId) {
        Page<Store> storePage = storeService.getStorePage(page, size, keyword, merchantId);
        PageResult<Store> result = new PageResult<>(
                storePage.getRecords(),
                storePage.getTotal(),
                storePage.getSize(),
                storePage.getCurrent()
        );
        return Result.success(result);
    }

    @GetMapping("/store/my")
    @ApiOperation("获取商户的店铺列表")
    public Result<List<Store>> getMyStores(@RequestParam Long merchantId) {
        List<Store> stores = storeService.getMerchantStores(merchantId);
        return Result.success(stores);
    }

    @PostMapping("/store")
    @ApiOperation("创建店铺")
    public Result<Void> createStore(@RequestBody Store store, @RequestParam Long merchantId) {
        storeService.createStore(store, merchantId);
        return Result.success();
    }

    @PutMapping("/store")
    @ApiOperation("更新店铺")
    public Result<Void> updateStore(@RequestBody Store store) {
        storeService.updateStore(store);
        return Result.success();
    }

    @PutMapping("/store/status/{id}")
    @ApiOperation("更新店铺状态")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        storeService.updateStatus(id, status);
        return Result.success();
    }
}
