import axios from 'axios'
import { ElMessage } from 'element-plus'
import { getToken } from '@/utils/auth'
import router from '@/router'

const service = axios.create({
  baseURL: '/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
})

service.interceptors.request.use(
  config => {
    const token = getToken()
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

service.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code !== 200) {
      ElMessage.error(res.message || '请求失败')
      if (res.code === 401) {
        localStorage.removeItem('ordering_token')
        localStorage.removeItem('user')
        router.push('/login')
      }
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    return res
  },
  error => {
    console.error('响应错误:', error)
    const message = error.response?.data?.message || error.message || '网络错误'
    ElMessage.error(message)
    return Promise.reject(error)
  }
)

export default service
