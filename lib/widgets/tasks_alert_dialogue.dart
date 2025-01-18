import 'package:flutter/material.dart';
import 'package:todoo_app/constants.dart';

/// A custom alert dialog component for the Todoo app.
///
/// `TodooAlertDialogue` is a `StatelessWidget` that creates a styled `AlertDialog` with a custom appearance.
/// It takes a title string and a list of content widgets as required parameters.
/// Key functionalities:
///   - `build`: Builds the `AlertDialog` with:
///     - Rounded corners using `RoundedRectangleBorder`.
///     - Background color from the theme's `surfaceContainer` color.
///     - Styled title using the theme's `titleSmall` text style.
///     - Content provided as a `Column` of widgets.
///     - Custom padding for the title and content.
class TodooAlertDialogue extends StatelessWidget {
  const TodooAlertDialogue({
    super.key,
    required this.title,
    required this.contentItems,
  });

  final String title;
  final List<Widget> contentItems;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kTodooAppRoundness),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      title: Padding(
        padding: const EdgeInsets.only(left: 6, top: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      titlePadding: kScaffoldBodyPadding,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: contentItems,
      ),
      contentPadding:
          kScaffoldBodyPadding.copyWith(left: 16, right: 16, bottom: 16),
    );
  }
}
