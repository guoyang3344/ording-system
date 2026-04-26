import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login, logout, getUserInfo } from '@/api/auth'
import { getToken, setToken, removeToken } from '@/utils/auth'

export const useUserStore = defineStore('user', () => {
  const token = ref(getToken())
  const userInfo = ref(null)

  const isLoggedIn = computed(() => !!token.value)

  async function loginAction(loginForm) {
    try {
      const res = await login(loginForm)
      const { token: tokenValue, ...info } = res.data
      token.value = tokenValue
      userInfo.value = info
      setToken(tokenValue)
      return { success: true }
    } catch (error) {
      return { success: false, message: error.message }
    }
  }

  async function logoutAction() {
    try {
      await logout()
    } finally {
      token.value = ''
      userInfo.value = null
      removeToken()
    }
  }

  async function fetchUserInfo() {
    try {
      const res = await getUserInfo()
      userInfo.value = res.data
      return { success: true }
    } catch (error) {
      return { success: false }
    }
  }

  return {
    token,
    userInfo,
    isLoggedIn,
    loginAction,
    logoutAction,
    fetchUserInfo
  }
}, {
  persist: {
    key: 'user',
    paths: ['token', 'userInfo']
  }
})
