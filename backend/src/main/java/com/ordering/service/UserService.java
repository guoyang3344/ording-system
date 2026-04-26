package com.ordering.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ordering.dto.LoginDTO;
import com.ordering.dto.RegisterDTO;
import com.ordering.entity.User;

import java.util.Map;

public interface UserService extends IService<User> {

    Map<String, Object> login(LoginDTO loginDTO);

    void register(RegisterDTO registerDTO);

    User getByUsername(String username);

    User getByPhone(String phone);

    Map<String, Object> getUserInfo(Long userId);

    void updatePassword(Long userId, String oldPassword, String newPassword);
}
