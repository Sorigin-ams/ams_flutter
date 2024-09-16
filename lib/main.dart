import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:sk_ams/store/AppStore.dart';
import 'package:sk_ams/utils/utils/AConstants.dart';
import 'package:sk_ams/utils/utils/ADataProvider.dart';
import 'package:sk_ams/utils/utils/AppTheme.dart';
import 'package:sk_ams/screens/splash_screen.dart';
import 'package:sk_ams/utils/utils/LanguageDataModel.dart'
as localLanguageModel;

AppStore appStore = AppStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  // Print the supported locales to debug
  print(
      'Supported Locales: ${localLanguageModel.LanguageDataModel.languageLocales()}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inspection App${!isMobile ? ' ${platformName()}' : ''}',
        home: const ASplashScreen(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales:
        localLanguageModel.LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
// added search bar everywhere where needed in app
// Appbar popover added to app title
// my task back arrow is removed
// added clear and clear all to notification screen,
