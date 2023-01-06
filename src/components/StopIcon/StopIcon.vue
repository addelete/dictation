<template>
<div class="StopIcon">
  <div class="StopIcon__icon"></div>
  <div class="StopIcon__icon"></div>
</div>
</template>

<script lang="ts" setup>

</script>

<style lang="scss">
.StopIcon {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  .StopIcon__icon {
    width: 10px;
    border-radius: 3px;
    height: 30px;
    background-color: #fff;
  }
}
</style>