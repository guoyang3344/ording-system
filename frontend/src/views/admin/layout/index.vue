<template>
  <div class="admin-layout">
    <el-aside width="220px" class="admin-sidebar">
      <div class="sidebar-logo">
        <el-icon size="28" color="#fff"><Food /></el-icon>
        <span>点餐系统</span>
      </div>
      <el-menu :default-active="activeMenu" background-color="#304156" text-color="#bfcbd9"
        active-text-color="#409eff" router>
        <el-menu-item index="/admin/dashboard">
          <el-icon><DataAnalysis /></el-icon>
          <span>数据概览</span>
        </el-menu-item>
        <el-menu-item index="/admin/store">
          <el-icon><Shop /></el-icon>
          <span>店铺管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/dish">
          <el-icon><Food /></el-icon>
          <span>菜品管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/category">
          <el-icon><Grid /></el-icon>
          <span>分类管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/order">
          <el-icon><Document /></el-icon>
          <span>订单管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/user">
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-main class="admin-main">
      <el-header class="admin-header">
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/admin/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentPageName }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-avatar :size="32" :src="userStore.userInfo?.avatar">
                <el-icon><User /></el-icon>
              </el-avatar>
              <span class="nickname">{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="home">返回前台</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main class="admin-content">
        <router-view />
      </el-main>
    </el-main>
  </div>
</template>

<script setup>
import { computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Food, DataAnalysis, Shop, Grid, Document, User } from '@element-plus/icons-vue'
import { useUserStore } from '@/store/modules/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)

const pageNames = {
  '/admin/dashboard': '数据概览',
  '/admin/store': '店铺管理',
  '/admin/dish': '菜品管理',
  '/admin/category': '分类管理',
  '/admin/order': '订单管理',
  '/admin/user': '用户管理'
}

const currentPageName = computed(() => pageNames[route.path] || '数据概览')

const handleCommand = (command) => {
  switch (command) {
    case 'home':
      router.push('/home')
      break
    case 'logout':
      ElMessageBox.confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        userStore.logoutAction()
        router.push('/login')
        ElMessage.success('已退出登录')
      }).catch(() => {})
      break
  }
}
</script>

<style lang="scss" scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
}

.admin-sidebar {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  background: #304156;
  overflow-y: auto;
  z-index: 1000;

  .sidebar-logo {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid #1f2d3d;

    span {
      margin-left: 10px;
      color: #fff;
      font-size: 18px;
      font-weight: bold;
    }
  }

  .el-menu {
    border-right: none;
  }
}

.admin-main {
  flex: 1;
  margin-left: 220px;
  display: flex;
  flex-direction: column;
}

.admin-header {
  height: 60px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  border-bottom: 1px solid #eee;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);

  .header-right {
    .user-info {
      display: flex;
      align-items: center;
      cursor: pointer;

      .nickname {
        margin-left: 10px;
        color: #333;
      }
    }
  }
}

.admin-content {
  flex: 1;
  padding: 20px;
  background: #f0f2f5;
  overflow-y: auto;
}
</style>
