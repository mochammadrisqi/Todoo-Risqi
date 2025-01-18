import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// A task detail item component for a task.
///
/// `TaskDetailItem` is a `StatelessWidget` that displays a single piece of information about a task, such as its title, description, or due date.
/// It takes an icon and a title as required parameters.
/// Key functionalities:
///   - `build`: Builds a `Row` containing an icon and a text label.
///     - Uses `Iconify` to display the provided icon.
///     - Uses an `Expanded` widget to allow the text label to take up available space.
///     - Styles the text label using the theme's `labelLarge` text style.
class TaskDetailItem extends StatelessWidget {
  const TaskDetailItem(
      {super.key, required this.itemIcon, required this.itemTitle});

  final String itemIcon;
  final String itemTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Iconify(
          itemIcon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Text(
            itemTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
