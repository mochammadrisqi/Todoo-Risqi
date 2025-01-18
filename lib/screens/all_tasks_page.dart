import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:todoo_app/constants.dart';
import 'package:todoo_app/providers/tasks_provider.dart';
import 'package:todoo_app/screens/settings_screen.dart';
import 'package:todoo_app/widgets/tasks_button.dart';
import 'package:todoo_app/widgets/tasks_card.dart';

/// Displays a list of all tasks in the Todoo app.
///
/// `AllTasksScreen` is a `ConsumerWidget` that builds the UI for displaying all tasks.
/// It uses Riverpod to watch the `allTasksProvider` and dynamically updates the UI based on the task list.
/// If there are no tasks, a placeholder with an "Add" image is displayed.
/// If there are tasks, a `ListView` of `TodooTaskCard` widgets is shown, displaying only the uncompleted tasks.
/// An AppBar with a settings button is included, which navigates the user to the `SettingsScreen` on tap.
class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({super.key});

  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListWatcher = ref.watch(allTasksProvider);

    final isAtleastOneTodoo =
        taskListWatcher.any((task) => task.isCompleted == false);
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Image.asset('assets/illustrations/Add.png'),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );

    if (taskListWatcher.isNotEmpty && isAtleastOneTodoo) {
      content = Padding(
        padding: kScaffoldBodyPadding,
        child: ListView(
          children: [
            ...taskListWatcher.where((task) {
              return !task.isCompleted;
            }).map(
              (todooTask) => TodooTaskCard(currentTask: todooTask),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoo'),
        centerTitle: true,
        actions: [
          TodooButton(
            onButtonTap: () {
              _navigateToSettingsScreen(context);
            },
            icon: MaterialSymbols.settings,
            iconSize: 18,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(6),
          )
        ],
      ),
      body: content,
    );
  }
}
