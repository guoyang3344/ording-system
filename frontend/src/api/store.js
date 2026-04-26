import request from '@/utils/request'

export function getStoreList(keyword) {
  return request({
    url: '/public/store/list',
    method: 'get',
    params: { keyword }
  })
}

export function getStoreDetail(id) {
  return request({
    url: `/public/store/${id}`,
    method: 'get'
  })
}

export function getStorePage(params) {
  return request({
    url: '/store/page',
    method: 'get',
    params
  })
}

export function getMyStores(merchantId) {
  return request({
    url: '/store/my',
    method: 'get',
    params: { merchantId }
  })
}

export function createStore(data, merchantId) {
  return request({
    url: '/store',
    method: 'post',
    data,
    params: { merchantId }
  })
}

export function updateStore(data) {
  return request({
    url: '/store',
    method: 'put',
    data
  })
}

export function updateStoreStatus(id, status) {
  return request({
    url: `/store/status/${id}`,
    method: 'put',
    params: { status }
  })
}
