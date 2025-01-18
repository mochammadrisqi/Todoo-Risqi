import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the app's theme seed color and persists it using SharedPreferences.

/// `AppThemeSeedColourNotifier` manages the app's theme seed color using Riverpod's `StateNotifier`.
/// It uses SharedPreferences to persist the chosen color across app sessions.
///
/// The initial state is set to `Colors.grey`.
///
/// `loadThemeColour()` loads the saved seed color from SharedPreferences on initialization.
///
/// `changeSeedColour(Color newSeedColour)` updates the state with the new
/// seed color and persists it to SharedPreferences.
class AppThemeSeedColourNotifier extends StateNotifier<Color> {
  static const _colourKey = 'app_seed_colour';

  AppThemeSeedColourNotifier() : super(Colors.grey) {
    loadThemeColour();
  }

  Future<void> loadThemeColour() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSeed = prefs.getInt(_colourKey);
    if (savedSeed != null) {
      state = Color(savedSeed);
    }
  }

  void changeSeedColour(Color newSeedColour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colourKey, newSeedColour.value);
    state = newSeedColour;
  }
}

/// Provides access to the app's theme seed color and its management logic.
///
/// `appThemeSeedColourProvider` uses Riverpod's `StateNotifierProvider` to:
///   - Provide an instance of `AppThemeSeedColourNotifier`.
///   - Expose the current theme seed color as a `Color`.
///   - Allow access to methods for loading and changing the seed color.
final appThemeSeedColourProvider =
    StateNotifierProvider<AppThemeSeedColourNotifier, Color>((ref) {
  return AppThemeSeedColourNotifier();
});
