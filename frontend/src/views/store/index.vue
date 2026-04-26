<template>
  <div class="store-container">
    <el-header class="store-header">
      <div class="header-content container">
        <div class="back-btn" @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          返回
        </div>
        <div class="store-title">{{ store.storeName }}</div>
        <div class="header-right">
          <el-badge :value="cartStore.totalCount" class="cart-badge" @click="goCart">
            <el-button type="text" class="cart-btn">
              <el-icon size="20"><ShoppingCart /></el-icon>
              购物车
            </el-button>
          </el-badge>
        </div>
      </div>
    </el-header>

    <el-main class="store-main">
      <div class="container">
        <div class="store-info-section" v-if="store.id">
          <div class="store-banner">
            <img :src="store.storeLogo || 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=restaurant%20banner&image_size=landscape_16_9'"
              :alt="store.storeName" />
          </div>
          <div class="store-detail-info">
            <div class="store-name">{{ store.storeName }}</div>
            <div class="store-meta">
              <el-rate v-model="store.rating" disabled show-score text-color="#ff9900" score-template="{value}">
              </el-rate>
              <span>月售 {{ store.salesCount }}</span>
              <span>起送 ¥{{ store.minOrderAmount }}</span>
              <span>配送费 ¥{{ store.deliveryFee }}</span>
              <span>{{ store.deliveryTime || '30分钟' }}</span>
            </div>
            <div class="store-address">
              <el-icon><Location /></el-icon>
              {{ store.province }}{{ store.city }}{{ store.district }}{{ store.address }}
            </div>
            <div class="store-hours">
              <el-icon><Clock /></el-icon>
              营业时间：{{ store.businessHours || '09:00 - 22:00' }}
            </div>
          </div>
        </div>

        <div class="menu-section">
          <div class="category-sidebar">
            <div class="category-item" :class="{ active: currentCategoryId === null }"
              @click="selectCategory(null)">
              全部菜品
            </div>
            <div class="category-item" v-for="category in categories" :key="category.id"
              :class="{ active: currentCategoryId === category.id }" @click="selectCategory(category.id)">
              <img v-if="category.icon" :src="category.icon" :alt="category.categoryName" />
              <span>{{ category.categoryName }}</span>
            </div>
          </div>

          <div class="dish-list">
            <div class="dish-item" v-for="dish in filteredDishes" :key="dish.id">
              <div class="dish-image">
                <img :src="dish.image || 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=delicious%20food&image_size=square'"
                  :alt="dish.dishName" />
              </div>
              <div class="dish-info">
                <div class="dish-name">{{ dish.dishName }}</div>
                <div class="dish-tags">
                  <span class="tag-hot" v-if="dish.isHot">热销</span>
                  <span class="tag-new" v-if="dish.isNew">新品</span>
                  <span class="tag-recommend" v-if="dish.isRecommend">推荐</span>
                </div>
                <div class="dish-description">{{ dish.description || '暂无描述' }}</div>
                <div class="dish-sales">月售 {{ dish.sales }}</div>
                <div class="dish-price">
                  <span class="current-price">¥{{ dish.price }}</span>
                  <span class="original-price" v-if="dish.originalPrice">¥{{ dish.originalPrice }}</span>
                </div>
              </div>
              <div class="dish-action">
                <div class="add-btn" @click="addToCart(dish)">
                  <el-icon><Plus /></el-icon>
                </div>
                <div class="quantity-control" v-if="getDishQuantity(dish) > 0">
                  <el-button type="text" size="small" @click="decreaseQuantity(dish)">
                    <el-icon><Minus /></el-icon>
                  </el-button>
                  <span class="quantity">{{ getDishQuantity(dish) }}</span>
                  <el-button type="text" size="small" @click="increaseQuantity(dish)">
                    <el-icon><Plus /></el-icon>
                  </el-button>
                </div>
              </div>
            </div>

            <el-empty v-if="filteredDishes.length === 0" description="该分类暂无菜品"></el-empty>
          </div>
        </div>
      </div>
    </el-main>

    <div class="cart-bar" v-if="cartStore.totalCount > 0">
      <div class="cart-bar-left">
        <div class="cart-icon-wrapper" @click="toggleCartPanel">
          <el-badge :value="cartStore.totalCount" class="cart-badge">
            <div class="cart-icon">
              <el-icon size="24" color="#fff"><ShoppingCart /></el-icon>
            </div>
          </el-badge>
        </div>
        <div class="cart-total">
          <div class="total-price">¥{{ cartStore.totalPrice.toFixed(2) }}</div>
          <div class="delivery-info">另需配送费 ¥{{ store.deliveryFee || 0 }}</div>
        </div>
      </div>
      <div class="cart-bar-right">
        <el-button type="primary" class="submit-btn" @click="goCheckout">
          去结算
        </el-button>
      </div>
    </div>

    <el-drawer v-model="cartPanelVisible" title="购物车" size="400px" direction="btt">
      <div class="cart-panel">
        <div class="cart-empty" v-if="cartStore.cartItems.length === 0">
          <el-empty description="购物车是空的"></el-empty>
        </div>
        <div class="cart-items" v-else>
          <div class="cart-item" v-for="item in cartStore.cartItems" :key="item.dishId + '-' + item.specId">
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
          </div>
        </div>
        <div class="cart-panel-footer" v-if="cartStore.cartItems.length > 0">
          <div class="clear-btn" @click="clearCart">
            <el-icon><Delete /></el-icon>
            清空购物车
          </div>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ArrowLeft, ShoppingCart, Location, Clock, Plus, Minus, Delete } from '@element-plus/icons-vue'
import { useUserStore } from '@/store/modules/user'
import { useCartStore } from '@/store/modules/cart'
import { getStoreDetail } from '@/api/store'
import { getDishListByStore } from '@/api/dish'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const cartStore = useCartStore()

const store = ref({})
const dishes = ref([])
const categories = ref([])
const currentCategoryId = ref(null)
const cartPanelVisible = ref(false)
const loading = ref(false)

const filteredDishes = computed(() => {
  if (currentCategoryId.value === null) {
    return dishes.value
  }
  return dishes.value.filter(dish => dish.categoryId === currentCategoryId.value)
})

const cartStore = computed(() => ({
  totalCount: cartStore.totalCount,
  totalPrice: cartStore.totalPrice,
  cartItems: cartStore.cartItems,
  currentStoreId: cartStore.currentStoreId
}))

const fetchStoreDetail = async () => {
  const id = route.params.id
  if (!id) return

  loading.value = true
  try {
    const [storeRes, dishRes] = await Promise.all([
      getStoreDetail(id),
      getDishListByStore(id)
    ])

    store.value = storeRes.data || {}
    dishes.value = dishRes.data || []

    const categoryMap = new Map()
    dishes.value.forEach(dish => {
      if (dish.categoryId && !categoryMap.has(dish.categoryId)) {
        categoryMap.set(dish.categoryId, {
          id: dish.categoryId,
          categoryName: `分类${categoryMap.size + 1}`
        })
      }
    })
    categories.value = Array.from(categoryMap.values())

    if (cartStore.currentStoreId && cartStore.currentStoreId !== id) {
      cartStore.clearCart()
    }
  } catch (error) {
    ElMessage.error('获取店铺信息失败')
  } finally {
    loading.value = false
  }
}

const selectCategory = (categoryId) => {
  currentCategoryId.value = categoryId
}

const getDishQuantity = (dish) => {
  const item = cartStore.cartItems.find(i => i.dishId === dish.id)
  return item ? item.quantity : 0
}

const addToCart = (dish) => {
  if (cartStore.currentStoreId && cartStore.currentStoreId !== store.value.id) {
    ElMessage.confirm('购物车中有其他店铺的商品，是否清空？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      cartStore.clearCart()
      doAddToCart(dish)
    }).catch(() => {})
  } else {
    doAddToCart(dish)
  }
}

const doAddToCart = (dish) => {
  cartStore.addToCart({
    dishId: dish.id,
    specId: null,
    storeId: store.value.id,
    dishName: dish.dishName,
    price: dish.price,
    image: dish.image
  })
  ElMessage.success('已加入购物车')
}

const increaseQuantity = (item) => {
  cartStore.updateQuantity(item.dishId, item.specId, (item.quantity || 0) + 1)
}

const decreaseQuantity = (item) => {
  cartStore.updateQuantity(item.dishId, item.specId, (item.quantity || 0) - 1)
}

const clearCart = () => {
  ElMessage.confirm('确定要清空购物车吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    cartStore.clearCart()
    cartPanelVisible.value = false
  }).catch(() => {})
}

const toggleCartPanel = () => {
  cartPanelVisible.value = !cartPanelVisible.value
}

const goCheckout = () => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }

  if (cartStore.totalPrice < (store.value.minOrderAmount || 0)) {
    ElMessage.warning(`还差 ¥${(store.value.minOrderAmount - cartStore.totalPrice).toFixed(2)} 起送`)
    return
  }

  router.push('/order/create')
}

const goBack = () => {
  router.back()
}

const goCart = () => {
  router.push('/cart')
}

onMounted(() => {
  fetchStoreDetail()
})

watch(() => route.params.id, () => {
  fetchStoreDetail()
})
</script>

<style lang="scss" scoped>
.store-container {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}

.store-header {
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

  .store-title {
    font-size: 18px;
    font-weight: bold;
    color: #333;
  }

  .header-right {
    .cart-badge {
      .cart-btn {
        font-size: 16px;
      }
    }
  }
}

.store-main {
  padding: 20px 0;
}

.store-info-section {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);

  .store-banner {
    height: 200px;
    background: #f5f5f5;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }

  .store-detail-info {
    padding: 20px;

    .store-name {
      font-size: 22px;
      font-weight: bold;
      color: #333;
      margin-bottom: 15px;
    }

    .store-meta {
      display: flex;
      align-items: center;
      gap: 20px;
      margin-bottom: 12px;
      color: #666;
      font-size: 14px;
    }

    .store-address,
    .store-hours {
      display: flex;
      align-items: center;
      color: #666;
      font-size: 14px;
      margin-bottom: 8px;

      .el-icon {
        margin-right: 8px;
      }
    }
  }
}

.menu-section {
  display: flex;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  min-height: 600px;

  .category-sidebar {
    width: 120px;
    background: #f8f9fa;
    border-right: 1px solid #eee;

    .category-item {
      padding: 16px 12px;
      cursor: pointer;
      font-size: 14px;
      color: #666;
      text-align: center;
      border-left: 3px solid transparent;
      transition: all 0.3s;

      &.active {
        background: #fff;
        color: #409eff;
        border-left-color: #409eff;
        font-weight: bold;
      }

      &:hover {
        color: #409eff;
      }

      img {
        width: 32px;
        height: 32px;
        margin: 0 auto 8px;
        border-radius: 4px;
      }
    }
  }

  .dish-list {
    flex: 1;
    padding: 16px;

    .dish-item {
      display: flex;
      padding: 16px 0;
      border-bottom: 1px solid #f0f0f0;

      &:last-child {
        border-bottom: none;
      }

      .dish-image {
        width: 100px;
        height: 100px;
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

      .dish-info {
        flex: 1;
        margin: 0 16px;
        display: flex;
        flex-direction: column;

        .dish-name {
          font-size: 16px;
          font-weight: bold;
          color: #333;
          margin-bottom: 8px;
        }

        .dish-tags {
          margin-bottom: 8px;

          span {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-right: 6px;

            &.tag-hot {
              background: #fef0f0;
              color: #f56c6c;
            }

            &.tag-new {
              background: #fdf6ec;
              color: #e6a23c;
            }

            &.tag-recommend {
              background: #ecf5ff;
              color: #409eff;
            }
          }
        }

        .dish-description {
          color: #999;
          font-size: 13px;
          margin-bottom: 8px;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 1;
          -webkit-box-orient: vertical;
        }

        .dish-sales {
          color: #999;
          font-size: 12px;
          margin-bottom: auto;
        }

        .dish-price {
          .current-price {
            color: #f56c6c;
            font-size: 18px;
            font-weight: bold;
          }

          .original-price {
            color: #999;
            font-size: 12px;
            text-decoration: line-through;
            margin-left: 8px;
          }
        }
      }

      .dish-action {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        justify-content: flex-end;

        .add-btn {
          width: 28px;
          height: 28px;
          background: #409eff;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.3s;

          .el-icon {
            color: #fff;
            font-size: 16px;
          }

          &:hover {
            transform: scale(1.1);
          }
        }

        .quantity-control {
          display: flex;
          align-items: center;
          gap: 8px;

          .quantity {
            font-size: 16px;
            font-weight: bold;
            min-width: 24px;
            text-align: center;
          }
        }
      }
    }
  }
}

.cart-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 60px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
  z-index: 1000;

  .cart-bar-left {
    display: flex;
    align-items: center;

    .cart-icon-wrapper {
      cursor: pointer;
      position: relative;
      top: -10px;

      .cart-icon {
        width: 50px;
        height: 50px;
        background: #409eff;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
      }
    }

    .cart-total {
      margin-left: 16px;

      .total-price {
        font-size: 20px;
        font-weight: bold;
        color: #f56c6c;
      }

      .delivery-info {
        font-size: 12px;
        color: #999;
      }
    }
  }

  .cart-bar-right {
    .submit-btn {
      width: 120px;
      height: 44px;
      font-size: 16px;
      border-radius: 22px;
    }
  }
}

.cart-panel {
  .cart-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 0;
    border-bottom: 1px solid #f0f0f0;

    .item-info {
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

      .quantity {
        font-size: 16px;
        font-weight: bold;
        min-width: 24px;
        text-align: center;
      }
    }
  }

  .cart-panel-footer {
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #f0f0f0;

    .clear-btn {
      display: flex;
      align-items: center;
      gap: 6px;
      color: #999;
      cursor: pointer;
      font-size: 14px;

      &:hover {
        color: #f56c6c;
      }
    }
  }
}
</style>
