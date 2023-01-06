import * as JsStore from 'jsstore';
import type { ITable } from 'jsstore';
import workerInjector from 'jsstore/dist/worker_injector';
import { waitUntil } from 'async-wait-until';

export let initDb = false;
export const connection = new JsStore.Connection();
connection.addPlugin(workerInjector);

const dbName = 'dictation';
const tables: ITable[] = [
  {
    name: 'folders',
    columns: {
      id: { primaryKey: true, autoIncrement: true }, // id
      name: { notNull: true, dataType: 'string' }, // 名称
      parentId: { notNull: true, dataType: 'number', default: 0 }, // 父目录id
      updatedAt: { notNull: true, dataType: 'string' }, // 更新时间
    },
  },
  {
    name: 'dictations',
    columns: {
      id: { primaryKey: true, autoIncrement: true }, // id
      title: { notNull: true, dataType: 'string' }, // 名称
      description: { dataType: 'string' }, // 描述
      autoInterval: { notNull: true, dataType: 'number', default: 0 }, // 自动下一项时每项时长，单位秒
      autoRepeatCount: { notNull: true, dataType: 'number', default: 0 }, // 自动下一项时每项重复次数
      words: { notNull: true, dataType: 'array' }, // 字词列表
      wordsCount: { notNull: true, dataType: 'number', default: 0 }, // 字词数量
      wordsPreview: { notNull: true, dataType: 'string' }, // 字词预览，字词以逗号分隔
      updatedAt: { notNull: true, dataType: 'string' }, // 更新时间
      folderId: { notNull: true, dataType: 'number', default: 0 }, // 所属文件夹id
    },
  },
];

const database = {
  name: dbName,
  tables,
};

(async function init() {
  await connection.initDb(database);
  initDb = true;
})();

export async function waitInitDb() {
  await waitUntil(() => initDb);
}
