<template>
  <div class="home-container">
    <el-header class="home-header">
      <div class="header-content container">
        <div class="logo" @click="goHome">
          <el-icon size="32" color="#409eff"><Food /></el-icon>
          <span class="logo-text">点餐系统</span>
        </div>
        <div class="search-box">
          <el-input v-model="searchKeyword" placeholder="搜索店铺或菜品" clearable @clear="handleSearch"
            @keyup.enter="handleSearch">
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
        </div>
        <div class="header-right">
          <el-badge :value="cartStore.totalCount" class="cart-badge" @click="goCart">
            <el-button type="text" class="cart-btn">
              <el-icon size="20"><ShoppingCart /></el-icon>
              购物车
            </el-button>
          </el-badge>
          <div class="user-menu" v-if="userStore.isLoggedIn">
            <el-dropdown @command="handleCommand">
              <span class="user-info">
                <el-avatar :size="32" :src="userStore.userInfo?.avatar">
                  <el-icon><User /></el-icon>
                </el-avatar>
                <span class="nickname">{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="order">我的订单</el-dropdown-item>
                  <el-dropdown-item command="address">地址管理</el-dropdown-item>
                  <el-dropdown-item command="user">个人中心</el-dropdown-item>
                  <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
          <template v-else>
            <el-button type="text" @click="goLogin">登录</el-button>
            <el-button type="primary" @click="goRegister">注册</el-button>
          </template>
        </div>
      </div>
    </el-header>

    <el-main class="home-main">
      <div class="container">
        <div class="banner-section">
          <div class="banner">
            <div class="banner-content">
              <h1>美味，即刻送达</h1>
              <p>发现附近的美食，享受便捷的点餐服务</p>
            </div>
          </div>
        </div>

        <div class="store-section">
          <div class="section-header">
            <h2>附近店铺</h2>
            <span class="store-count">共 {{ stores.length }} 家店铺</span>
          </div>

          <div class="store-list" v-loading="loading">
            <div class="store-item" v-for="store in stores" :key="store.id" @click="goStore(store.id)">
              <div class="store-image">
                <img :src="store.storeLogo || 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=restaurant%20store%20logo&image_size=square'"
                  :alt="store.storeName" />
              </div>
              <div class="store-info">
                <div class="store-name">
                  <span>{{ store.storeName }}</span>
                  <el-tag v-if="store.status === 1" type="success" size="small">营业中</el-tag>
                  <el-tag v-else type="info" size="small">休息中</el-tag>
                </div>
                <div class="store-rating">
                  <el-rate v-model="store.rating" disabled show-score text-color="#ff9900" score-template="{value}">
                  </el-rate>
                  <span class="sales">月售 {{ store.salesCount }}</span>
                </div>
                <div class="store-delivery">
                  <span>起送 ¥{{ store.minOrderAmount }}</span>
                  <span>配送费 ¥{{ store.deliveryFee }}</span>
                  <span>{{ store.deliveryTime || '30分钟' }}</span>
                </div>
                <div class="store-tags">
                  <el-tag v-for="(tag, index) in getStoreTags(store)" :key="index" size="small"
                    :type="tag.type">
                    {{ tag.name }}
                  </el-tag>
                </div>
              </div>
            </div>

            <el-empty v-if="stores.length === 0 && !loading" description="暂无店铺"></el-empty>
          </div>
        </div>
      </div>
    </el-main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Food, Search, ShoppingCart, User } from '@element-plus/icons-vue'
import { useUserStore } from '@/store/modules/user'
import { useCartStore } from '@/store/modules/cart'
import { getStoreList } from '@/api/store'

const router = useRouter()
const userStore = useUserStore()
const cartStore = useCartStore()

const loading = ref(false)
const searchKeyword = ref('')
const stores = ref([])

const fetchStores = async () => {
  loading.value = true
  try {
    const res = await getStoreList(searchKeyword.value)
    stores.value = res.data || []
  } catch (error) {
    ElMessage.error('获取店铺列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  fetchStores()
}

const getStoreTags = (store) => {
  const tags = []
  if (store.rating >= 4.5) {
    tags.push({ name: '评分高', type: 'warning' })
  }
  if (store.salesCount >= 100) {
    tags.push({ name: '人气高', type: 'danger' })
  }
  if (store.minOrderAmount === 0) {
    tags.push({ name: '0起送', type: 'success' })
  }
  return tags
}

const goHome = () => {
  router.push('/home')
}

const goStore = (id) => {
  router.push(`/store/${id}`)
}

const goCart = () => {
  router.push('/cart')
}

const goLogin = () => {
  router.push('/login')
}

const goRegister = () => {
  router.push('/register')
}

const handleCommand = (command) => {
  switch (command) {
    case 'order':
      router.push('/order')
      break
    case 'address':
      router.push('/address')
      break
    case 'user':
      router.push('/user')
      break
    case 'logout':
      ElMessageBox.confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        userStore.logoutAction()
        router.push('/home')
        ElMessage.success('已退出登录')
      }).catch(() => {})
      break
  }
}

onMounted(() => {
  fetchStores()
})
</script>

<style lang="scss" scoped>
.home-container {
  min-height: 100vh;
  background: #f5f5f5;
}

.home-header {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  position: sticky;
  top: 0;
  z-index: 100;
  height: 60px;
  padding: 0;

  .header-content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 100%;
  }

  .logo {
    display: flex;
    align-items: center;
    cursor: pointer;

    .logo-text {
      font-size: 20px;
      font-weight: bold;
      color: #333;
      margin-left: 8px;
    }
  }

  .search-box {
    display: flex;
    width: 500px;

    .el-input {
      flex: 1;
    }

    .el-button {
      margin-left: 10px;
    }
  }

  .header-right {
    display: flex;
    align-items: center;

    .cart-badge {
      margin-right: 20px;

      .cart-btn {
        font-size: 16px;
      }
    }

    .user-menu {
      .user-info {
        display: flex;
        align-items: center;
        cursor: pointer;

        .nickname {
          margin-left: 8px;
          color: #333;
        }
      }
    }
  }
}

.home-main {
  padding: 20px 0;
}

.banner-section {
  margin-bottom: 30px;

  .banner {
    height: 200px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 12px;
    display: flex;
    align-items: center;
    padding: 0 60px;

    .banner-content {
      color: #fff;

      h1 {
        font-size: 36px;
        margin-bottom: 10px;
      }

      p {
        font-size: 16px;
        opacity: 0.9;
      }
    }
  }
}

.store-section {
  .section-header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;

    h2 {
      font-size: 20px;
      color: #333;
      margin: 0;
    }

    .store-count {
      margin-left: 15px;
      color: #999;
      font-size: 14px;
    }
  }

  .store-list {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;

    .store-item {
      background: #fff;
      border-radius: 12px;
      overflow: hidden;
      cursor: pointer;
      transition: all 0.3s;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);

      &:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
      }

      .store-image {
        height: 160px;
        background: #f5f5f5;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .store-info {
        padding: 16px;

        .store-name {
          display: flex;
          align-items: center;
          font-size: 16px;
          font-weight: bold;
          color: #333;
          margin-bottom: 10px;

          span {
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
          }

          .el-tag {
            margin-left: 8px;
          }
        }

        .store-rating {
          display: flex;
          align-items: center;
          margin-bottom: 10px;

          .sales {
            margin-left: 10px;
            color: #999;
            font-size: 13px;
          }
        }

        .store-delivery {
          display: flex;
          gap: 15px;
          color: #666;
          font-size: 13px;
          margin-bottom: 12px;
        }

        .store-tags {
          display: flex;
          flex-wrap: wrap;
          gap: 6px;
        }
      }
    }
  }
}

@media (max-width: 1200px) {
  .store-list {
    grid-template-columns: repeat(2, 1fr) !important;
  }
}

@media (max-width: 768px) {
  .store-list {
    grid-template-columns: 1fr !important;
  }
}
</style>
