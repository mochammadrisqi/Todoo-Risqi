import 'package:flutter/material.dart';
import 'package:todoo_app/widgets/tasks_alert_dialogue.dart';
import 'package:todoo_app/widgets/tasks_button.dart';

/// A custom confirmation dialog for the Todoo app.
///
/// `TodooConfirmationDialogue` is a `StatelessWidget` that creates a styled confirmation dialog with a title, body text, and cancel/confirm buttons.
/// It takes the title, body text, cancel tap callback, confirm tap callback, and confirm button text as required parameters.
///
/// Key functionalities:
///   - `build`: Builds the confirmation dialog using a `TodooAlertDialogue` as its base.
///     - Sets the title of the dialog using the provided `confirmationDialogueTitle`.
///     - Displays the confirmation message using a `Text` widget with theme-based styling.
///     - Creates a `Row` of buttons for "Cancel" and "Confirm" actions.
///       - The "Cancel" button calls the provided `onCancelTap` callback.
///       - The "Confirm" button calls the provided `onConfirmTap` callback and uses the provided `confirmButtonText`.
class TodooConfirmationDialogue extends StatelessWidget {
  const TodooConfirmationDialogue(
      {super.key,
      required this.confirmationDialogueTitle,
      required this.confirmationDialogueBodyText,
      required this.onCancelTap,
      required this.onConfirmTap,
      required this.confirmButtonText});

  final String confirmationDialogueTitle;
  final String confirmationDialogueBodyText;
  final void Function() onCancelTap;
  final void Function() onConfirmTap;
  final String confirmButtonText;

  @override
  Widget build(BuildContext context) {
    return TodooAlertDialogue(
      title: confirmationDialogueTitle,
      contentItems: [
        Text(
          confirmationDialogueBodyText,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TodooButton(
              onButtonTap: onCancelTap,
              buttonHeight: 38,
              buttonText: 'Cancel',
              buttonColour:
                  Theme.of(context).colorScheme.primary.withOpacity(0.06),
            ),
            const SizedBox(width: 4),
            TodooButton(
              onButtonTap: onConfirmTap,
              buttonHeight: 38,
              buttonText: confirmButtonText,
            ),
          ],
        )
      ],
    );
  }
}
