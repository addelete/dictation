<template>
  <div class="ImageIconButton">
    <div class="ImageIconButton__icon"  v-ripple>
      <img :src="imageIcon" alt="" />
    </div>
    <div class="ImageIconButton__text" v-if="text">
      {{ text }}
    </div>
  </div>
</template>

<script lang="ts" setup>

defineProps<{
  imageIcon: string;
  text?: string;
}>();
</script>

<style lang="scss">
.ImageIconButton {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;

  &__icon {
    width: 56px;
    height: 56px;
    cursor: pointer;
    padding: 12px;
    border-radius: 50%;
    background-color: rgba(200, 200, 200, 0.1);
    img {
      width: 100%;
      height: 100%;
    }
  }
  &__text {
    cursor: pointer;
    margin-top: 6px;
    font-size: 14px;
    color: var(--body-text);
    opacity: 0.8;
  }
}
</style>