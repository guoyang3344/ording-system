package com.ordering.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ordering.common.PageResult;
import com.ordering.common.Result;
import com.ordering.entity.Dish;
import com.ordering.service.DishService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@Api(tags = "菜品接口")
public class DishController {

    @Autowired
    private DishService dishService;

    @GetMapping("/public/dish/store/{storeId}")
    @ApiOperation("获取店铺菜品列表（公开）")
    public Result<List<Dish>> getDishListByStore(@PathVariable Long storeId) {
        List<Dish> dishes = dishService.getDishListByStore(storeId);
        return Result.success(dishes);
    }

    @GetMapping("/public/dish/category/{categoryId}")
    @ApiOperation("获取分类菜品列表（公开）")
    public Result<List<Dish>> getDishListByCategory(@PathVariable Long categoryId) {
        List<Dish> dishes = dishService.getDishListByCategory(categoryId);
        return Result.success(dishes);
    }

    @GetMapping("/public/dish/{id}")
    @ApiOperation("获取菜品详情（公开）")
    public Result<Dish> getDishDetail(@PathVariable Long id) {
        Dish dish = dishService.getDishDetail(id);
        return Result.success(dish);
    }

    @GetMapping("/dish/page")
    @ApiOperation("分页获取菜品列表")
    public Result<PageResult<Dish>> getDishPage(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long storeId,
            @RequestParam(required = false) Long categoryId) {
        Page<Dish> dishPage = dishService.getDishPage(page, size, keyword, storeId, categoryId);
        PageResult<Dish> result = new PageResult<>(
                dishPage.getRecords(),
                dishPage.getTotal(),
                dishPage.getSize(),
                dishPage.getCurrent()
        );
        return Result.success(result);
    }

    @PostMapping("/dish")
    @ApiOperation("创建菜品")
    public Result<Void> createDish(@RequestBody Dish dish) {
        dishService.createDish(dish);
        return Result.success();
    }

    @PutMapping("/dish")
    @ApiOperation("更新菜品")
    public Result<Void> updateDish(@RequestBody Dish dish) {
        dishService.updateDish(dish);
        return Result.success();
    }

    @PutMapping("/dish/status/{id}")
    @ApiOperation("更新菜品状态（上架/下架）")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        dishService.updateStatus(id, status);
        return Result.success();
    }

    @PutMapping("/dish/hot/{id}")
    @ApiOperation("更新是否热销")
    public Result<Void> updateHot(@PathVariable Long id, @RequestParam Integer isHot) {
        dishService.updateHot(id, isHot);
        return Result.success();
    }

    @PutMapping("/dish/recommend/{id}")
    @ApiOperation("更新是否推荐")
    public Result<Void> updateRecommend(@PathVariable Long id, @RequestParam Integer isRecommend) {
        dishService.updateRecommend(id, isRecommend);
        return Result.success();
    }

    @PutMapping("/dish/new/{id}")
    @ApiOperation("更新是否新品")
    public Result<Void> updateNew(@PathVariable Long id, @RequestParam Integer isNew) {
        dishService.updateNew(id, isNew);
        return Result.success();
    }
}
