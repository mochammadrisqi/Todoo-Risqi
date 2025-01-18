import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/models/tasks_model.dart';
import 'package:todoo_app/services/database_helper.dart';

/// Manages the state of all tasks and provides database access.

/// `AllTasksNotifier` manages a list of `TodooTask` objects, providing methods to:
///   - Load all tasks from the database.
///   - Add a new task to the database and update the state.
///   - Edit an existing task in the database and update the state.
///   - Delete a task from the database and update the state.

/// `databaseHelperProvider` provides a singleton instance
/// of the `DatabaseHelper` for database interaction.
class AllTasksNotifier extends StateNotifier<List<TodooTask>> {
  final DatabaseHelper _databaseHelper;

  AllTasksNotifier(this._databaseHelper) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    state = await _databaseHelper.getAllTasks();
  }

  void addTask(TodooTask newTask) async {
    final taskToAdd = TodooTask(
      title: newTask.title,
      description: newTask.description,
      deadlineDate: newTask.deadlineDate,
      deadlineTime: newTask.deadlineTime,
      category: newTask.category,
      priority: newTask.priority,
      location: newTask.location,
      isReminderActive: newTask.isReminderActive,
    );

    await _databaseHelper.insertTask(taskToAdd);

    state = [
      ...state,
      taskToAdd,
    ];
  }

  void editTask(TodooTask editedTask) async {
    await _databaseHelper.updateTask(editedTask);

    final index = state.indexWhere((task) => task.id == editedTask.id);

    if (index != -1) {
      state = state.where((task) => task.id != editedTask.id).toList()
        ..insert(index, editedTask);
    }
  }

  void deleteTask(TodooTask taskToDelete) async {
    await _databaseHelper.deleteTask(taskToDelete.id);
    final index = state.indexWhere((task) => task.id == taskToDelete.id);

    if (index != -1) {
      state = state.where((task) => task.id != taskToDelete.id).toList();
    }
  }
}

/// Provides a singleton instance of the `DatabaseHelper`.
///
/// `databaseHelperProvider` uses Riverpod's `Provider` to provide a single,
/// globally accessible instance of the `DatabaseHelper` class, facilitating
/// database interactions throughout the app specifically used in the `AllTasksNotifier`
/// mainly to load tasks while initial state loading occurs.
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.dbInstance;
});

/// Provides access to the state of all tasks and methods for managing them.
///
/// `allTasksProvider` utilizes Riverpod's `StateNotifierProvider` to:
///   - Manage the state of the list of `TodooTask` objects using `AllTasksNotifier`.
///   - Inject a singleton instance of the `DatabaseHelper` via `databaseHelperProvider`.
///   - Create and return an instance of `AllTasksNotifier`,
///     enabling access to methods for loading, adding, editing, and deleting tasks.
final allTasksProvider =
    StateNotifierProvider<AllTasksNotifier, List<TodooTask>>((ref) {
  final databaseHelper = ref.read(databaseHelperProvider);
  return AllTasksNotifier(databaseHelper);
});

/// Manages the state of the currently editing task.

/// `CurrentEditingTaskNotifier` uses a `Map<bool, String>` to track:
///   - Whether a task is currently being edited (`bool`).
///   - The ID of the task being edited (`String`), if applicable.
///
/// The initial state indicates that no task is being edited (`{false: 'Not Editing'}`).
///
/// The `isEditingCurrently` method updates the state with the provided
/// editing status and optional task ID.
class CurrentEditingTaskNotifier extends StateNotifier<Map<bool, String>> {
  CurrentEditingTaskNotifier() : super({false: 'Not Editing'});

  void isEditingCurrently(bool isEditing, String iD) {
    state = {isEditing: iD};
  }
}

/// Provides access to the current editing task's state.
///
/// `currentEditingTaskProvider` uses Riverpod's `StateNotifierProvider` to:
///   - Manage the editing state using `CurrentEditingTaskNotifier`.
///   - Provide access to the editing status (whether a task is being edited)
///     and the ID of the currently edited task (if any).
final currentEditingTaskProvider =
    StateNotifierProvider<CurrentEditingTaskNotifier, Map<bool, String>>((ref) {
  return CurrentEditingTaskNotifier();
});
