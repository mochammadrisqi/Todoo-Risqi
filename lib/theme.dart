import 'package:flutter/material.dart';
import 'package:todoo_app/constants.dart';

/// Defines light and dark themes for the Todoo app.
///
/// `AppTheme` provides static methods to create `ThemeData` objects
/// for light and dark modes, ensuring consistent styling throughout the app.
/// It uses a base text style and a color scheme to generate the themes.
///
/// Key functionalities:
///
/// `lightTheme(TextStyle baseTextStyle, ColorScheme appColourScheme)`:
///   - Creates a light theme based on provided base text style and color scheme.
///   - Uses Material 3 styling.
///   - Configures various theme properties:
///     - `hoverColor`, `splashColor`, `highlightColor`: Set to transparent to remove default hover/splash effects.
///     - `appBarTheme`: Styles the app bar with specific background color, icon color, and text style.
///     - `inputDecorationTheme`: Styles text input fields with rounded borders, primary color borders, and a filled background.
///     - `listTileTheme`: Styles list tiles with specific text styles, background color, and rounded corners.
///     - `textTheme`: Sets the text theme using the `setTextThemes` method.
///
/// `darkTheme(TextStyle baseTextStyle, ColorScheme appColourScheme)`:
///   - Creates a dark theme based on provided base text style and color scheme.
///   - Uses Material 3 styling.
///   - Configures various theme properties, similar to the light theme, but with appropriate dark mode color adjustments.
///
/// `setTextThemes(TextStyle baseStyle, Color textColor)`:
///   - Creates a `TextTheme` based on a base text style and a text color.
///   - Defines styles for various text categories
///   (titleLarge, titleMedium, titleSmall, labelLarge, labelMedium, labelSmall,
///   bodyLarge, bodyMedium, bodySmall) by copying the base style and customizing font size, weight, and color.
class AppTheme {
  static ThemeData lightTheme(
      TextStyle baseTextStyle, ColorScheme appColourScheme) {
    return ThemeData(useMaterial3: true, colorScheme: appColourScheme).copyWith(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: appColourScheme.surface,
        iconTheme: IconThemeData(
          color: appColourScheme.primary,
          size: 20,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: appColourScheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          borderSide: BorderSide(
            color: appColourScheme.primary,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          borderSide: BorderSide(
            color: appColourScheme.primary,
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          borderSide: BorderSide(
            color: appColourScheme.primary,
            width: 1,
          ),
        ),
        prefixIconColor: appColourScheme.primary,
        fillColor: appColourScheme.surfaceContainer,
        filled: true,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: appColourScheme.primary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: appColourScheme.primary,
        ),
        tileColor: appColourScheme.primary.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
        ),
      ),
      textTheme: setTextThemes(
        baseTextStyle,
        appColourScheme.primary,
      ),
    );
  }

  static ThemeData darkTheme(
      TextStyle baseTextStyle, ColorScheme appColourScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: appColourScheme,
    ).copyWith(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: appColourScheme.surface,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: appColourScheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          borderSide: BorderSide(
            color: appColourScheme.primary,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          borderSide: BorderSide(
            color: appColourScheme.primary,
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          borderSide: BorderSide(
            color: appColourScheme.primary,
            width: 1,
          ),
        ),
        prefixIconColor: appColourScheme.primary,
        fillColor: appColourScheme.surfaceContainer,
        filled: true,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: appColourScheme.primary,
        ),
      ),
      textTheme: setTextThemes(
        baseTextStyle,
        appColourScheme.primary,
      ),
    );
  }

  static setTextThemes(TextStyle baseStyle, Color textColor) {
    return TextTheme(
      titleLarge: baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: baseStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelLarge: baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelMedium: baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelSmall: baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: baseStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodySmall: baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }
}
