<template>
  <div class="EditDictation Page">
    <app-bar :title="title" />
    <div class="EditDictation__body PageBody">
      <var-form ref="form">
        <var-space direction="column" :size="[16, 0]">
          <card title="基础信息">
            <var-space direction="column" :size="[14, 0]">
              <form-item label="标题" required>
                <var-input
                  :hint="false"
                  :rules="[(v) => !!v || '标题不能为空']"
                  v-model="formData.title"
                />
              </form-item>
              <form-item label="简介" helper="可输入一些关键词用于搜索">
                <var-input :hint="false" v-model="formData.description" />
              </form-item>
              <form-item
                label="自动听写间隔秒数"
                helper="自动听写时，当前单词语音播放完毕到播放下一词之间的间隔秒数"
              >
                <var-counter :min="1" v-model="formData.autoInterval" />
              </form-item>
              <form-item
                label="自动听写重复次数"
                helper="自动听写时，当前单词语音播放重复次数"
              >
                <var-counter :min="1" v-model="formData.autoRepeatCount" />
              </form-item>
            </var-space>
          </card>
          <card
            :title="`第${index + 1}个`"
            v-for="(_, index) in formData.words"
            :key="index"
          >
            <template #extra> 
              <var-button round type="primary" @click="deleteWord(index)">
                <var-icon name="window-close" />
              </var-button>
            </template>
            <var-space direction="column" :size="[14, 0]">
              <form-item label="字词" required>
                <var-input
                  :hint="false"
                  :rules="[(v) => !!v || '字词不能为空']"
                  v-model="formData.words[index].word"
                />
              </form-item>
              <form-item
                label="发音"
                helper="针对多音字，可在此设置正确读音的同音字用于播放，如果此项非空，听写时播放此项代替字词"
              >
                <var-input
                  :hint="false"
                  v-model="formData.words[index].speak"
                />
              </form-item>
            </var-space>
          </card>
          <var-button block @click="addWord">增加字词</var-button>
          <var-button block type="danger" @click="confirmReset"
            >重置</var-button
          >
          <var-button block type="primary" @click="save">保存</var-button>
        </var-space>
      </var-form>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { CacheUtils } from '@@/utils/cache';
import { computed, onMounted, ref, toRaw, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { connection, waitInitDb } from '@@/utils/db';
import { nowTimeString } from '@@/utils/time';

const route = useRoute();
const router = useRouter();

const folderId = route.query.folderId ? Number(route.query.folderId) : 0;
const dictationId = route.query.dictationId
  ? Number(route.query.dictationId)
  : 0;

let currentDictation: FormDictation | undefined = undefined;
const startDictation = (): FormDictation => {
  if (currentDictation) {
    return {
      title: currentDictation.title,
      description: currentDictation.description,
      autoInterval: currentDictation.autoInterval,
      autoRepeatCount: currentDictation.autoRepeatCount,
      words: currentDictation.words,
    };
  } else {
    return {
      title: '',
      description: '',
      autoInterval: 10,
      autoRepeatCount: 1,
      words: [],
    };
  }
};

const editCacheData = CacheUtils.getItem(
  `editDictation:${dictationId}`,
  startDictation(),
) as FormDictation;

const form = ref();
const formData = ref<FormDictation>(editCacheData);

const title = computed(() => {
  return dictationId ? '编辑听写' : '新建听写';
});

watch(
  () => formData.value,
  (val) => {
    CacheUtils.setItem(`editDictation:${dictationId}`, toRaw(val));
  },
  {
    deep: true,
  },
);

onMounted(() => {
  (async () => {
    if (dictationId) {
      await waitInitDb();
      const res = await connection.select<Dictation>({
        from: 'dictations',
        where: {
          id: dictationId,
        },
      });
      if (res.length) {
        currentDictation = res[0];
        if (editCacheData.title === '') {
          formData.value = startDictation();
        }
      }
    }
  })();
});

const addWord = () => {
  formData.value.words.push({
    word: '',
    speak: '',
  });
};

const deleteWord = (index: number) => {
  formData.value.words.splice(index, 1);
};

const confirmReset = async () => {
  const res = await Dialog({
    title: '重置',
    message: '重置后，当前编辑内容将丢失，是否继续？',
  });
  if (res === 'confirm') {
    formData.value = startDictation();
  }
  console.log('confirmReset');
};

const save = async () => {
  const res = await form.value.validate();
  if (!res) {
    Snackbar({
      content: '请检查表单内容',
      type: 'error',
    });
    return;
  }
  const data = toRaw(formData.value);
  const dataForDb: Omit<Dictation, 'id'> = {
    ...data,
    wordsCount: data.words.length,
    wordsPreview: data.words.map((item) => item.word).join('|'),
    updatedAt: nowTimeString(),
    folderId,
  };
  if (dictationId) {
    await connection.update({
      in: 'dictations',
      set: dataForDb,
      where: {
        id: dictationId,
      },
    });
  } else {
    await connection.insert({
      into: 'dictations',
      values: [dataForDb],
      return: true,
    });
  }
  CacheUtils.removeItem(`editDictation:${dictationId}`);
  Snackbar({
    content: '保存成功',
    type: 'success',
  });
  setTimeout(() => {
    router.back();
  }, 1000);
};
</script>

<style lang="scss">
.EditDictation {
  &__body {
    padding: 3.2vw;
  }
}
</style>