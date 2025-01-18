import 'package:flutter/material.dart';
import 'package:todoo_app/constants.dart';

/// Displays a custom popup menu for editing or deleting a task.
///
/// `showTodooMenu` is an asynchronous function that shows a popup menu with two options: "Edit" and "Delete".
/// It takes the context and the offset where the menu should be displayed as required parameters.
/// Returns a `Future<String?>` that resolves to the selected option value (e.g., 'Edit' or 'Delete')
/// or null if the menu is dismissed without a selection.
///
/// Key functionalities:
///   - Uses `showMenu` from `flutter/material.dart` to create the popup menu.
///     - Positions the menu relative to the provided `offset`, adjusting for slight vertical offset.
///     - Constrains the menu width to 140dp for better presentation on smaller screens.
///     - Defines two `PopupMenuItem` options:
///       - "Edit": Triggers editing functionality when selected.
///       - "Delete": Prompts for confirmation before deletion.
///   - Disables animation for a smoother menu appearance.
///   - Sets a rounded rectangle shape with theme-based `kTodooAppRoundness`.
///   - Uses theme colors for background and text styling.
Future<String?> showTodooMenu({
  required BuildContext context,
  required Offset offset,
}) {
  return showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(offset.dx, offset.dy - 2, 16, 0),
    constraints: const BoxConstraints.tightFor(width: 140),
    items: [
      PopupMenuItem<String>(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 4),
        value: 'Edit',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.edit,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              'Edit Todoo',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        padding: const EdgeInsets.fromLTRB(10, 4, 0, 10),
        value: 'Delete',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.delete,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              'Delete Todoo',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    ],
    popUpAnimationStyle: AnimationStyle.noAnimation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kTodooAppRoundness),
    ),
    menuPadding: EdgeInsets.zero,
    color: Theme.of(context).colorScheme.surface,
  );
}
