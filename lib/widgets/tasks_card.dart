import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:todoo_app/constants.dart';
import 'package:todoo_app/enums.dart';
import 'package:todoo_app/models/tasks_model.dart';
import 'package:todoo_app/providers/bottom_nav_bar_provider.dart';
import 'package:todoo_app/providers/tasks_provider.dart';
import 'package:todoo_app/screens/task_details.dart';
import 'package:todoo_app/utilities/util.dart';
import 'package:todoo_app/widgets/tasks_button.dart';
import 'package:todoo_app/widgets/tasks_confirmation_dialogue.dart';
import 'package:todoo_app/widgets/tasks_label.dart';
import 'package:todoo_app/widgets/tasks_pop_up_menu.dart';

/// A customizable task card widget component for the Todoo app.
///
/// `TodooTaskCard` displays information about a single task in a styled card format.
/// It utilizes Provider to access various state management providers.
/// Key functionalities:
///   - Displays task title, deadline, time, priority, category (if set).
///   - Handles taps for opening task details and shows a popup menu for edit/delete options.
///   - Updates task completion status using a confirmation dialog.
///   - Utilizes various helper functions for formatting date, time, priority, and category labels.
///
/// Build Function Breakdown:
///   - `InkWell`: Wraps the card for tap detection and task detail navigation.
///   - `Container`: Main card container with rounded corners and background color.
///   - `IntrinsicHeight`: Ensures the card adapts to its content height.
///   - `Row`: Divides the card into colored bar and content section.
///     - Colored bar: Represents task priority using theme's primary color.
///     - Content section (Expanded): Shows task details in a `Column`.
///       - Task title row: Displays title with ellipsis overflow and optional location/reminder icons.
///       - Task details section (IntrinsicHeight): Nested `Row` for deadline, time, priority, category.
///         - Left side: Displays deadline, time, priority (if set), and category (if set) using `TaskLabel`.
///         - Right side: Completion button ('Done' or 'Incomplete') based on task status.
///   - `TodooButton`: Used for the popup menu button (dots) and completion button.
///     - Popup menu button triggers a custom `showTodooMenu` function for edit/delete options.
///     - Completion button updates task completion state with confirmation.

/// **Note:** This widget relies on several external providers for data
///           and state management.
class TodooTaskCard extends ConsumerWidget {
  const TodooTaskCard({super.key, required this.currentTask});

  final TodooTask currentTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIdProvider = ref.read(currentEditingTaskProvider.notifier);
    final bottomNavBarIndexStateWatcher =
        ref.read(bottomNavigationBarProvider.notifier);
    final taskHandler = ref.read(allTasksProvider.notifier);
    final GlobalKey buttonKey = GlobalKey();

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodooTaskDetails(
              currentTask: currentTask,
            ),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kTodooAppRoundness),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 8,
                //height: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kTodooAppRoundness),
                    bottomLeft: Radius.circular(kTodooAppRoundness),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: kTodooCardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///Task item title display row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              currentTask.title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          if (currentTask.location != null &&
                              currentTask.location != '') ...[
                            const SizedBox(
                              width: 4,
                            ),
                            const TaskLabel(
                              icon: Ic.round_location_on,
                              iconSize: 16,
                            ),
                          ],
                          if (currentTask.isReminderActive != null &&
                              currentTask.isReminderActive != false) ...[
                            const SizedBox(
                              width: 4,
                            ),
                            const TaskLabel(
                              icon: Ic.notifications_active,
                              iconSize: 16,
                            ),
                          ],
                          const SizedBox(
                            width: 4,
                          ),
                          TodooButton(
                            onButtonTap: () async {
                              final RenderBox renderBox =
                                  buttonKey.currentContext!.findRenderObject()
                                      as RenderBox;
                              final Offset offset =
                                  renderBox.localToGlobal(Offset.zero);

                              ///Calling custom popup menu by passing current context and offset details.
                              final selectedValue = await showTodooMenu(
                                context: context,
                                offset: offset,
                              );

                              if (selectedValue == 'Edit') {
                                currentIdProvider.isEditingCurrently(
                                    true, currentTask.id);
                                bottomNavBarIndexStateWatcher
                                    .onNavBarItemTap(2);
                              } else if (selectedValue == 'Delete') {
                                Future.delayed(
                                    const Duration(milliseconds: 150),
                                    () async {
                                  if (context.mounted) {
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (context) =>
                                          TodooConfirmationDialogue(
                                        confirmationDialogueTitle:
                                            'Confirm Deletion',
                                        confirmationDialogueBodyText:
                                            'Are you sure you want to delete this task permanently?',
                                        onCancelTap: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        onConfirmTap: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        confirmButtonText: 'Delete',
                                      ),
                                    );
                                    if (shouldDelete == true) {
                                      taskHandler.deleteTask(currentTask);
                                    }
                                  }
                                });
                              }
                            },
                            key: buttonKey,
                            padding: const EdgeInsets.all(3),
                            icon: Mdi.dots_vertical,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TaskLabel(
                                  labelText: Utils.formatDate(
                                      currentTask.deadlineDate),
                                  icon: Ph.calendar_fill,
                                ),
                                if (currentTask.deadlineTime != null) ...[
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  TaskLabel(
                                    labelText: Utils.formatTime(
                                        currentTask.deadlineTime!),
                                    icon: Mdi.clock,
                                  ),
                                ],
                                if (currentTask.priority != Priority.none) ...[
                                  const SizedBox(height: 3),
                                  TaskLabel(
                                    icon: priorityIconMap[currentTask.priority]!
                                        .keys
                                        .first,
                                    labelText: Utils.getPriorityLabel(
                                        currentTask.priority!),
                                    iconSize: 18,
                                    iconColour:
                                        priorityIconMap[currentTask.priority]!
                                            .values
                                            .first,
                                  ),
                                ],
                                if (currentTask.category != Category.none) ...[
                                  const SizedBox(height: 3),
                                  TaskLabel(
                                    icon: categoryIconMap[currentTask.category]!
                                        .keys
                                        .first,
                                    labelText: Utils.getCategoryLabel(
                                        currentTask.category!),
                                    iconSize: 18,
                                    iconColour:
                                        categoryIconMap[currentTask.category]!
                                            .values
                                            .first,
                                  ),
                                ],
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TodooButton(
                                  onButtonTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return TodooConfirmationDialogue(
                                            confirmationDialogueTitle:
                                                currentTask.isCompleted
                                                    ? 'Mark As Incomplete?'
                                                    : 'Confirm Completion',
                                            confirmationDialogueBodyText: currentTask
                                                    .isCompleted
                                                ? 'Are you sure to mark task as Incomplete?'
                                                : 'Are you sure to mark task as Completed?',
                                            onCancelTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            confirmButtonText: 'Confirm',
                                            onConfirmTap: () {
                                              Navigator.of(context).pop();
                                              final taskHandler = ref.read(
                                                  allTasksProvider.notifier);
                                              taskHandler.editTask(
                                                currentTask
                                                  ..isCompleted =
                                                      !currentTask.isCompleted,
                                              );
                                            },
                                          );
                                        });
                                  },
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  buttonHeight: 38,
                                  icon: currentTask.isCompleted
                                      ? Mdi.cancel
                                      : Ic.round_check,
                                  buttonText: currentTask.isCompleted
                                      ? 'Incomplete'
                                      : 'Done',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
