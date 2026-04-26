<template>
  <div class="cart-container">
    <el-header class="cart-header">
      <div class="header-content container">
        <div class="back-btn" @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          返回
        </div>
        <div class="header-title">购物车</div>
        <div class="header-right">
          <el-button type="text" @click="clearCart" v-if="cartStore.cartItems.length > 0">
            清空购物车
          </el-button>
        </div>
      </div>
    </el-header>

    <el-main class="cart-main">
      <div class="container">
        <div class="cart-empty" v-if="cartStore.cartItems.length === 0">
          <el-empty description="购物车是空的">
            <el-button type="primary" @click="goHome">去逛逛</el-button>
          </el-empty>
        </div>

        <div class="cart-content" v-else>
          <div class="store-info">
            <div class="store-name">
              <el-icon><Shop /></el-icon>
              店铺商品
            </div>
          </div>

          <div class="cart-items">
            <div class="cart-item" v-for="item in cartStore.cartItems" :key="item.dishId + '-' + item.specId">
              <div class="item-image">
                <img :src="item.image || 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=food&image_size=square'"
                  :alt="item.dishName" />
              </div>
              <div class="item-info">
                <div class="item-name">{{ item.dishName }}</div>
                <div class="item-price">¥{{ item.price }}</div>
              </div>
              <div class="item-action">
                <el-button type="text" size="small" @click="decreaseQuantity(item)">
                  <el-icon><Minus /></el-icon>
                </el-button>
                <span class="quantity">{{ item.quantity }}</span>
                <el-button type="text" size="small" @click="increaseQuantity(item)">
                  <el-icon><Plus /></el-icon>
                </el-button>
              </div>
              <div class="item-total">
                ¥{{ (item.price * item.quantity).toFixed(2) }}
              </div>
              <div class="item-delete" @click="removeItem(item)">
                <el-icon><Delete /></el-icon>
              </div>
            </div>
          </div>

          <div class="cart-summary">
            <div class="summary-info">
              <span>共 {{ cartStore.totalCount }} 件商品</span>
              <span class="total-price">合计：<span class="price">¥{{ cartStore.totalPrice.toFixed(2) }}</span></span>
            </div>
            <el-button type="primary" size="large" @click="goCheckout">
              去结算
            </el-button>
          </div>
        </div>
      </div>
    </el-main>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowLeft, Shop, Plus, Minus, Delete } from '@element-plus/icons-vue'
import { useUserStore } from '@/store/modules/user'
import { useCartStore } from '@/store/modules/cart'

const router = useRouter()
const userStore = useUserStore()
const cartStore = useCartStore()

const cartStore = computed(() => ({
  totalCount: cartStore.totalCount,
  totalPrice: cartStore.totalPrice,
  cartItems: cartStore.cartItems,
  currentStoreId: cartStore.currentStoreId
}))

const increaseQuantity = (item) => {
  cartStore.updateQuantity(item.dishId, item.specId, item.quantity + 1)
}

const decreaseQuantity = (item) => {
  cartStore.updateQuantity(item.dishId, item.specId, item.quantity - 1)
}

const removeItem = (item) => {
  ElMessage.confirm('确定要删除该商品吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    cartStore.removeItem(item.dishId, item.specId)
    ElMessage.success('已删除')
  }).catch(() => {})
}

const clearCart = () => {
  ElMessage.confirm('确定要清空购物车吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    cartStore.clearCart()
    ElMessage.success('已清空购物车')
  }).catch(() => {})
}

const goCheckout = () => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }

  router.push('/order/create')
}

const goBack = () => {
  router.back()
}

const goHome = () => {
  router.push('/home')
}
</script>

<style lang="scss" scoped>
.cart-container {
  min-height: 100vh;
  background: #f5f5f5;
}

.cart-header {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  height: 60px;
  padding: 0;

  .header-content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 100%;
  }

  .back-btn {
    display: flex;
    align-items: center;
    cursor: pointer;
    color: #666;
    font-size: 15px;

    &:hover {
      color: #409eff;
    }
  }

  .header-title {
    font-size: 18px;
    font-weight: bold;
    color: #333;
  }
}

.cart-main {
  padding: 20px 0;
}

.cart-empty {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
}

.cart-content {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);

  .store-info {
    padding: 16px 20px;
    border-bottom: 1px solid #f0f0f0;
    background: #fafafa;

    .store-name {
      display: flex;
      align-items: center;
      font-size: 16px;
      font-weight: bold;
      color: #333;

      .el-icon {
        margin-right: 8px;
        color: #409eff;
      }
    }
  }

  .cart-items {
    .cart-item {
      display: flex;
      align-items: center;
      padding: 20px;
      border-bottom: 1px solid #f0f0f0;

      &:last-child {
        border-bottom: none;
      }

      .item-image {
        width: 80px;
        height: 80px;
        border-radius: 8px;
        overflow: hidden;
        background: #f5f5f5;
        flex-shrink: 0;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .item-info {
        flex: 1;
        margin: 0 20px;

        .item-name {
          font-size: 15px;
          color: #333;
          margin-bottom: 8px;
        }

        .item-price {
          color: #f56c6c;
          font-size: 16px;
          font-weight: bold;
        }
      }

      .item-action {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-right: 20px;

        .quantity {
          font-size: 16px;
          font-weight: bold;
          min-width: 24px;
          text-align: center;
        }
      }

      .item-total {
        font-size: 16px;
        font-weight: bold;
        color: #f56c6c;
        min-width: 100px;
        text-align: right;
        margin-right: 20px;
      }

      .item-delete {
        color: #999;
        cursor: pointer;
        padding: 8px;

        &:hover {
          color: #f56c6c;
        }
      }
    }
  }

  .cart-summary {
    position: sticky;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 20px;
    background: #fff;
    border-top: 1px solid #f0f0f0;

    .summary-info {
      font-size: 14px;
      color: #666;

      .total-price {
        margin-left: 20px;

        .price {
          color: #f56c6c;
          font-size: 20px;
          font-weight: bold;
        }
      }
    }
  }
}
</style>
