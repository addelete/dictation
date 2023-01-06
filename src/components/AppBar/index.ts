import type { App } from 'vue';
import AppBarComponent from './AppBar.vue';

const AppBar = {
  install: function (Vue: App) {
    Vue.component('AppBar', AppBarComponent);
  },
};

export default AppBar;
