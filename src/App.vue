<template>
  <router-view v-slot="{ Component }">
    <transition name="fade">
      <keep-alive include="Home">
        <component :is="Component" />
      </keep-alive>
    </transition>
  </router-view>
</template>

<script setup lang="ts">
</script>

<style>
</style>
