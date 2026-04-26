import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/store/modules/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/index.vue'),
    meta: { title: '登录', requiresAuth: false }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/register/index.vue'),
    meta: { title: '注册', requiresAuth: false }
  },
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/home',
    name: 'Home',
    component: () => import('@/views/home/index.vue'),
    meta: { title: '首页', requiresAuth: false }
  },
  {
    path: '/store/:id',
    name: 'StoreDetail',
    component: () => import('@/views/store/index.vue'),
    meta: { title: '店铺详情', requiresAuth: false }
  },
  {
    path: '/cart',
    name: 'Cart',
    component: () => import('@/views/cart/index.vue'),
    meta: { title: '购物车', requiresAuth: true }
  },
  {
    path: '/order',
    name: 'Order',
    component: () => import('@/views/order/index.vue'),
    meta: { title: '我的订单', requiresAuth: true }
  },
  {
    path: '/order/create',
    name: 'OrderCreate',
    component: () => import('@/views/order/create.vue'),
    meta: { title: '提交订单', requiresAuth: true }
  },
  {
    path: '/order/detail/:id',
    name: 'OrderDetail',
    component: () => import('@/views/order/detail.vue'),
    meta: { title: '订单详情', requiresAuth: true }
  },
  {
    path: '/user',
    name: 'User',
    component: () => import('@/views/user/index.vue'),
    meta: { title: '个人中心', requiresAuth: true }
  },
  {
    path: '/address',
    name: 'Address',
    component: () => import('@/views/address/index.vue'),
    meta: { title: '地址管理', requiresAuth: true }
  },
  {
    path: '/admin',
    component: () => import('@/views/admin/layout/index.vue'),
    redirect: '/admin/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: () => import('@/views/admin/dashboard/index.vue'),
        meta: { title: '数据概览', requiresAuth: true }
      },
      {
        path: 'store',
        name: 'AdminStore',
        component: () => import('@/views/admin/store/index.vue'),
        meta: { title: '店铺管理', requiresAuth: true }
      },
      {
        path: 'dish',
        name: 'AdminDish',
        component: () => import('@/views/admin/dish/index.vue'),
        meta: { title: '菜品管理', requiresAuth: true }
      },
      {
        path: 'category',
        name: 'AdminCategory',
        component: () => import('@/views/admin/category/index.vue'),
        meta: { title: '分类管理', requiresAuth: true }
      },
      {
        path: 'order',
        name: 'AdminOrder',
        component: () => import('@/views/admin/order/index.vue'),
        meta: { title: '订单管理', requiresAuth: true }
      },
      {
        path: 'user',
        name: 'AdminUser',
        component: () => import('@/views/admin/user/index.vue'),
        meta: { title: '用户管理', requiresAuth: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - 点餐系统` : '点餐系统'

  const userStore = useUserStore()
  const token = userStore.token

  if (to.meta.requiresAuth && !token) {
    next({ name: 'Login', query: { redirect: to.fullPath } })
  } else {
    next()
  }
})

export default router
