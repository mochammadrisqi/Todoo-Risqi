import 'package:intl/intl.dart';
import 'package:todoo_app/enums.dart';

/// Utility methods for formatting and processing data in the Todoo app.
///
/// `Utils` offers various helper functions for handling dates, times, and other data within the app.
///
/// Key functionalities:
///   - `formatDate`: Formats a `DateTime` object into a human-readable date string (e.g., "21 Dec 2024").
///   - `formatTime`: Formats a `DateTime` object into a human-readable time string (e.g., "10:30 AM").
///     - Handles the case where no time is picked and displays a placeholder message.
///   - `getPriorityLabel`: Transforms a `Priority` enum value into a user-friendly label (e.g., "High Priority").
///   - `getCategoryLabel`: Transforms a `Category` enum value into a user-friendly label (e.g., "Work Category").
///   - `getColourLabel`: Transforms an `AppColours` enum value into a user-friendly label (e.g., "Blue Colour").
class Utils {
  static String formatDate(DateTime pickedDate) {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(pickedDate);
  }

  static String formatTime(DateTime? pickedTime) {
    final formatter = DateFormat('hh:mm a');
    if (pickedTime != null) {
      return formatter.format(pickedTime);
    } else {
      return 'No Time Picked';
    }
  }

  static String getPriorityLabel(Priority priority) {
    if (priority == Priority.none) {
      return 'No Priority';
    }
    return '${priority.name.substring(0, 1).toUpperCase()}${priority.name.substring(1)} Priority';
  }

  static String getCategoryLabel(Category category) {
    if (category == Category.none) {
      return 'No Category';
    }
    return category.name.substring(0, 1).toUpperCase() +
        category.name.substring(1);
  }

  static String getColourLabel(AppColours colour) {
    return colour.name.substring(0, 1).toUpperCase() + colour.name.substring(1);
  }
}
