<template>
  <div class="VoiceIcon">
    <div class="VoiceIcon__item"></div>
    <div class="VoiceIcon__item"></div>
    <div class="VoiceIcon__item"></div>
    <div class="VoiceIcon__item"></div>
    <div class="VoiceIcon__item"></div>
  </div>
</template>

<style lang="scss">
@keyframes itemAnimation {
  0% {
    height: 10px;
  }
  50% {
    height: 40px;
  }
  100% {
    height: 10px;
  }
}
.VoiceIcon {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 6px;
  .VoiceIcon__item {
    width: 6px;
    border-radius: 3px;
    height: 10px;
    background-color: #fff;
    animation: itemAnimation 1s infinite;
    
    @for $i from 1 through 5 {
      &:nth-child(#{$i}) {
        animation-delay: 0.1 * $i + s;
      }
    }
  }
}
</style>