import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/constants.dart';
import 'package:todoo_app/providers/tasks_provider.dart';
import 'package:todoo_app/widgets/tasks_card.dart';

/// Displays a list of all completed tasks in the Todoo app.

/// `CompletedTasksScreen` is a `ConsumerWidget` that builds the UI for the screen
/// showcasing completed tasks.
/// It utilizes Riverpod's `watch` to access the state of all tasks from the
/// `allTasksProvider`.
/// The screen dynamically adapts its content based on the presence of completed tasks:
///   - If there are no completed tasks, or all tasks are completed,
///     a placeholder with a "Done" image is displayed.
///   - If there are some uncompleted tasks in the list, the screen displays a
///     `ListView` containing `TodooTaskCard` widgets.
///     - These `TodooTaskCard` widgets represent only the completed tasks,
///       filtered using `where` based on the `isCompleted` property.
/// The screen is structured using a `Scaffold` with an `AppBar` titled "Completed"
/// and the body content area.
class CompletedTasksScreen extends ConsumerWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListWatcher = ref.watch(allTasksProvider);
    final isAtleastOneComplete =
        taskListWatcher.any((task) => task.isCompleted == true);

    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Image.asset('assets/illustrations/Done.png'),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
    if (taskListWatcher.isNotEmpty && isAtleastOneComplete) {
      content = Padding(
        padding: kScaffoldBodyPadding,
        child: ListView(
          children: [
            ...taskListWatcher.where((task) {
              return task.isCompleted;
            }).map(
              (todooTask) => TodooTaskCard(currentTask: todooTask),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed'),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
