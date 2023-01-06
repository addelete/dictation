

<template>
  <div class="Search Page">
    <app-bar title="搜索" />
    <div class="Search__body PageBody">
      <search-box v-model="searchKey" />
      <div class="noResults" v-if="searchKey && folders.length + dictations.length === 0">
        无结果
      </div>
      <div class="results" v-else>
        <div
          class="item"
          v-for="(item, index) in folders"
          :key="index"
          v-ripple
          @click="goFolderPage(item)"
        >
          <img :src="folderIcon" class="icon" />
          <div class="title">{{ item.name }}</div>
        </div>
        <div
          class="item"
          v-for="(item, index) in dictations"
          :key="index"
          v-ripple
          @click="goDictatioPage(item)"
        >
          <img :src="dictationIcon" class="icon" />
          <div class="title">{{ item.title }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import debounce from 'lodash-es/debounce';
import { connection } from '@@/utils/db';
import folderIcon from '@@/assets/folder.svg';
import dictationIcon from '@@/assets/dictation.svg';
import { useRouter } from 'vue-router';

const router = useRouter();
const searchKey = ref('');
const folders = ref<Folder[]>([]);
const dictations = ref<Dictation[]>([]);

watch(
  () => searchKey.value,
  () => {
    search();
  },
);

const search = debounce(() => {
  if (!searchKey.value) {
    folders.value = [];
    dictations.value = [];
    return;
  }
  connection
    .select<Folder>({
      from: 'folders',
      where: {
        name: {
          like: `%${searchKey.value}%`,
        },
      },
    })
    .then((res) => {
      folders.value = res;
    });
  connection
    .select<Dictation>({
      from: 'dictations',
      where: {
        title: {
          like: `%${searchKey.value}%`,
        },
        or: {
          description: {
            like: `%${searchKey.value}%`,
          },
        },
      } as any,
    })
    .then((res) => {
      dictations.value = res;
    });
}, 500);

const goFolderPage = (folder: Folder) => {
  router.push({
    name: 'Home',
    query: {
      folderId: folder.id,
    },
  });
};

const goDictatioPage = (dictation: Dictation) => {
  router.push({
    name: 'Dictation',
    query: {
      dictationId: dictation.id,
    },
  });
};
</script>

<style lang="scss">
.Search {
  &__body {
    padding: 3.2vw;
  }
  .noResults {
    padding: 24px;
    color: var(--body-text);
    font-size: 14px;
    text-align: center;
  }
  .results {
    padding: 6px;
    .item {
      padding: 6px 0;
      border-bottom: 1px solid #82828222;
      color: var(--body-text);
      font-size: 14px;
      display: flex;
      cursor: pointer;
      .icon {
        width: 18px;
        height: 18px;
        margin-right: 12px;
        flex-shrink: 0;
      }
    }
  }
}
</style>