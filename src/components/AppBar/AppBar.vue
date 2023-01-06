<template>
  <var-app-bar :title="title">
    <template #left v-if="showNavBack">
      <var-button
        color="transparent"
        text-color="#ffffff"
        round
        text
        @click="navBack"
      >
        <var-icon name="chevron-left" :size="24" />
      </var-button>
    </template>
    <template #right v-if="showThemeToggle">
      <var-button
        round
        text
        color="transparent"
        text-color="#ffffff"
        @click="themeStore.toggleTheme"
      >
        <var-icon
          :name="themeStore.isDark ? 'weather-night' : 'white-balance-sunny'"
          :size="24"
        />
      </var-button>
    </template>
  </var-app-bar>
</template>

<script lang="ts" setup>
import { computed } from 'vue';
import { useThemeStore } from '@@/stores/theme';
import { useRoute, useRouter } from 'vue-router';

const props = withDefaults(
  defineProps<{
    title: string;
    showNavBack?: boolean;
    showThemeToggle?: boolean;
    navBack?: () => void;
  }>(),
  {
    showNavBack: true,
    showThemeToggle: true,
  },
);

const themeStore = useThemeStore();
const route = useRoute();
const router = useRouter();

const navBack = () => {
  if (typeof props.navBack === 'function') {
    props.navBack();
  } else {
    router.back();
  }
};
</script>

<style lang="scss">
</style>