import type { App } from 'vue';
import FormItemComponent from './FormItem.vue';

const FormItem = {
  install: function (Vue: App) {
    Vue.component('FormItem', FormItemComponent);
  },
};

export default FormItem;
