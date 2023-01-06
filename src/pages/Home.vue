

<template>
  <div class="Home Page">
    <app-bar
      :title="rootFolder.name"
      :showNavBack="rootFolder.id !== 0"
      :navBack="goLastLevel"
    />
    <div class="Home__body PageBody" @scroll="onPageBodyScroll">
      <search-box @focus="goToSearchPage" />
      <div class="itemList">
        <div class="item" v-for="item in displayList" :key="item.id">
          <img
            class="item__icon"
            :src="item.icon"
            :alt="item.name"
            @click="
              item.isFolder
                ? goFolderPage(item.data)
                : goPlayDictationPage(item.data)
            "
          />
          <div
            class="item__info"
            @click="
              item.isFolder
                ? goFolderPage(item.data)
                : goPlayDictationPage(item.data)
            "
          >
            <span class="item__info__name">{{ item.name }}</span>
            <span class="item__info__updatedAt">{{ item.updatedAt }}</span>
          </div>
          <div
            class="item__action"
            @click="
              item.isFolder
                ? showFolderActionsPopup(item.data)
                : showDictationActionsPopup(item.data)
            "
            v-ripple
          >
            <var-icon name="dots-vertical" />
          </div>
        </div>
      </div>
    </div>
    <div class="floatingBtn" :class="{ visible: floatingBtnVisible }">
      <var-button
        type="primary"
        size="large"
        round
        @click="addSthPopupOpen = true"
      >
        <var-icon name="plus" />
      </var-button>
    </div>
    <popup v-model:show="addSthPopupOpen" hideHeader>
      <div class="addSthPopupContent">
        <image-icon-button
          :imageIcon="dictationIcon"
          text="新建听写"
          @click="goCreateDictationPage"
        />
        <image-icon-button
          :imageIcon="folderIcon"
          text="新建文件夹"
          @click="showCreateFolderPopup"
        />
      </div>
    </popup>
    <popup
      v-model:show="editFolderPopupOpen"
      :title="editFolderPopupTitle"
      @ok="onEditFolderPopupOk"
    >
      <div class="editFolderPopupContent">
        <image-icon-button :imageIcon="folderIcon" />
        <input
          type="text"
          v-model="editingFolderName"
          placeholder="输入名称"
          ref="editingFolderNameInput"
        />
      </div>
    </popup>
    <popup v-model:show="folderActionsPopupOpen" hideHeader>
      <div class="addSthPopupContent">
        <image-icon-button
          :imageIcon="renameIcon"
          text="重命名"
          @click="showRenameFolderPopup"
        />
        <image-icon-button
          :imageIcon="deleteIcon"
          text="删除"
          @click="deleteFolder"
        />
        <image-icon-button
          :imageIcon="moveIcon"
          text="移动"
          @click="showMoveFolderPopup"
        />
      </div>
    </popup>
    <popup v-model:show="dictationActionsPopupOpen" hideHeader>
      <div class="addSthPopupContent">
        <image-icon-button
          :imageIcon="editIcon"
          text="修改"
          @click="goEditDictationPage"
        />
        <image-icon-button
          :imageIcon="deleteIcon"
          text="删除"
          @click="deleteDictation"
        />
        <image-icon-button
          :imageIcon="moveIcon"
          text="移动"
          @click="showMoveFolderPopup"
        />
      </div>
    </popup>
    <popup
      :title="`移动到${moveToFolder.name}`"
      v-model:show="moveFolderPopupOpen"
      @ok="onMoveFolderPopupOk"
    >
      <div class="moveFolderPopupContent">
        <div
          class="moveToFolderItem"
          v-if="moveToFolder.id !== zeroFolder.id"
          @click="moveToFolderClickBack"
          v-ripple
        >
          <img class="moveToFolderItem__icon" :src="backIcon" />
          <span class="moveToFolderItem__name">上一级</span>
        </div>
        <div
          class="moveToFolderItem"
          v-for="folder in moveToFolderList"
          :key="folder.id"
          @click="moveToFolder = folder"
          v-ripple
        >
          <img
            class="moveToFolderItem__icon"
            :src="folderIcon"
            :alt="folder.name"
          />
          <span class="moveToFolderItem__name">{{ folder.name }}</span>
        </div>
      </div>
    </popup>
  </div>
</template>

<script lang="ts" setup>
import { computed, onMounted, ref, watch } from 'vue';
import folderIcon from '@@/assets/folder.svg';
import dictationIcon from '@@/assets/dictation.svg';
import deleteIcon from '@@/assets/delete.svg';
import editIcon from '@@/assets/edit.svg';
import renameIcon from '@@/assets/rename.svg';
import moveIcon from '@@/assets/move.svg';
import backIcon from '@@/assets/back.svg';
import ImageIconButton from '@@/components/ImageIconButton/ImageIconButton.vue';
import { useRoute, useRouter } from 'vue-router';
import { connection, waitInitDb } from '@@/utils/db';
import { nowTimeString } from '@@/utils/time';

let pageBodyScrollTop = 0;
const router = useRouter();
const route = useRoute();

const zeroFolder = {
  id: 0,
  name: '根目录',
  parentId: -1,
  updatedAt: '',
};

const folders = ref<Folder[]>([zeroFolder]);
const dictations = ref<Dictation[]>([]);

const floatingBtnVisible = ref(true);
const addSthPopupOpen = ref(false);

const folderActionsPopupOpen = ref(false);
const dictationActionsPopupOpen = ref(false);
const editFolderPopupOpen = ref(false);
const moveFolderPopupOpen = ref(false);
const editFolderPopupTitle = ref('');
const editingFolderName = ref('');
const editingFolderNameInput = ref<HTMLInputElement>();
const currentFolderForActionPopup = ref<Folder>();
const currentDictationForActionPopup = ref<Dictation>();

const moveToFolder = ref<Folder>(zeroFolder);

const moveToFolderList = computed(() => {
  return folders.value.filter(
    (item) => item.parentId === moveToFolder.value.id,
  );
});

const folderId = computed(() => {
  return route.query.folderId ? Number(route.query.folderId) : 0;
});

const rootFolder = computed(() => {
  return folders.value.find((item) => item.id === folderId.value) || zeroFolder;
});

const dispaleyFolders = computed(() => {
  return folders.value
    .filter((folder) => folder.parentId === folderId.value)
    .map((item) => ({
      ...item,
      isFolder: true,
    }));
});

const displayList = computed(() => {
  return [
    ...dispaleyFolders.value.map((item) => ({
      isFolder: true,
      id: 'f_' + item.id,
      name: item.name,
      updatedAt: item.updatedAt,
      icon: folderIcon,
      data: item,
    })),
    ...dictations.value.map((item) => ({
      isFolder: false,
      id: 'd_' + item.id,
      name: item.title,
      updatedAt: item.wordsCount + '字词 ' + item.updatedAt,
      icon: dictationIcon,
      data: item,
    })),
  ] as (
    | {
        isFolder: true;
        id: string;
        name: string;
        updatedAt: string;
        icon: string;
        data: Folder;
      }
    | {
        isFolder: false;
        id: string;
        name: string;
        updatedAt: string;
        icon: string;
        data: Dictation;
      }
  )[];
});

watch(
  [() => folderId.value],
  () => {
    (async () => {
      dictations.value = [];
      await waitInitDb();
      const data = await connection.select<Dictation>({
        from: 'dictations',
        where: {
          folderId: folderId.value,
        },
      });
      data.sort((a, b) => {
        return b.updatedAt.localeCompare(a.updatedAt);
      });
      dictations.value = data;
    })();
  },
  {
    immediate: true,
    deep: true,
  },
);

onMounted(() => {
  (async () => {
    await waitInitDb();
    const data = await connection.select<Folder>({
      from: 'folders',
    });
    data.sort((a, b) => {
      return b.updatedAt.localeCompare(a.updatedAt);
    });
    folders.value.push(...data);
  })();
});

// 返回上一级
const goLastLevel = () => {
  if (rootFolder.value.id === 0) {
    return;
  }
  router.replace({
    name: 'Home',
    query: {
      folderId: rootFolder.value.parentId,
    },
  });
};

const onPageBodyScroll = (e: UIEvent) => {
  const scrollTop = (e.target as HTMLDivElement).scrollTop;
  if (scrollTop > pageBodyScrollTop) {
    floatingBtnVisible.value = false;
  } else {
    floatingBtnVisible.value = true;
  }
  pageBodyScrollTop = scrollTop;
};

const showCreateFolderPopup = () => {
  addSthPopupOpen.value = false;
  editFolderPopupOpen.value = true;
  editingFolderName.value = '';
  editFolderPopupTitle.value = '新建文件夹';
  currentFolderForActionPopup.value = undefined;
  setTimeout(() => {
    editingFolderNameInput.value?.focus();
  }, 500);
};

// 创建或修改文件夹并写入数据库
const onEditFolderPopupOk = async () => {
  if (editingFolderName.value.trim() === '') {
    return;
  }
  editFolderPopupOpen.value = false;
  if (currentFolderForActionPopup.value) {
    await connection.update({
      in: 'folders',
      set: {
        name: editingFolderName.value,
        updatedAt: nowTimeString(),
      },
      where: {
        id: currentFolderForActionPopup.value.id,
      },
    });
    const index = folders.value.findIndex(
      (item) => item.id === currentFolderForActionPopup.value?.id,
    );
    folders.value[index].name = editingFolderName.value;
  } else {
    const res = (await connection.insert<Folder>({
      into: 'folders',
      values: [
        {
          name: editingFolderName.value,
          parentId: rootFolder.value.id,
          updatedAt: nowTimeString(),
        },
      ],
      return: true,
    })) as Folder[];
    folders.value.unshift(res[0]);
  }
};

const goFolderPage = (folder: Folder) => {
  router.replace({
    name: 'Home',
    query: {
      folderId: folder.id,
    },
  });
};

const goPlayDictationPage = (dictation: Dictation) => {
  router.push({
    name: 'PlayDictation',
    query: {
      dictationId: dictation.id,
    },
  });
};

const showFolderActionsPopup = (folder: Folder) => {
  folderActionsPopupOpen.value = true;
  currentFolderForActionPopup.value = folder;
  currentDictationForActionPopup.value = undefined;
};

const showDictationActionsPopup = (dictation: Dictation) => {
  dictationActionsPopupOpen.value = true;
  currentDictationForActionPopup.value = dictation;
  currentFolderForActionPopup.value = undefined;
};

const showRenameFolderPopup = () => {
  folderActionsPopupOpen.value = false;
  editFolderPopupOpen.value = true;
  editFolderPopupTitle.value = '重命名文件夹';
  editingFolderName.value = currentFolderForActionPopup.value?.name || '';
  setTimeout(() => {
    editingFolderNameInput.value?.focus();
  }, 500);
};

const deleteFolder = async () => {
  if (!currentFolderForActionPopup.value) {
    return;
  }
  folderActionsPopupOpen.value = false;
  const res = await Dialog('确定删除？');
  if (res === 'confirm') {
    const folderIds = new Set<number>();
    folderIds.add(currentFolderForActionPopup.value.id);
    let loop = false;
    do {
      loop = false;
      folders.value.forEach((item) => {
        if (!folderIds.has(item.id) && folderIds.has(item.parentId)) {
          folderIds.add(item.id);
          loop = true;
        }
      });
    } while (loop);
    const folderIdsArray = Array.from(folderIds);
    await connection.remove({
      from: 'folders',
      where: {
        id: {
          in: folderIdsArray,
        },
      },
    });
    await connection.remove({
      from: 'dictations',
      where: {
        folderId: {
          in: folderIdsArray,
        },
      },
    });
    folders.value = folders.value.filter(
      (item) => !folderIdsArray.includes(item.id),
    );
  }
};

const goCreateDictationPage = () => {
  addSthPopupOpen.value = false;
  router.push({
    name: 'EditDictation',
    query: {
      folderId: rootFolder.value.id,
    },
  });
};

const goToSearchPage = () => {
  router.push('/search');
};

const goEditDictationPage = () => {
  dictationActionsPopupOpen.value = false;
  if (!currentDictationForActionPopup.value) {
    return;
  }
  router.push({
    name: 'EditDictation',
    query: {
      folderId: currentDictationForActionPopup.value.folderId,
      dictationId: currentDictationForActionPopup.value.id,
    },
  });
};

const deleteDictation = async () => {
  dictationActionsPopupOpen.value = false;
  if (!currentDictationForActionPopup.value) {
    return;
  }
  const res = await Dialog('确定删除？');
  if (res === 'confirm') {
    connection.remove({
      from: 'dictations',
      where: {
        id: currentDictationForActionPopup.value.id,
      },
    });
    dictations.value = dictations.value.filter(
      (item) => item.id !== currentDictationForActionPopup.value?.id,
    );
  }
};

const showMoveFolderPopup = () => {
  folderActionsPopupOpen.value = false;
  dictationActionsPopupOpen.value = false;
  moveFolderPopupOpen.value = true;
  moveToFolder.value = zeroFolder;
};

const moveToFolderClickBack = () => {
  const folder = folders.value.find(
    (item) => item.id === moveToFolder.value.parentId,
  );
  if (folder) {
    moveToFolder.value = folder;
  }
};

const onMoveFolderPopupOk = async () => {
  moveFolderPopupOpen.value = false;
  if (currentFolderForActionPopup.value) {
    await connection.update({
      in: 'folders',
      set: {
        parentId: moveToFolder.value.id,
      },
      where: {
        id: currentFolderForActionPopup.value.id,
      },
    });
    const index = folders.value.findIndex(
      (item) => item.id === currentFolderForActionPopup.value?.id,
    );
    folders.value[index].parentId = moveToFolder.value.id;
    return;
  }
  if (
    currentDictationForActionPopup.value &&
    moveToFolder.value.id !== currentDictationForActionPopup.value.folderId
  ) {
    await connection.update({
      in: 'dictations',
      set: {
        folderId: moveToFolder.value.id,
      },
      where: {
        id: currentDictationForActionPopup.value.id,
      },
    });
    const index = dictations.value.findIndex(
      (item) => item.id === currentDictationForActionPopup.value?.id,
    );
    dictations.value.splice(index, 1);
    return;
  }
};
</script>

<style lang="scss">
.Home {
  &__body {
    padding: 3.2vw;
    .itemList {
      .item {
        padding: 12px 4px;
        display: flex;
        align-items: center;
        gap: 16px;
        & + .item {
          margin-top: 12px;
        }
        &__icon {
          cursor: pointer;
          width: 36px;
          height: 36px;
        }
        &__info {
          cursor: pointer;
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 4px;
          &__name {
            font-size: 16px;
          }
          &__updatedAt {
            font-size: 12px;
            color: #999;
          }
        }
        &__action {
          padding: 4px;
          opacity: 0.8;
          cursor: pointer;
        }
      }
    }
  }
  .floatingBtn {
    position: fixed;
    bottom: 100px;
    right: 3.2vw;
    --button-round-padding: 12px;
    --icon-size: 24px;
    scale: 0;
    transition: all 0.3s;
    &.visible {
      scale: 1;
    }
  }
  .addSthPopupContent {
    padding: 30px 30px 60px;
    display: flex;
    gap: 20px;
  }
  .editFolderPopupContent {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 20px;
    padding: 30px 30px 60px;
    input {
      height: 40px;
      text-align: center;
      border: none;
      outline: none;
      box-shadow: none;
      background: rgba(128, 128, 128, 0.1);
      color: var(--body-text);
      font-size: 16px;
      border-radius: 20px;
      padding: 0 20px;
      width: 200px;
    }
  }
  .moveFolderPopupContent {
    padding: 0 20px 40px 20px;
    height: 60vh;
    overflow-y: auto;
    .moveToFolderItem {
      display: flex;
      align-items: center;
      padding: 6px 0;
      border-bottom: 1px solid #82828222;
      cursor: pointer;
      &__icon {
        width: 20px;
        height: 20px;
        flex-shrink: 0;
        margin-right: 12px;
      }
      &__name {
        color: var(--body-text);
      }
    }
  }
}
</style>