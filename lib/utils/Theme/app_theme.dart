import 'package:flutter/material.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'app_text_style.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: ColorUtils.white,
    primaryColor: ColorUtils.primary,
    secondaryHeaderColor: ColorUtils.secondary,
    iconTheme: const IconThemeData(color: ColorUtils.black),
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: ColorUtils.black,
      collapsedIconColor:
          ColorUtils
              .black, // Set the ExpansionTile icon color to black for light mode
    ),
    colorScheme: ColorScheme.light(
      primary: ColorUtils.primary,
      secondary: ColorUtils.secondary,
      outline: ColorUtils.grey99,
      onBackground: ColorUtils.white,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        return ColorUtils.primary; // Default color
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return ColorUtils.grey99.withOpacity(0.2); // Hover effect
        }
        return Colors.transparent; // Default overlay
      }),
    ),
    textTheme: TextTheme(
      bodyLarge: fontStyleBold.copyWith(decoration: TextDecoration.none),
      bodyMedium: fontStyleSemiBold.copyWith(decoration: TextDecoration.none),
      bodySmall: fontStyleRegular.copyWith(decoration: TextDecoration.none),
      titleLarge: fontStyleBold.copyWith(
        color: ColorUtils.white,
        decoration: TextDecoration.none,
      ), // Extra heading text
      titleMedium: fontStyleSemiBold.copyWith(
        color: ColorUtils.white,
        decoration: TextDecoration.none,
      ), // Extra heading text
      titleSmall: fontStyleRegular.copyWith(
        color: ColorUtils.white,
        decoration: TextDecoration.none,
      ), // Extra heading text
    ),
    appBarTheme: AppBarTheme(backgroundColor: ColorUtils.secondary),
    dividerTheme: DividerThemeData(color: ColorUtils.grey99),
    checkboxTheme: CheckboxThemeData(
      // Using WidgetStateProperty for state-dependent colors
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorUtils.primary;
        }
        return Colors.white;
      }),
      // Using StatePropertyAll for simple values
      checkColor: const WidgetStatePropertyAll<Color>(Colors.white),
      // Shape of the checkbox
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      // Border color
      side: BorderSide(color: ColorUtils.primary, width: 2),
      // Using WidgetStateProperty for cursor
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return SystemMouseCursors.click;
      }),
    ),
  );

  static final ThemeData  darkTheme = ThemeData(
    scaffoldBackgroundColor: ColorUtils.darkThemeBg,
    cardColor: ColorUtils.darkThemeBg,
    // cardColor: const Color(0xff474747),
    primaryColor: ColorUtils.primary,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      // backgroundColor: Color(0xff464646),
      backgroundColor: ColorUtils.darkThemeBg,
    ),
    iconTheme: const IconThemeData(color: ColorUtils.white),
    inputDecorationTheme: InputDecorationTheme(),
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: ColorUtils.white,
      collapsedIconColor:
          ColorUtils
              .white, // Set the ExpansionTile icon color to black for light mode
    ),
    appBarTheme: AppBarTheme(backgroundColor: ColorUtils.grey99),
    colorScheme: ColorScheme.dark(
      primary: ColorUtils.primary,
      secondary: ColorUtils.secondary,
      outline: ColorUtils.grey99,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return ColorUtils.white; // Color when selected
        }
        return ColorUtils.white; // Default color
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return ColorUtils.grey99.withOpacity(0.2); // Hover effect
        }
        return Colors.transparent; // Default overlay
      }),
    ),
    textTheme: TextTheme(
      bodyLarge: fontStyleBold.copyWith(decoration: TextDecoration.none),
      bodyMedium: fontStyleSemiBold.copyWith(decoration: TextDecoration.none),
      bodySmall: fontStyleRegular.copyWith(decoration: TextDecoration.none),
      titleLarge: fontStyleBold.copyWith(
        color: ColorUtils.white,
        decoration: TextDecoration.none,
      ), // Extra heading text
      titleMedium: fontStyleSemiBold.copyWith(
        color: ColorUtils.white,
        decoration: TextDecoration.none,
      ), // Extra heading text
      titleSmall: fontStyleRegular.copyWith(
        color: ColorUtils.white,
        decoration: TextDecoration.none,
      ), // Extra heading text
    ),
  );
}
