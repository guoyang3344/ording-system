import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCartStore = defineStore('cart', () => {
  const cartItems = ref([])
  const currentStoreId = ref(null)

  const totalCount = computed(() => {
    return cartItems.value.reduce((sum, item) => sum + item.quantity, 0)
  })

  const totalPrice = computed(() => {
    return cartItems.value.reduce((sum, item) => sum + item.price * item.quantity, 0)
  })

  function addToCart(item) {
    if (currentStoreId.value && currentStoreId.value !== item.storeId) {
      cartItems.value = []
    }
    currentStoreId.value = item.storeId

    const existingItem = cartItems.value.find(
      i => i.dishId === item.dishId && i.specId === item.specId
    )

    if (existingItem) {
      existingItem.quantity += item.quantity || 1
    } else {
      cartItems.value.push({
        ...item,
        quantity: item.quantity || 1
      })
    }
  }

  function updateQuantity(dishId, specId, quantity) {
    const item = cartItems.value.find(
      i => i.dishId === dishId && i.specId === specId
    )
    if (item) {
      if (quantity <= 0) {
        removeItem(dishId, specId)
      } else {
        item.quantity = quantity
      }
    }
  }

  function removeItem(dishId, specId) {
    const index = cartItems.value.findIndex(
      i => i.dishId === dishId && i.specId === specId
    )
    if (index > -1) {
      cartItems.value.splice(index, 1)
    }
    if (cartItems.value.length === 0) {
      currentStoreId.value = null
    }
  }

  function clearCart() {
    cartItems.value = []
    currentStoreId.value = null
  }

  return {
    cartItems,
    currentStoreId,
    totalCount,
    totalPrice,
    addToCart,
    updateQuantity,
    removeItem,
    clearCart
  }
}, {
  persist: {
    key: 'cart',
    paths: ['cartItems', 'currentStoreId']
  }
})
