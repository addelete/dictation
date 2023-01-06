import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import components from 'unplugin-vue-components/vite'
import autoImport from 'unplugin-auto-import/vite'
import { VarletUIResolver } from 'unplugin-vue-components/resolvers'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  base: './',
  plugins: [
    vue(),
    components({
      resolvers: [VarletUIResolver()]
    }),
    autoImport({
      resolvers: [VarletUIResolver({ autoImport: true })]
    })
  ],
  server: {
    host: true,
  },
  resolve: {
    alias: {
      '@@': path.resolve(__dirname, 'src'),
    },
  },
});
