import 'package:flutter/material.dart';
import 'package:todoo_app/constants.dart';
import 'package:todoo_app/widgets/tasks_button.dart';

/// A customizable text field component for the Todoo app.
///
/// `TodooTextField` offers a versatile text input field with various configuration options.
/// It extends `StatelessWidget` and provides properties for tailoring the text field's appearance and behavior.
///
/// Key functionalities:
///   - `build`: Constructs the text field with optional title and action icon.
///     - Displays title using `Text` with theme-based styling (optional).
///     - Includes a custom action button using `TodooButton` (optional).
///     - The main text field is created using a `TextField` widget:
///       - Configurable properties include:
///         - Read-only mode (default: false).
///         - Text input controller for managing text content.
///         - Optional title and leading icon.
///         - Minimum and maximum number of lines.
///         - Maximum text length.
///         - Text capitalization style (default: sentences).
///         - Keyboard type (default: text).
///         - Text input action (default: done).
///         - Optional on-tap callback for handling text field taps.
///         - Optional input picker flag for adjusting text style.
///         - Optional focus node for managing focus state.
///         - Optional action icon and tap callback.
///       - Text changes are detected using `onChanged` and passed to the provided `onTextChanged` callback.
///   - Utilizes `RawScrollbar` for a subtle scrollbar on multiline text fields.
class TodooTextField extends StatelessWidget {
  const TodooTextField({
    super.key,
    required this.textFieldController,
    required this.textFieldIcon,
    this.textFieldTitle,
    this.isReadOnly,
    this.textFieldMinLines,
    this.textFieldMaxLines,
    this.textFieldMaxLength,
    this.textFieldCapitalization,
    this.textFieldKeyboardType,
    this.textFieldKeyboardInputAction,
    this.onTextFieldTap,
    this.isInputPicker,
    this.focusNode,
    this.textFieldActionIcon,
    this.onActionIconTap,
    required this.onTextChanged,
  });

  final bool? isReadOnly;
  final TextEditingController textFieldController;
  final String? textFieldTitle;
  final Widget textFieldIcon;
  final int? textFieldMinLines;
  final int? textFieldMaxLines;
  final int? textFieldMaxLength;
  final TextCapitalization? textFieldCapitalization;
  final TextInputType? textFieldKeyboardType;
  final TextInputAction? textFieldKeyboardInputAction;
  final Function()? onTextFieldTap;
  final bool? isInputPicker;
  final FocusNode? focusNode;
  final String? textFieldActionIcon;
  final Function()? onActionIconTap;
  final Function(String) onTextChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (textFieldTitle != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  textFieldTitle!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const Spacer(),
              if (textFieldActionIcon != null) ...[
                TodooButton(
                  icon: textFieldActionIcon,
                  padding: const EdgeInsets.all(0),
                  buttonColour: Colors.transparent,
                  margin: kTodooButtonMargin.copyWith(
                    right: 6,
                  ),
                  onButtonTap: onActionIconTap ?? () {},
                ),
              ],
            ],
          ),
          const SizedBox(
            height: 4,
          ),
        ],
        ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          child: RawScrollbar(
            thickness: 2,
            mainAxisMargin: 2,
            padding: const EdgeInsets.only(right: 4),
            radius: Radius.circular(kTodooAppRoundness),
            thumbColor: Theme.of(context).colorScheme.primary,
            fadeDuration: const Duration(milliseconds: 300),
            timeToFade: const Duration(milliseconds: 600),
            child: TextField(
              onTap: onTextFieldTap,
              onChanged: (newvalue) {
                onTextChanged(newvalue);
              },
              readOnly: isReadOnly ?? false,
              focusNode: focusNode,
              cursorHeight: 20,
              style: (isInputPicker ?? false)
                  ? Theme.of(context).textTheme.bodySmall
                  : Theme.of(context).textTheme.bodyMedium,
              textCapitalization:
                  textFieldCapitalization ?? TextCapitalization.sentences,
              keyboardType: textFieldKeyboardType ?? TextInputType.text,
              textInputAction:
                  textFieldKeyboardInputAction ?? TextInputAction.done,
              controller: textFieldController,
              maxLines: textFieldMaxLines ?? 1,
              minLines: textFieldMinLines ?? 1,
              maxLength: textFieldMaxLength,
              decoration: const InputDecoration().copyWith(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: textFieldIcon,
                ),
                prefixIconConstraints: const BoxConstraints(maxHeight: 22),
                counterStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
