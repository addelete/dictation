import { createApp } from 'vue';
import { createPinia } from 'pinia';
import '@varlet/touch-emulator'

import './style.css';
import App from './App.vue';
import { router } from './router';
import AppBar from './components/AppBar';
import FormItem from './components/FormItem';
import Card from './components/Card';
import SearchBox from './components/SearchBox';
import Popup from './components/Popup';

const app = createApp(App);
app.use(createPinia());
app.use(router);
app.use(AppBar);
app.use(FormItem);
app.use(SearchBox)
app.use(Popup)
app.use(Card);
app.mount('#app');
