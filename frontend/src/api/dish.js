import request from '@/utils/request'

export function getDishListByStore(storeId) {
  return request({
    url: `/public/dish/store/${storeId}`,
    method: 'get'
  })
}

export function getDishListByCategory(categoryId) {
  return request({
    url: `/public/dish/category/${categoryId}`,
    method: 'get'
  })
}

export function getDishDetail(id) {
  return request({
    url: `/public/dish/${id}`,
    method: 'get'
  })
}

export function getDishPage(params) {
  return request({
    url: '/dish/page',
    method: 'get',
    params
  })
}

export function createDish(data) {
  return request({
    url: '/dish',
    method: 'post',
    data
  })
}

export function updateDish(data) {
  return request({
    url: '/dish',
    method: 'put',
    data
  })
}

export function updateDishStatus(id, status) {
  return request({
    url: `/dish/status/${id}`,
    method: 'put',
    params: { status }
  })
}

export function updateDishHot(id, isHot) {
  return request({
    url: `/dish/hot/${id}`,
    method: 'put',
    params: { isHot }
  })
}

export function updateDishRecommend(id, isRecommend) {
  return request({
    url: `/dish/recommend/${id}`,
    method: 'put',
    params: { isRecommend }
  })
}

export function updateDishNew(id, isNew) {
  return request({
    url: `/dish/new/${id}`,
    method: 'put',
    params: { isNew }
  })
}
