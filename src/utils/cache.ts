export class CacheUtils {
  static prefix = 'dictation:';

  static setItem(key: string, value: any) {
    localStorage.setItem(CacheUtils.prefix + key, JSON.stringify(value));
  }

  static getItem<T>(key: string, defaultValue?: T): T | undefined {
    try {
      const value = localStorage.getItem(CacheUtils.prefix + key);
      if (!value) {
        return defaultValue;
      }
      return JSON.parse(value);
    } catch (error) {
      return defaultValue;
    }
  }

  static removeItem(key: string) {
    localStorage.removeItem(CacheUtils.prefix + key);
  }
}
