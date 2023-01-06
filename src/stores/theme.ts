import { defineStore } from 'pinia';
import dark from '@varlet/ui/es/themes/dark';
import { CacheUtils } from '@@/utils/cache';

const isDark = CacheUtils.getItem<boolean>('isDark', false) || false;

function setStyleProvider(isDark: boolean) {
  StyleProvider(isDark ? dark : {});
}
setStyleProvider(isDark);

export const useThemeStore = defineStore('theme', {
  state: () => ({
    isDark,
  }),
  actions: {
    toggleTheme() {
      this.isDark = !this.isDark;
      setStyleProvider(this.isDark);
      CacheUtils.setItem('isDark', this.isDark);
    },
  },
});
