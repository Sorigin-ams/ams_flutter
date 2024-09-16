import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  AppThemeData._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.lightGreen, // Light green primary color
    primaryColorDark: Colors.green, // Darker green for contrast
    hoverColor: Colors.white54,
    dividerColor: Colors.green[200]!, // Ensure non-nullable value
    fontFamily: GoogleFonts.openSans().fontFamily,
    appBarTheme: const AppBarTheme(
      color: Colors.white, // White background for AppBar
      iconTheme: IconThemeData(color: Colors.green), // Green icons in AppBar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
    cardTheme: const CardTheme(color: Colors.white),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.green),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    textTheme: TextTheme(
      labelLarge: const TextStyle(color: Colors.green),
      titleLarge: const TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.grey[600]!),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme.light(primary: Colors.lightGreen)
        .copyWith(error: Colors.red),
  ).copyWith(
    pageTransitionsTheme:
        const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
    }),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[850]!, // Non-nullable color
    highlightColor: Colors.grey[800]!,
    appBarTheme: AppBarTheme(
      color: Colors.grey[850]!, // Non-nullable color
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: Colors.lightGreen,
    dividerColor: Colors.green[900]!.withOpacity(0.3),
    primaryColorDark: Colors.green,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts.openSans().fontFamily,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.grey[850]!),
    primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white)),
    cardTheme: CardTheme(color: Colors.grey[900]!),
    cardColor: Colors.grey[850]!,
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      labelLarge: const TextStyle(color: Colors.lightGreen),
      titleLarge: const TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.grey[400]!),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.dark(
      primary: Colors.lightGreen,
      onPrimary: Colors.grey[900]!,
    ).copyWith(secondary: Colors.white).copyWith(error: const Color(0xFFCF6676)),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
