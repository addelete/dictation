/**
 * 语音合成
 */
export class SpeechSynthesizer {
  private static instance: SpeechSynthesizer;
  private s: SpeechSynthesisUtterance;
  private constructor() {
    this.s = new SpeechSynthesisUtterance();
    this.s.lang = 'zh-Hans-CN';
    this.s.rate = 0.8;
  }
  public static getInstance(): SpeechSynthesizer {
    if (!SpeechSynthesizer.instance) {
      SpeechSynthesizer.instance = new SpeechSynthesizer();
    }
    return SpeechSynthesizer.instance;
  }
  public speak(text: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.s.text = text;
      speechSynthesis.speak(this.s);
      this.s.onerror = (e) => {
        reject(e);
      };
      this.s.onend = () => {
        console.log('end');
        resolve();
      };
    });
  }
  public cancel(): void {
    speechSynthesis.cancel();
  }
  public pause(): void {
    speechSynthesis.pause();
  }
  public resume(): void {
    speechSynthesis.resume();
  }
}

