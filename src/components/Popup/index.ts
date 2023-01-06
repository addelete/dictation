import type { App } from 'vue';
import PopupComponent from './Popup.vue';

const Popup = {
  install: function (Vue: App) {
    Vue.component('Popup', PopupComponent);
  },
};

export default Popup;
