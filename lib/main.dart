import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/providers/theme_colour_provider.dart';
import 'package:todoo_app/screens/home_tabs.dart';
import 'package:todoo_app/theme.dart';

/// Entry point and main application widget for the Todoo app.
///
/// This code sets up the Todoo application using Flutter and Riverpod for state management.
/// It defines the main app widget (`TodooApp`) and its state (`_TodooAppState`),
/// which handle theme initialization and the main application structure.
///
/// Key components and functionalities:
///
/// `main()`:
///   - The entry point of the application.
///   - Wraps the `TodooApp` with `ProviderScope` to enable Riverpod state management throughout the app.
///
/// `TodooApp` (ConsumerStatefulWidget):
///   - The root widget of the application, responsible for setting up the app's theme and navigation.
///
/// `_TodooAppState` (ConsumerState):
///   - Manages the state of the `TodooApp`, including theme data.
///   - `baseTextStyle`: Defines a base text style used for consistent styling throughout the app.
///   - `lightTheme` and `darkTheme`: Store the light and dark theme data, respectively.
///      Initialized in `initializeThemes`.
///   - `generateColourScheme(Color colour, Brightness brightness)`: Generates a `ColorScheme`
///      from a seed color and brightness value. Used to create light and dark color schemes.
///   - `initializeThemes(Color seedColour)`: Initializes the `lightTheme` and `darkTheme`
///      based on the provided seed color.
///      It uses an external `AppTheme` class (not shown) to create the actual `ThemeData` objects.
///   - `build(BuildContext context)`: Builds the `MaterialApp` widget:
///     - Watches the `appThemeSeedColourProvider` to dynamically update the theme based on the user's selected seed color.
///     - Calls `initializeThemes` to generate theme data based on the watched seed color.
///     - Sets `debugShowCheckedModeBanner` to `false` to hide the debug banner.
///     - Sets the `theme` and `darkTheme` properties of the `MaterialApp`.
///     - Sets the `themeMode` to `ThemeMode.system` to respect the user's system-wide theme preference.
///     - Sets the `home` property to `TodooHome`, which is the main screen of the application.
void main() async {
  runApp(
    const ProviderScope(
      child: TodooApp(),
    ),
  );
}

class TodooApp extends ConsumerStatefulWidget {
  const TodooApp({super.key});

  @override
  ConsumerState<TodooApp> createState() => _TodooAppState();
}

class _TodooAppState extends ConsumerState<TodooApp> {
  final TextStyle baseTextStyle = const TextStyle(
    fontFamily: 'JosefinSans',
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  late ThemeData lightTheme;
  late ThemeData darkTheme;

  ColorScheme generateColourScheme(Color colour, Brightness brightness) =>
      ColorScheme.fromSeed(seedColor: colour, brightness: brightness);

  void initializeThemes(Color seedColour) {
    final lightColourScheme =
        generateColourScheme(seedColour, Brightness.light);
    final darkColourScheme = generateColourScheme(seedColour, Brightness.dark);
    lightTheme = AppTheme.lightTheme(baseTextStyle, lightColourScheme);
    darkTheme = AppTheme.darkTheme(baseTextStyle, darkColourScheme);
  }

  @override
  Widget build(BuildContext context) {
    final appSeedColourWatcher = ref.watch(appThemeSeedColourProvider);
    initializeThemes(appSeedColourWatcher);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const TodooHome(),
    );
  }
}
