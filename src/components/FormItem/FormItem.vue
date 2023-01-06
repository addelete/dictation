

<template>
  <div class="FormItem">
    <div class="FormItem__label">
      <div class="FormItem__label__required" v-if="required">*</div>
      <div class="FormItem__label__title">{{ label }}</div>
      <div
        class="FormItem__label__helperBtn"
        v-if="helper"
        @click="showHelper = !showHelper"
      >
        <var-icon name="help-circle-outline" />
      </div>
    </div>
    <div class="FormItem__helper" v-if="helper && showHelper">{{ helper }}</div>
    <slot />
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue';

defineProps<{
  label: string;
  helper?: string;
  required?: boolean;
}>();

const showHelper = ref(false);
</script>

<style lang="scss">
.FormItem {
  display: flex;
  flex-direction: column;
  &__label {
    font-size: 14px;
    color: var(--color-text);
    margin-bottom: 4px;
    padding: 6px 0;
    display: flex;
    align-items: center;
    &__required {
      color: var(--form-details-error-message-color);
      margin-right: 4px;
    }
    &__title {
      // color: var(--color-primary);
      font-weight: bold;
    }
    &__helperBtn {
      opacity: 0.6;
      font-weight: 100;
      margin: -6px;
      margin-left: 0;
      padding: 6px;
      cursor: pointer;
      .var-icon {
        font-size: 14px !important;
      }
    }
  }
  &__helper {
    font-size: 12px;
    color: #999;
    margin: -4px 0 12px 0;
  }
}
</style>