

<template>
  <var-popup
    class="Popup"
    position="bottom"
    :show="show"
    @update:show="onChangeShow"
  >
    <div class="Popup__header" v-if="!hideHeader">
      <div class="Popup__header__btn" v-if="!hideActions" @click="onChangeShow(false)"  v-ripple>取消</div>
      <div v-else></div>
      <div class="Popup__header__title">
        {{ title }}
      </div>
      <div class="Popup__header__btn" v-if="!hideActions" @click="onConfirm"  v-ripple>确定</div>
      <div v-else></div>
    </div>
    <slot></slot>
  </var-popup>
</template>

<script lang="ts" setup>
defineProps<{
  show?: boolean;
  title?: string;
  hideHeader?: boolean;
  hideActions?: boolean;
}>();

const emit = defineEmits<{
  (event: 'update:show', show: boolean): void;
  (event: 'ok'): void;
}>();

const onChangeShow = (show: boolean) => {
  emit('update:show', show);
};

const onConfirm = () => {
  emit('ok');
};
</script>

<style lang="scss">
.Popup {
  border-radius: 20px 20px 0 0;
  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px;
    border-bottom: 1px solid var(--border-color);
    min-height: 40px;
    &__btn {
      cursor: pointer;
      color: var(--button-primary-color);;
      opacity: 0.8;
      padding: 6px;
    }
    &__title {
      color: var(--body-text);
      font-weight: bold;
    }
  }
}
</style>