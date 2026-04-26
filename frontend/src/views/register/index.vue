<template>
  <div class="register-container">
    <div class="register-box">
      <div class="register-header">
        <h2>注册账户</h2>
        <p>创建新账户，开始您的美食之旅</p>
      </div>
      <el-form ref="registerFormRef" :model="registerForm" :rules="registerRules" class="register-form">
        <el-form-item prop="username">
          <el-input v-model="registerForm.username" placeholder="请输入用户名" prefix-icon="User">
          </el-input>
        </el-form-item>
        <el-form-item prop="phone">
          <el-input v-model="registerForm.phone" placeholder="请输入手机号" prefix-icon="Phone">
          </el-input>
        </el-form-item>
        <el-form-item prop="nickname">
          <el-input v-model="registerForm.nickname" placeholder="请输入昵称（可选）" prefix-icon="UserFilled">
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="registerForm.password" type="password" placeholder="请输入密码" prefix-icon="Lock">
          </el-input>
        </el-form-item>
        <el-form-item prop="confirmPassword">
          <el-input v-model="registerForm.confirmPassword" type="password" placeholder="请再次输入密码"
            prefix-icon="Lock">
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" class="register-btn" :loading="loading" @click="handleRegister">
            注册
          </el-button>
        </el-form-item>
        <div class="register-links">
          <span class="link" @click="goToLogin">已有账号？立即登录</span>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { register } from '@/api/auth'

const router = useRouter()

const registerFormRef = ref(null)
const loading = ref(false)

const registerForm = reactive({
  username: '',
  phone: '',
  nickname: '',
  password: '',
  confirmPassword: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const registerRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度为3-20个字符', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度为6-20个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const handleRegister = async () => {
  const valid = await registerFormRef.value.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    await register({
      username: registerForm.username,
      phone: registerForm.phone,
      nickname: registerForm.nickname,
      password: registerForm.password
    })
    ElMessage.success('注册成功，请登录')
    router.push('/login')
  } catch (error) {
    ElMessage.error(error.message || '注册失败')
  } finally {
    loading.value = false
  }
}

const goToLogin = () => {
  router.push('/login')
}
</script>

<style lang="scss" scoped>
.register-container {
  width: 100%;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.register-box {
  width: 420px;
  background: #fff;
  border-radius: 12px;
  padding: 40px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.register-header {
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

.register-form {
  .el-form-item {
    margin-bottom: 18px;
  }

  .el-input {
    height: 44px;
  }

  .register-btn {
    width: 100%;
    height: 44px;
    font-size: 16px;
    border-radius: 8px;
  }
}

.register-links {
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
