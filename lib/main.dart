import 'package:dictation/bindings/tts_setting_binding.dart';
import 'package:dictation/services/default_data_service.dart';
import 'package:dictation/services/tts_service.dart';
import 'package:dictation/views/tts_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dictation/bindings/edit_dictation_binding.dart';
import 'package:dictation/services/isar_service.dart';
import 'package:dictation/views/edit_dictation_view.dart';
import 'package:dictation/views/home_view.dart';
import 'package:dictation/views/play_dictation_view.dart';
import 'package:dictation/views/search_view.dart';
import 'package:dictation/bindings/home_binding.dart';
import 'package:dictation/bindings/play_dictation_binding.dart';
import 'package:dictation/bindings/search_binding.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  /// 等待服务初始化.
  await initServices();

  runApp(GetMaterialApp(
    initialRoute: "/home",

    getPages: [
      GetPage(
          name: "/home", page: () => const HomeView(), binding: HomeBinding()),
      GetPage(
          name: "/edit_dictation",
          page: () => const EditDictationView(),
          binding: EditDictationBinging()),
      GetPage(
          name: "/play_dictation",
          page: () =>  PlayDictationView(),
          binding: PlayDictationBinding()),
      GetPage(
          name: "/search",
          page: () =>  const SearchView(),
          binding: SearchBinding()),
      GetPage(
          name: "/tts_setting",
          page: () =>   TtsSettingView(),
          binding: TtsSettingBinding()),
    ],
    theme: ThemeData(
      useMaterial3: true,
    ),
    darkTheme: ThemeData.dark(
      useMaterial3: true,
    ),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    localizationsDelegates:const  [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'), // English
      Locale('zh', 'CN'), // Spanish
    ],
    locale: const Locale('zh', 'CN'),
  ));
}

/// 初始化服务
Future<void> initServices() async {
  await GetStorage.init();
  await Get.putAsync(() => IsarService().init());
  await Get.putAsync(() => TtsService().init());
  await Get.putAsync(() => DefaultDataService().init());
}
