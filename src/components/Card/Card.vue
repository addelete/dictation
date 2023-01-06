<template>
  <div class="Card">
    <div class="Card__header">
      <div class="Card__header__title" v-if="title">{{ title }}</div>
      <div class="Card__header__extra">
        <slot name="extra" />
      </div>
    </div>
    <div class="Card__body">
      <slot />
    </div>
  </div>
</template>

<script lang="ts" setup>
defineProps<{
  title?: string;
}>();
</script>

<style lang="scss">
.Card {
  display: flex;
  flex-direction: column;
  border-radius: 4px;
  background-color: var(--color-background);
  box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.05);
  background: var(--card-background);
  &__header {
    display: flex;
    padding:16px 12px;
    align-items: center;
    justify-content: space-between;
    &__title {
      font-size: 16px;
      
      // margin: 16px 0 0;
      color: var(--card-title-color);
      word-break: break-word;
      font-weight: bold;
    }
  }

  &__body {
    padding: 16px;
  }
}
</style>