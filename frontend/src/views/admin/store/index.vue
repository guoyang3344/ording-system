<template>
  <div class="store-admin-container">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="店铺名称">
          <el-input v-model="searchForm.keyword" placeholder="请输入店铺名称" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="全部状态" clearable style="width: 120px">
            <el-option label="营业中" :value="1" />
            <el-option label="休息中" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
        <el-form-item style="margin-left: auto;">
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增店铺
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="tableData" v-loading="loading" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="storeName" label="店铺名称" min-width="150" />
        <el-table-column prop="storeLogo" label="Logo" width="100">
          <template #default="scope">
            <el-avatar :size="40" :src="scope.row.storeLogo">
              <el-icon><Shop /></el-icon>
            </el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="contactPhone" label="联系电话" width="140" />
        <el-table-column prop="minOrderAmount" label="起送金额" width="100">
          <template #default="scope">
            ¥{{ scope.row.minOrderAmount }}
          </template>
        </el-table-column>
        <el-table-column prop="deliveryFee" label="配送费" width="100">
          <template #default="scope">
            ¥{{ scope.row.deliveryFee }}
          </template>
        </el-table-column>
        <el-table-column prop="salesCount" label="销量" width="80" />
        <el-table-column prop="rating" label="评分" width="100">
          <template #default="scope">
            <el-rate v-model="scope.row.rating" disabled show-score text-color="#ff9900"
              score-template="{value}" />
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-switch v-model="scope.row.status" :active-value="1" :inactive-value="0"
              @change="(val) => handleStatusChange(scope.row, val)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button type="primary" link size="small" @click="handleEdit(scope.row)">
              编辑
            </el-button>
            <el-button type="primary" link size="small" @click="handleView(scope.row)">
              菜品
            </el-button>
            <el-button type="danger" link size="small" @click="handleDelete(scope.row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination v-model:current-page="pagination.page" v-model:page-size="pagination.size"
        :page-sizes="[10, 20, 50, 100]" :total="pagination.total" layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange" @current-change="handleCurrentChange" style="margin-top: 20px;" />
    </el-card>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="店铺名称" prop="storeName">
          <el-input v-model="form.storeName" placeholder="请输入店铺名称" />
        </el-form-item>
        <el-form-item label="店铺Logo" prop="storeLogo">
          <el-input v-model="form.storeLogo" placeholder="请输入Logo图片URL" />
        </el-form-item>
        <el-form-item label="店铺描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入店铺描述" />
        </el-form-item>
        <el-form-item label="省份" prop="province">
          <el-input v-model="form.province" placeholder="请输入省份" style="width: 48%" />
          <el-input v-model="form.city" placeholder="请输入城市" style="width: 48%; margin-left: 4%;" />
        </el-form-item>
        <el-form-item label="区县" prop="district">
          <el-input v-model="form.district" placeholder="请输入区县" />
        </el-form-item>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址" />
        </el-form-item>
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input v-model="form.contactPhone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="营业时间" prop="businessHours">
          <el-input v-model="form.businessHours" placeholder="例如：09:00 - 22:00" />
        </el-form-item>
        <el-form-item label="起送金额" prop="minOrderAmount">
          <el-input-number v-model="form.minOrderAmount" :min="0" :precision="2" placeholder="0" />
          <span style="margin-left: 10px;">元</span>
        </el-form-item>
        <el-form-item label="配送费" prop="deliveryFee">
          <el-input-number v-model="form.deliveryFee" :min="0" :precision="2" placeholder="0" />
          <span style="margin-left: 10px;">元</span>
        </el-form-item>
        <el-form-item label="预计配送时间" prop="deliveryTime">
          <el-input v-model="form.deliveryTime" placeholder="例如：30分钟" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { getStorePage, createStore, updateStore, updateStoreStatus } from '@/api/store'

const router = useRouter()

const loading = ref(false)
const submitLoading = ref(false)
const dialogVisible = ref(false)
const formRef = ref(null)
const isEdit = ref(false)

const searchForm = reactive({
  keyword: '',
  status: null
})

const pagination = reactive({
  page: 1,
  size: 10,
  total: 0
})

const tableData = ref([])

const dialogTitle = computed(() => isEdit.value ? '编辑店铺' : '新增店铺')

const form = reactive({
  id: null,
  storeName: '',
  storeLogo: '',
  description: '',
  province: '',
  city: '',
  district: '',
  address: '',
  contactPhone: '',
  businessHours: '',
  minOrderAmount: 0,
  deliveryFee: 0,
  deliveryTime: ''
})

const rules = {
  storeName: [{ required: true, message: '请输入店铺名称', trigger: 'blur' }],
  contactPhone: [{ required: true, message: '请输入联系电话', trigger: 'blur' }]
}

const resetForm = () => {
  form.id = null
  form.storeName = ''
  form.storeLogo = ''
  form.description = ''
  form.province = ''
  form.city = ''
  form.district = ''
  form.address = ''
  form.contactPhone = ''
  form.businessHours = ''
  form.minOrderAmount = 0
  form.deliveryFee = 0
  form.deliveryTime = ''
}

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getStorePage({
      page: pagination.page,
      size: pagination.size,
      keyword: searchForm.keyword,
      status: searchForm.status
    })
    tableData.value = res.data?.records || []
    pagination.total = res.data?.total || 0
  } catch (error) {
    ElMessage.error('获取数据失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.page = 1
  fetchData()
}

const handleReset = () => {
  searchForm.keyword = ''
  searchForm.status = null
  pagination.page = 1
  fetchData()
}

const handleSizeChange = (val) => {
  pagination.size = val
  fetchData()
}

const handleCurrentChange = (val) => {
  pagination.page = val
  fetchData()
}

const handleAdd = () => {
  isEdit.value = false
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleView = (row) => {
  ElMessage.info(`查看店铺 ${row.storeName} 的菜品`)
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除店铺 "${row.storeName}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    ElMessage.success('删除成功')
    fetchData()
  }).catch(() => {})
}

const handleStatusChange = async (row, status) => {
  try {
    await updateStoreStatus(row.id, status)
    ElMessage.success(status === 1 ? '已启用' : '已禁用')
  } catch (error) {
    row.status = row.status === 1 ? 0 : 1
    ElMessage.error('操作失败')
  }
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  submitLoading.value = true
  try {
    if (isEdit.value) {
      await updateStore(form)
      ElMessage.success('更新成功')
    } else {
      await createStore(form, 1)
      ElMessage.success('创建成功')
    }
    dialogVisible.value = false
    fetchData()
  } catch (error) {
    ElMessage.error(error.message || '操作失败')
  } finally {
    submitLoading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style lang="scss" scoped>
.store-admin-container {
  .search-card {
    border: none;
    border-radius: 8px;
    margin-bottom: 20px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  }

  .search-form {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
  }

  .table-card {
    border: none;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  }
}
</style>
