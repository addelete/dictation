import { createRouter, createWebHashHistory } from 'vue-router'
export const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: () => import('./pages/Home.vue'),
    },
    {
      path: '/edit-dictation',
      name: 'EditDictation',
      component: () => import('./pages/EditDictation.vue'),
    },
    {
      path: '/play-dictation',
      name: 'PlayDictation',
      component: () => import('./pages/PlayDictation.vue'),
    },
    {
      path: '/search',
      name: 'Search',
      component: () => import('./pages/Search.vue'),
    }
  ],
})
