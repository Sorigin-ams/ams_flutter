// lib/utils/utils/LanguageDataModel.dart

import 'package:flutter/material.dart';

class LanguageDataModel {
  static List<Locale> languageLocales() {
    return [
      const Locale('en', ''), // English
      const Locale('es', ''), // Spanish
      // Add other locales as needed
    ];
  }
}
