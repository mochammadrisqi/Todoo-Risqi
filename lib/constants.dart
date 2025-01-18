import 'package:flutter/material.dart';
import 'package:todoo_app/enums.dart';

/// Maps custom color names to `Color` objects.
///
/// `seedColourMap` associates `AppColours` enum values with corresponding
/// `Color` objects, providing a centralized color palette for the app.
/// It uses built-in color constants and custom `Color.fromARGB` values
/// for defining colors.
Map<AppColours, Color> seedColourMap = {
  AppColours.purple: Colors.purple,
  AppColours.indigo: Colors.indigo,
  AppColours.blue: const Color.fromARGB(255, 0, 103, 164),
  AppColours.green: Colors.green,
  AppColours.yellow: const Color.fromARGB(255, 200, 160, 0),
  AppColours.orange: Colors.orange,
  AppColours.red: Colors.red,
  AppColours.cyan: const Color.fromARGB(255, 0, 188, 212),
};

/// Defines common padding, margin, and roundness values for UI elements.
///
/// This section defines constants used throughout the app for consistent spacing and styling:
///   - `kScaffoldBodyPadding`: Padding for the main content area within a Scaffold.
///   - `kTodooCardPadding`: Padding within task card elements.
///   - `kTodooTagPadding`: Padding for tag elements.
///   - `kTodooButtonPadding`: Padding for buttons.
///   - `kTodooButtonMargin`: Margin for buttons.
///   - `kTodooAppRoundness`: Corner radius for rounded UI elements.
EdgeInsets kScaffoldBodyPadding =
    const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
EdgeInsets kTodooCardPadding =
    const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
EdgeInsets kTodooTagPadding =
    const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
EdgeInsets kTodooButtonPadding = const EdgeInsets.all(6);
EdgeInsets kTodooButtonMargin = const EdgeInsets.all(2);
double kTodooAppRoundness = 19.0;
