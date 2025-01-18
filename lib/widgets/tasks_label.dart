import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// A reusable label component for displaying task details with an icon and optional text.
///
/// `TaskLabel` offers a combination of an icon and optional text label for displaying task details.
/// It takes various properties for customization, allowing for:
///   - Specifying the icon using an icon code.
///   - Setting optional text label content.
///   - Controlling icon color and size.
///   - Enabling tap functionality (optional).
///
/// Key functionalities:
///   - `build`: Constructs the label using an `InkWell` for tap handling (if enabled).
///     - Displays the icon using `Iconify` with customizable color and size.
///     - Shows the text label (if provided) with theme-based styling (optional).
class TaskLabel extends StatelessWidget {
  const TaskLabel({
    required this.icon,
    super.key,
    this.labelText,
    this.iconColour,
    this.iconSize,
    this.isTappable,
  });

  final String icon;
  final String? labelText;
  final Color? iconColour;
  final double? iconSize;
  final bool? isTappable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          child: Iconify(
            icon,
            size: iconSize ?? 18,
            color: iconColour ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        if (labelText != null) ...[
          const SizedBox(
            width: 4,
          ),
          Text(
            labelText!,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ]
      ],
    );
  }
}
