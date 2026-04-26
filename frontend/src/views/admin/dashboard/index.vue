<template>
  <div class="dashboard-container">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
              <el-icon size="28" color="#fff"><Shop /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.storeCount }}</div>
              <div class="stat-label">店铺数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
              <el-icon size="28" color="#fff"><Food /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.dishCount }}</div>
              <div class="stat-label">菜品数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
              <el-icon size="28" color="#fff"><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.orderCount }}</div>
              <div class="stat-label">订单数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
              <el-icon size="28" color="#fff"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.userCount }}</div>
              <div class="stat-label">用户数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card class="recent-card">
          <template #header>
            <div class="card-header">
              <span>最近订单</span>
              <el-button type="text" size="small" @click="goOrderList">查看全部</el-button>
            </div>
          </template>
          <el-table :data="recentOrders" v-loading="loading" style="width: 100%">
            <el-table-column prop="orderNo" label="订单号" width="180" />
            <el-table-column prop="totalAmount" label="金额">
              <template #default="scope">
                <span style="color: #f56c6c; font-weight: bold;">¥{{ scope.row.totalAmount }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="orderStatus" label="状态" width="100">
              <template #default="scope">
                <el-tag :type="getStatusType(scope.row.orderStatus)" size="small">
                  {{ getStatusText(scope.row.orderStatus) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="下单时间" width="160" />
          </el-table>
          <el-empty v-if="recentOrders.length === 0 && !loading" description="暂无订单" />
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card class="recent-card">
          <template #header>
            <div class="card-header">
              <span>热门店铺</span>
              <el-button type="text" size="small" @click="goStoreList">查看全部</el-button>
            </div>
          </template>
          <el-table :data="hotStores" v-loading="loading" style="width: 100%">
            <el-table-column prop="storeName" label="店铺名称" />
            <el-table-column prop="salesCount" label="月售" width="80" />
            <el-table-column prop="rating" label="评分" width="100">
              <template #default="scope">
                <el-rate v-model="scope.row.rating" disabled show-score text-color="#ff9900"
                  score-template="{value}" />
              </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="80">
              <template #default="scope">
                <el-tag :type="scope.row.status === 1 ? 'success' : 'info'" size="small">
                  {{ scope.row.status === 1 ? '营业中' : '休息中' }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-if="hotStores.length === 0 && !loading" description="暂无店铺" />
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Shop, Food, Document, User } from '@element-plus/icons-vue'

const router = useRouter()

const loading = ref(false)

const stats = ref({
  storeCount: 0,
  dishCount: 0,
  orderCount: 0,
  userCount: 0
})

const recentOrders = ref([])
const hotStores = ref([])

const getStatusType = (status) => {
  const types = {
    0: 'warning',
    1: 'primary',
    2: '',
    3: 'info',
    4: 'success',
    5: 'danger',
    6: 'info'
  }
  return types[status] || ''
}

const getStatusText = (status) => {
  const texts = {
    0: '待付款',
    1: '待接单',
    2: '制作中',
    3: '配送中',
    4: '已完成',
    5: '已取消',
    6: '已退款'
  }
  return texts[status] || '未知'
}

const goOrderList = () => {
  router.push('/admin/order')
}

const goStoreList = () => {
  router.push('/admin/store')
}

const fetchData = async () => {
  loading.value = true
  try {
    stats.value = {
      storeCount: 12,
      dishCount: 156,
      orderCount: 892,
      userCount: 3456
    }

    recentOrders.value = [
      { orderNo: '202404260001', totalAmount: 88.5, orderStatus: 4, createTime: '2024-04-26 14:30:25' },
      { orderNo: '202404260002', totalAmount: 56.0, orderStatus: 3, createTime: '2024-04-26 14:25:18' },
      { orderNo: '202404260003', totalAmount: 128.0, orderStatus: 1, createTime: '2024-04-26 14:20:05' },
      { orderNo: '202404260004', totalAmount: 45.5, orderStatus: 0, createTime: '2024-04-26 14:15:32' }
    ]

    hotStores.value = [
      { storeName: '美味餐厅', salesCount: 356, rating: 4.8, status: 1 },
      { storeName: '快捷快餐', salesCount: 289, rating: 4.6, status: 1 },
      { storeName: '家常菜馆', salesCount: 245, rating: 4.7, status: 1 },
      { storeName: '川味火锅', salesCount: 198, rating: 4.9, status: 0 }
    ]
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style lang="scss" scoped>
.dashboard-container {
  .stat-card {
    border: none;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);

    :deep(.el-card__body) {
      padding: 20px;
    }

    .stat-content {
      display: flex;
      align-items: center;

      .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }

      .stat-info {
        margin-left: 20px;

        .stat-value {
          font-size: 28px;
          font-weight: bold;
          color: #333;
        }

        .stat-label {
          font-size: 14px;
          color: #999;
          margin-top: 4px;
        }
      }
    }
  }

  .recent-card {
    border: none;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);

    .card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-weight: bold;
    }
  }
}
</style>
