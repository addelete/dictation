/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue';
  const component: DefineComponent<{}, {}, any>;
  export default component;
}

interface Folder {
  id: number; // id
  name: string; // 名称
  parentId: number; // 父级id
  updatedAt: string; // 更新时间
}

type WordItem = {
  word: string; // 单词
  speak: string; // 发音
};

type FormDictation = {
  title: string; // 名称
  description: string; // 描述
  autoInterval: number; // 自动下一项时每项时长，单位秒
  autoRepeatCount: number; // 自动下一项时每项重复次数
  words: WordItem[]; // 字词列表
  
};

type Dictation = FormDictation & {
  id: number; // id
  wordsCount: number; // 字词数量
  wordsPreview: string; // 字词预览，字词以逗号分隔
  updatedAt: string; // 更新时间
  folderId: number; // 所属文件夹id
  updatedAt: string; // 更新时间
  folderId: number; // 所属文件夹id
};
