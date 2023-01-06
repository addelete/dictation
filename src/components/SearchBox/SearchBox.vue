<template>
  <div class="SearchBox">
    <var-icon name="magnify" />
    <input
      placeholder="搜索文件夹或听写项目"
      :value="modelValue"
      @focus="onFocus"
      @input="onChange"
    />
  </div>
</template>

<script lang="ts" setup>
defineProps<{
  modelValue?: string;
}>();
const emit = defineEmits<{
  (event: 'focus'): void;
  (event: 'update:modelValue', value: string): void;
}>();
const onFocus = () => {
  emit('focus');
};
const onChange = (event: any) => {
  emit('update:modelValue', event.target.value);
};
</script>

<style lang="scss">
.SearchBox {
  padding: 12px 0;
  width: 100%;
  height: 42px;
  background: rgba(128, 128, 128, 0.1);
  border-radius: 20px;
  display: flex;
  align-items: center;
  padding: 0 10px;
  font-size: 14px;
  input {
    flex: 1;
    height: 100%;
    background: transparent;
    box-shadow: none;
    border: none;
    outline: none;
    padding: 0 4px;
    color: var(--body-text);
  }
}
</style>