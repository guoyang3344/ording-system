<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2>点餐系统</h2>
        <p>欢迎回来，请登录您的账户</p>
      </div>
      <el-form ref="loginFormRef" :model="loginForm" :rules="loginRules" class="login-form">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" placeholder="请输入用户名" prefix-icon="User">
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" prefix-icon="Lock"
            @keyup.enter="handleLogin">
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" class="login-btn" :loading="loading" @click="handleLogin">
            登录
          </el-button>
        </el-form-item>
        <div class="login-links">
          <span class="link" @click="goToRegister">还没有账号？立即注册</span>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/modules/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const loginFormRef = ref(null)
const loading = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  const valid = await loginFormRef.value.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    const result = await userStore.loginAction(loginForm)
    if (result.success) {
      ElMessage.success('登录成功')
      const redirect = route.query.redirect || '/home'
      router.push(redirect)
    } else {
      ElMessage.error(result.message || '登录失败')
    }
  } catch (error) {
    ElMessage.error('登录失败')
  } finally {
    loading.value = false
  }
}

const goToRegister = () => {
  router.push('/register')
}
</script>

<style lang="scss" scoped>
.login-container {
  width: 100%;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-box {
  width: 400px;
  background: #fff;
  border-radius: 12px;
  padding: 40px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;

  h2 {
    font-size: 28px;
    color: #333;
    margin-bottom: 10px;
  }

  p {
    color: #999;
    font-size: 14px;
  }
}

.login-form {
  .el-form-item {
    margin-bottom: 20px;
  }

  .el-input {
    height: 44px;
  }

  .login-btn {
    width: 100%;
    height: 44px;
    font-size: 16px;
    border-radius: 8px;
  }
}

.login-links {
  text-align: center;
  margin-top: 20px;

  .link {
    color: #409eff;
    cursor: pointer;
    font-size: 14px;

    &:hover {
      text-decoration: underline;
    }
  }
}
</style>
