import type { App } from 'vue';
import SearchBoxComponent from './SearchBox.vue';

const SearchBox = {
  install: function (Vue: App) {
    Vue.component('SearchBox', SearchBoxComponent);
  },
};

export default SearchBox;
