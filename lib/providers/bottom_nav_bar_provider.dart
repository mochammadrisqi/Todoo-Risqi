import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the state of the bottom navigation bar.
///
/// `BottomNavigationBarNotifier` extends `StateNotifier<int>` to hold the currently selected
/// navigation index. It initializes the state to 1 (likely representing the default view).
///
/// `onNavBarItemTap(int nevValueOnTap)` updates the state (the selected index) when a
/// navigation item is tapped.
class BottomNavigationBarNotifier extends StateNotifier<int> {
  BottomNavigationBarNotifier() : super(1);

  onNavBarItemTap(int nevValueOnTap) {
    state = nevValueOnTap;
  }
}

/// `bottomNavigationBarProvider` provides an instance of `BottomNavigationBarNotifier`
/// and exposes its state as an `int` using Riverpod's `StateNotifierProvider`.
final bottomNavigationBarProvider =
    StateNotifierProvider<BottomNavigationBarNotifier, int>(
  (ref) {
    return BottomNavigationBarNotifier();
  },
);
