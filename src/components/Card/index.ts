import type { App } from 'vue';
import CardComponent from './Card.vue';

const Card = {
  install: function (Vue: App) {
    Vue.component('Card', CardComponent);
  },
};

export default Card;
