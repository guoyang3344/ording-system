package com.ordering.controller;

import com.ordering.common.Result;
import com.ordering.dto.LoginDTO;
import com.ordering.dto.RegisterDTO;
import com.ordering.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@Api(tags = "认证接口")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    @ApiOperation("用户登录")
    public Result<Map<String, Object>> login(@Validated @RequestBody LoginDTO loginDTO) {
        Map<String, Object> result = userService.login(loginDTO);
        return Result.success("登录成功", result);
    }

    @PostMapping("/register")
    @ApiOperation("用户注册")
    public Result<Void> register(@Validated @RequestBody RegisterDTO registerDTO) {
        userService.register(registerDTO);
        return Result.success();
    }

    @GetMapping("/userinfo")
    @ApiOperation("获取当前用户信息")
    public Result<Map<String, Object>> getUserInfo(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        Map<String, Object> userInfo = userService.getUserInfo(userId);
        return Result.success(userInfo);
    }

    @PostMapping("/logout")
    @ApiOperation("用户登出")
    public Result<Void> logout() {
        return Result.success();
    }
}
