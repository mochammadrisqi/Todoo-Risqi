import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:todoo_app/constants.dart';
import 'package:todoo_app/enums.dart';
import 'package:todoo_app/models/tasks_model.dart';
import 'package:todoo_app/utilities/util.dart';
import 'package:todoo_app/widgets/task_detail_item.dart';

/// Displays the details of a specific task.
///
/// `TodooTaskDetails` is a `ConsumerWidget` that displays detailed information about a given `TodooTask`.
/// It receives the task as a required parameter in its constructor.
/// Key functionalities:
///   - `build`: Builds the task details screen using a `Scaffold` with an `AppBar` and a body containing the task details.
///     - The body uses a `SingleChildScrollView` to handle potential overflow from long descriptions.
///     - Task details are displayed in a `Column` of `TaskDetailItem` widgets,
///       each representing a specific task property (title, description, date, time, priority, category, location, reminder).
///     - Conditional logic is used to display appropriate messages for optional properties (e.g., "No description added").
///     - Icons and labels for priority and category are retrieved from `priorityIconMap` and `categoryIconMap`, respectively.
///     - Date and time are formatted using `Utils.formatDate` and `Utils.formatTime`.
class TodooTaskDetails extends ConsumerWidget {
  const TodooTaskDetails({required this.currentTask, super.key});

  final TodooTask currentTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoo Details'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: kScaffoldBodyPadding,
        child: SingleChildScrollView(
          child: Container(
            padding: kTodooCardPadding.copyWith(top: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(kTodooAppRoundness),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskDetailItem(
                  itemIcon: Ri.quill_pen_fill,
                  itemTitle: currentTask.title,
                ),
                const SizedBox(
                  height: 12,
                ),
                TaskDetailItem(
                  itemIcon: Ic.round_article,
                  itemTitle: (currentTask.description?.isNotEmpty ?? false)
                      ? currentTask.description!
                      : 'No description added for this task',
                ),
                const SizedBox(
                  height: 12,
                ),
                TaskDetailItem(
                  itemIcon: Ph.calendar_fill,
                  itemTitle: Utils.formatDate(currentTask.deadlineDate),
                ),
                const SizedBox(
                  height: 12,
                ),
                TaskDetailItem(
                  itemIcon: Mdi.clock,
                  itemTitle: Utils.formatTime(currentTask.deadlineTime),
                ),
                const SizedBox(
                  height: 12,
                ),
                TaskDetailItem(
                  itemIcon: priorityIconMap[currentTask.priority]!.keys.first,
                  itemTitle: '${Utils.getPriorityLabel(
                    currentTask.priority ?? Priority.none,
                  )} set',
                ),
                const SizedBox(
                  height: 12,
                ),
                TaskDetailItem(
                  itemIcon: categoryIconMap[currentTask.category]!.keys.first,
                  itemTitle:
                      '${Utils.getCategoryLabel(currentTask.category ?? Category.none)} category set',
                ),
                const SizedBox(
                  height: 12,
                ),
                TaskDetailItem(
                  itemIcon: Ic.round_location_on,
                  itemTitle: 'Location set to: ${currentTask.location}',
                ),
                const SizedBox(
                  height: 12,
                ),
                TaskDetailItem(
                  itemIcon: Ic.notifications,
                  itemTitle: (currentTask.isReminderActive ?? false)
                      ? 'Reminder is set for ${Utils.formatTime(currentTask.deadlineTime)} on ${Utils.formatDate(currentTask.deadlineDate)}'
                      : 'Reminder is not set',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
