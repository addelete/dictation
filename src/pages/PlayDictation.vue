<template>
  <div class="PlayDictation Page">
    <app-bar title="播放听写" />
    <div class="PlayDictation__body PageBody">
      <div class="playingIcon" v-if="playStatus === 'playing'">
        <voice-icon v-if="isSpeaking && !isPaused" />
        <div v-else-if="countdownCount">{{ countdownCount }}</div>
        <stop-icon v-else />
      </div>
      <div class="notStarted" v-if="dictation && playStatus === 'notStarted'">
        <var-space direction="column" align="center" size="large">
          <div class="title">{{ dictation.title }}</div>
          <div class="subTitle">共{{ dictation.wordsCount }}个字词</div>
          <div class="description">{{ dictation.description }}</div>
          <var-space class="actions">
            <var-button type="primary" @click="start"> 开始播放 </var-button>
            <var-button @click="showWords"> 字词列表 </var-button>
          </var-space>
        </var-space>
      </div>

      <div v-if="dictation && playStatus === 'playing'">
        <var-space direction="column" align="center" size="large">
          <div class="title">
            {{ wordIndex + 1 }} / {{ dictation.wordsCount }}
          </div>

          <var-space class="actions">
            <var-button @click="repeat" v-if="!isAutoPlay"> 重播 </var-button>
            <var-button type="primary" @click="next" v-if="!isAutoPlay">
              下一个
            </var-button>
            <var-button
              type="primary"
              v-if="isAutoPlay && !isPaused"
              @click="pause"
            >
              暂停
            </var-button>
            <var-button
              type="primary"
              v-if="isAutoPlay && isPaused"
              @click="resume"
            >
              继续
            </var-button>
          </var-space>
        </var-space>
      </div>
      <div v-if="dictation && playStatus === 'stopped'">
        <var-space direction="column" align="center" size="large">
          <div class="title">已完成</div>
          <div class="subTitle">共{{ dictation.wordsCount }}个字词</div>
          <var-space class="actions">
            <var-button @click="start"> 重新开始 </var-button>
            <var-button type="primary" @click="showWords">
              字词列表
            </var-button>
          </var-space>
        </var-space>
      </div>
      <div class="autoPlay">
        <var-space align="center" size="mini">
          <span>自动：</span>
          <var-switch v-model="isAutoPlay" />
        </var-space>
      </div>
      <popup v-model:show="wordsPopupOpen" :title="checkResultText" hideActions >
        <div class="wordsPopupContent" v-if="dictation">
          <div v-for="(word, index) in dictation.words" :key="index">
            <div class="word" :class="{ active: index === wordIndex }">
              <span class="sq">{{ index + 1 }}</span>
              <span> {{ word.word }}</span>
              <var-checkbox class="check" v-model="rightWords[index]"> </var-checkbox>
            </div>
          </div>
        </div>
      </popup>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { connection, waitInitDb } from '@@/utils/db';
import { SpeechSynthesizer } from '@@/utils/speech';
import { computed, onMounted, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import VoiceIcon from '@@/components/VoiceIcon/VoiceIcon.vue';
import StopIcon from '@@/components/StopIcon/StopIcon.vue';

const route = useRoute();
const dictationId = route.query.dictationId
  ? Number(route.query.dictationId)
  : 0;
const speechSynthesizer = SpeechSynthesizer.getInstance();

const dictation = ref<Dictation>();
const wordIndex = ref(-1);
const repeatId = ref(Date.now());
const playStatus = ref<'notStarted' | 'playing' | 'stopped'>('notStarted');
const isAutoPlay = ref(false);
const isPaused = ref(false);
const countdownCount = ref(0);
const isSpeaking = ref(false);
const wordsPopupOpen = ref(false);
const rightWords = ref<boolean[]>([]);

const checkResultText = computed(() => {
  if (!dictation.value) return '';
  const rightCount = rightWords.value.filter((v) => v).length;
  return `正确：${rightCount} / ${dictation.value.wordsCount}`;
});

onMounted(() => {
  (async () => {
    await waitInitDb();
    const res = await connection.select<Dictation>({
      from: 'dictations',
      where: {
        id: dictationId,
      },
    });
    if (res.length > 0) {
      dictation.value = res[0];
    }
  })();
});

watch([() => wordIndex.value, () => repeatId.value], () => {
  if (!dictation.value) return;
  if (wordIndex.value >= dictation.value.wordsCount) {
    playStatus.value = 'stopped';
    return;
  }
  const word = dictation.value.words[wordIndex.value];
  const text = (word.speak || word.word) + '。';
  if (!isAutoPlay.value) {
    isSpeaking.value = true;
    speechSynthesizer.speak(text).then(() => {
      isSpeaking.value = false;
    });
    return;
  }

  if (isAutoPlay.value) {
    let repeatedText = '';
    for (let i = 0; i < dictation.value.autoRepeatCount; i++) {
      repeatedText += text;
    }
    const seconds = dictation.value.autoInterval;
    isSpeaking.value = true;
    speechSynthesizer.speak(repeatedText).then(() => {
      isSpeaking.value = false;
      startCountdown(seconds);
      setTimeout(() => {
        if (isPaused.value) return;
        next();
      }, seconds * 1000);
    });
  }
});

watch(
  () => isAutoPlay.value,
  (val) => {
    if (val && playStatus.value === 'playing') {
      next();
    }
  },
);

const start = () => {
  wordIndex.value = 0;
  playStatus.value = 'playing';
};

const repeat = () => {
  repeatId.value = Date.now();
};

const next = () => {
  wordIndex.value++;
};

const pause = () => {
  isPaused.value = true;
  speechSynthesizer.pause();
};

const resume = () => {
  isPaused.value = false;
  speechSynthesizer.resume();
};

const showWords = () => {
  wordsPopupOpen.value = true;
};

const startCountdown = (interval: number) => {
  countdownCount.value = interval;
  const timer = setInterval(() => {
    countdownCount.value -= 1;
    if (!isAutoPlay.value) {
      countdownCount.value = 0;
    }
    if (countdownCount.value <= 0) {
      clearInterval(timer);
    }
  }, 1000);
};
</script>

<style lang="scss">
@keyframes iconScaleY {
  0% {
    transform: translateX(0);
  }
  50% {
    transform: translateX(50%);
  }
  100% {
    transform: translateX(90%);
  }
}

.PlayDictation {
  &__body {
    padding: 3.2vw;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 3.2vw;
    .actions {
      margin: 1em !important;
    }
    .title {
      font-size: 1.5em;
      font-weight: bold;
    }
    .subTitle {
      color: #666;
      text-align: center;
    }
    .description {
      font-size: 14px;
      color: #999;
      text-align: center;
      max-width: 600px;
    }
    .playingIcon {
      width: 120px;
      height: 120px;
      background: var(--color-primary);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 60px;
      font-weight: bold;
      color: #fff;
      .stopping {
        width: 30px;
        height: 30px;
        background: #fff;
        border-radius: 4px;
      }
    }
  }
  .wordsPopupContent {
    padding: 0 20px 40px 20px;
    height: 60vh;
    overflow-y: auto;
    .word {
      display: flex;
      align-items: center;
      padding: 6px 0;
      border-bottom: 1px solid #82828222;
      .sq {
        width: 30px;
        height: 20px;
        color: #fff;
        background: var(--color-primary);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-right: 12px;
        border-radius: 10px;
        font-size: 12px;
      }
      .check {
        margin-left: auto;
      }
    }
  }
}
</style>