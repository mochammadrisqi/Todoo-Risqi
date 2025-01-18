import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/pixelarticons.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:todoo_app/constants.dart';
import 'package:todoo_app/enums.dart';
import 'package:todoo_app/models/tasks_model.dart';
import 'package:todoo_app/providers/bottom_nav_bar_provider.dart';
import 'package:todoo_app/providers/tasks_provider.dart';
import 'package:todoo_app/utilities/util.dart';
import 'package:todoo_app/widgets/tasks_alert_dialogue.dart';
import 'package:todoo_app/widgets/tasks_button.dart';
import 'package:todoo_app/widgets/tasks_confirmation_dialogue.dart';
import 'package:todoo_app/widgets/tasks_text_field.dart';

class AddTasksScreen extends ConsumerStatefulWidget {
  const AddTasksScreen({super.key});

  @override
  ConsumerState<AddTasksScreen> createState() => _AddTasksPageState();
}

class _AddTasksPageState extends ConsumerState<AddTasksScreen> {
  ///Variables used to hold the inputs selected by the user.
  final _titleTextController = TextEditingController();
  String _titleTracker = '';
  final _descriptionTextController = TextEditingController();
  String _descriptionTracker = '';
  DateTime? _selectedDate;
  final _dateInputController = TextEditingController();
  DateTime? _selectedTime;
  final _timeInputController = TextEditingController();
  bool isPriorityFirstTap = true;
  Priority _selectedPriority = Priority.none;
  bool isCategoryFirstTap = true;
  Category _selectedCategory = Category.none;
  bool isLocationFirstTap = true;
  String _selectedLocation = '';
  final _locationController = TextEditingController();
  bool _isReminderSet = false;

  ///Variables used to handle app functionality.
  bool _isInitialized = false;
  final _todayDate = DateTime.now();
  final FocusNode _titleFieldFocusNode = FocusNode();
  final FocusNode _descriptionFieldFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  /// Prepares for a button tap by unfocusing text fields.
  ///
  /// This function removes focus from the title and description text fields,
  /// typically called before showing a dialog or performing other actions
  /// that might interfere with keyboard input.
  ///
  /// Unfocuses the title text field.
  ///
  /// Unfocuses the description text field.
  void _prepareButtonTap() {
    _titleFieldFocusNode.unfocus();
    _descriptionFieldFocusNode.unfocus();
  }

  /// Toggles the reminder status.
  ///
  /// This function changes the state of the reminder (_isReminderSet).
  /// It's used to indicate whether a reminder is set or not.
  ///
  /// Updates the reminder status by toggling its current value.
  void _toggleReminder() {
    setState(() {
      _isReminderSet = !_isReminderSet;
    });
  }

  /// Opens a date picker for the user to select a due date.
  ///
  /// This function displays a date picker dialog using `showDatePicker`. It allows the user
  /// to choose a date within a range of 20 years from the current date.
  ///
  /// - If a date is selected:
  ///   - Updates the internal state with the chosen date (`_selectedDate`).
  ///   - Formats the selected date and sets the text of the date input controller (`_dateInputController`).
  /// - If the user cancels the date picker:
  ///   - If the date input controller is empty, sets its text to "No Date Picked".
  ///
  /// Shows a date picker dialog with a 20-year range starting from today.
  ///
  /// Handles the user's selection:
  /// - Updates state and sets the date input controller text if a date is picked.
  /// - Sets the date input controller text to "No Date Picked" if canceled and empty.
  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: _todayDate,
      lastDate:
          DateTime(_todayDate.year + 20, _todayDate.month, _todayDate.day),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateInputController.text = Utils.formatDate(pickedDate);
      });
    } else {
      if (_dateInputController.text.isEmpty) {
        _dateInputController.text = "No Date Picked";
      }
    }
  }

  /// Opens a time picker for the user to select the task time.
  ///
  /// This function displays a time picker dialog using `showTimePicker`. The initial time
  /// is set to the current date and time.
  ///
  /// - If a time is selected:
  ///   - Updates the internal state with the chosen time by creating a `DateTime` object
  ///     combining the selected time with today's date (`_todayDate`).
  ///   - Sets the reminder flag (`_isReminderSet`) to true as a time has been picked.
  ///   - Formats the selected time and sets the text of the time input controller (`_timeInputController`).
  /// - If the user cancels the time picker:
  ///   - Clears the `_selectedTime` state.
  ///   - Sets the text of the time input controller to "No Time Picked".
  ///   - Sets the reminder flag (`_isReminderSet`) to false as no time is selected.
  ///
  /// Shows a time picker dialog with the current date and time as the initial selection.
  ///
  /// Handles the user's selection:
  /// - Updates state, reminder flag, and sets the time input controller text if a time is picked.
  /// - Clears state, reminder flag, and sets the time input controller text to "No Time Picked" if canceled.
  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_todayDate),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = DateTime(
          _todayDate.year,
          _todayDate.month,
          _todayDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _isReminderSet = true;
      });
      _timeInputController.text = Utils.formatTime(_selectedTime!);
    } else {
      _selectedTime = null;

      _timeInputController.text = 'No Time Picked';
      setState(() {
        _isReminderSet = false;
      });
    }
  }

  /// Sets the task's priority.
  ///
  /// This function updates the selected priority (`_selectedPriority`) based on the
  /// priority chosen by the user.
  ///
  /// Updates the selected priority in the state.
  void _pickPriority(Priority pickedPriority) {
    setState(() {
      _selectedPriority = pickedPriority;
    });
  }

  /// Sets the task's category.
  ///
  /// This function updates the selected category (`_selectedCategory`) based on the
  /// category chosen by the user.
  ///
  /// Updates the selected category in the state.
  void _pickCategory(Category pickedCategory) {
    setState(() {
      _selectedCategory = pickedCategory;
    });
  }

  /// Saves the entered location.
  ///
  /// This function updates the selected location (`_selectedLocation`) with the
  /// trimmed text from the location input controller (`_locationController`). Trimming
  /// removes any leading or trailing whitespace.
  ///
  /// Updates the selected location with the trimmed text from the location input.
  void _pickLocation() {
    setState(() {
      _selectedLocation = _locationController.text.trim();
    });
  }

  /// Builds and returns validation error messages.
  ///
  /// This function checks for validation errors in the input fields (title, date, and time)
  /// and returns a Text widget displaying the appropriate error message if any validation fails.
  /// If all validations pass, it returns an empty Container.
  ///
  /// Validation checks include:
  /// - Title is empty.
  /// - Date is not selected.
  /// - Selected date and time are in the past.
  ///
  /// Checks for title emptiness and returns an error message if the title is empty.
  ///
  /// Checks if a date is selected and returns an error message if no date is selected.
  ///
  /// Checks if the selected date and time are in the past and returns an error message if they are.
  ///
  /// Returns an empty Container if all validations pass.
  Widget _buildValidatorErrorMessages() {
    if (_titleTextController.text.isEmpty) {
      return Text(
        'Title is empty! Task must have a title.',
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Theme.of(context).colorScheme.error),
      );
    } else if (_selectedDate == null) {
      return Text(
        'Date is not selected! Task must have a date.',
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.left,
      );
    } else if (_selectedDate!.isBefore(_todayDate) &&
        _selectedTime!.isBefore(_todayDate)) {
      return Text(
        'Time can\'t be in the past',
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.left,
      );
    }
    return Container();
  }

  /// Prepares input fields for saving by trimming whitespace.
  ///
  /// This function removes leading and trailing whitespace from the text in the title,
  /// description, and location input controllers. This ensures that saved data doesn't
  /// contain unnecessary whitespace.
  ///
  /// Trims whitespace from the title input.
  ///
  /// Trims whitespace from the description input.
  ///
  /// Trims whitespace from the location input.
  void _prepareInputsForSave() {
    _titleTextController.text = _titleTextController.text.trim();
    _descriptionTextController.text = _descriptionTextController.text.trim();
    _locationController.text = _locationController.text.trim();
  }

  /// Handles the user's tap on the "Cancel" button.
  ///
  /// This function performs several actions upon cancellation:
  /// - Removes focus from any active text field using `FocusScope.of(context).unfocus()`.
  /// - Retrieves the editing state using `currentEditingTaskProvider`.
  /// - If a task was being edited (indicated by a value from `isEditing`):
  ///   - Resets the editing state by calling `isEditingCurrently(false, 'Editing Canceled')`
  ///     on the provider's notifier. This sets the editing flag to false and
  ///     taskID to ("Editing Canceled").
  /// - Navigates the user back to the "All Tasks" view using `navBarWatcher.onNavBarItemTap(1)`.
  ///   Index 1 is  represents the "All Tasks" view in the bottom navigation bar.
  ///
  /// Removes focus from any active text field.
  ///
  /// Checks if a task was being edited.
  ///
  /// If editing:
  ///   - Resets the editing state using the provider's notifier.
  ///   - Navigates to the "All Tasks" view.
  /// Else (If Adding a new task)
  ///   - Simply navigate to "All Tasks" view by disposing the current
  ///     variables and controllers.
  void _onCancelTap() {
    final navBarWatcher = ref.read(bottomNavigationBarProvider.notifier);
    FocusScope.of(context).unfocus();
    final isEditing = ref.watch(currentEditingTaskProvider).keys.first;
    if (isEditing) {
      final currentlyEditingTaskHandler =
          ref.watch(currentEditingTaskProvider.notifier);
      currentlyEditingTaskHandler.isEditingCurrently(false, 'Editing Canceled');
    }
    navBarWatcher.onNavBarItemTap(1);
  }

  /// This function orchestrates the process of deleting a task. It retrieves
  /// necessary dependencies using Riverpod providers, identifies the task to
  /// be deleted, and presents a confirmation dialog to the user. Upon confirmation,
  /// the task is deleted, the dialog is dismissed, and the user is navigated
  /// to the "All Tasks" view (represented by index 1 in the bottom navigation bar).
  ///
  /// Retrieves necessary dependencies using Riverpod providers.
  ///
  /// Finds the task to be deleted based on the currently editing task ID.
  ///
  /// Shows a confirmation dialog to the user.
  ///
  /// Handles the user's choice in the confirmation dialog:
  /// - If the user cancels, the dialog is closed.
  /// - If the user confirms:
  ///   - The task is deleted.
  ///   - The dialog is closed.
  ///   - The user is navigated to the "All Tasks" view.
  void _onDeleteTap() {
    final taskListWatcher = ref.watch(allTasksProvider);
    final taskHandler = ref.read(allTasksProvider.notifier);
    final navBarStateHandler = ref.read(bottomNavigationBarProvider.notifier);
    final currentlyEditingTaskWatcher = ref.watch(currentEditingTaskProvider);
    final editingTask = taskListWatcher.firstWhere((task) {
      return task.id == currentlyEditingTaskWatcher.values.first;
    });

    showDialog(
        context: context,
        builder: (context) {
          return TodooConfirmationDialogue(
            confirmationDialogueTitle: 'Confirm Deletion',
            confirmationDialogueBodyText:
                'Are you sure you want to delete this task permanently?',
            onCancelTap: () {
              Navigator.of(context).pop();
            },
            onConfirmTap: () {
              taskHandler.deleteTask(editingTask);
              Navigator.of(context).pop();
              navBarStateHandler.onNavBarItemTap(1);
            },
            confirmButtonText: 'Delete',
          );
        });
  }

  /// Handles the user's tap on the "Save" button.
  ///
  /// This function processes user input and saves a new or edited task. It retrieves
  /// necessary dependencies using Riverpod providers:
  /// - `allTasksProvider`: Provides access to the list of all tasks.
  /// - `allTasksProvider.notifier`: Provides methods for task manipulation (e.g., add, edit).
  /// - `bottomNavigationBarProvider.notifier`: Manages the bottom navigation bar state.
  /// - `currentEditingTaskProvider`: Provides access to the ID of the currently editing task (if any).
  /// - `currentEditingTaskProvider.notifier`:  Provides methods for managing the editing state.
  ///
  /// - Prepares input fields for saving by trimming whitespace using `_prepareInputsForSave`.
  /// - Checks if a task is being edited (`isEditing`).
  ///   - If editing:
  ///     - Shows a confirmation dialog to the user for verification before saving changes.
  ///     - Handles the user's choice in the confirmation dialog:
  ///       - If canceled (user taps "Cancel"), closes the dialog and does nothing.
  ///       - If confirmed (user taps "Confirm Edits"):
  ///         - Finds the task to be edited based on the currently editing task ID.
  ///         - Edits the task using `editTask` on the task handler, providing a new `TodooTask` object.
  ///         - Resets the editing state using `isEditingCurrently(false, 'Editing Complete')` on the notifier.
  ///         - Navigates the user back to the "All Tasks" view.
  ///   - If not editing (adding a new task):
  ///     - Adds the new task using `addTask` on the task handler.
  ///     - Navigates the user back to the "All Tasks" view (assumed to be represented by index 1 in the bottom navigation bar).
  void _onSaveTap(TodooTask newTask, bool isEditing) async {
    final taskListWatcher = ref.watch(allTasksProvider);
    final taskHandler = ref.read(allTasksProvider.notifier);
    final navBarStateHandler = ref.read(bottomNavigationBarProvider.notifier);
    final currentlyEditingTaskWatcher = ref.watch(currentEditingTaskProvider);
    final currentlyEditingTaskHandler =
        ref.read(currentEditingTaskProvider.notifier);

    _prepareInputsForSave;
    if (isEditing) {
      bool confirmEdits = await showDialog(
          context: context,
          builder: (context) {
            return TodooConfirmationDialogue(
              confirmationDialogueTitle: 'Confirm Edits',
              confirmationDialogueBodyText:
                  'Are you sure you want to confirm changes?',
              onCancelTap: () {
                Navigator.pop(context, false);
              },
              onConfirmTap: () {
                Navigator.pop(context, true);
                navBarStateHandler.onNavBarItemTap(1);
              },
              confirmButtonText: 'Confirm Edits',
            );
          });
      if (confirmEdits) {
        final editingTask = taskListWatcher.firstWhere((task) {
          return task.id == currentlyEditingTaskWatcher.values.first;
        });
        taskHandler.editTask(
          TodooTask.withID(
            id: editingTask.id,
            title: _titleTextController.text,
            description: _descriptionTextController.text,
            deadlineDate: _selectedDate!,
            deadlineTime: _selectedTime,
            category: _selectedCategory,
            priority: _selectedPriority,
            location: _selectedLocation,
            isReminderActive: _isReminderSet,
          ),
        );
        currentlyEditingTaskHandler.isEditingCurrently(
          false,
          'Editing Complete',
        );
      }
    } else {
      taskHandler.addTask(newTask);
      navBarStateHandler.onNavBarItemTap(1);
    }
  }

  /// Handles changes in dependencies for this widget.
  ///
  /// This method is called by Flutter whenever the widget's dependencies change.
  /// It checks if the widget has been initialized (`_isInitialized`). If not, it retrieves
  /// references to the task list and currently editing task providers using Riverpod.
  ///
  /// If a task is being edited (`currentlyEditingTaskWatcher.keys.first` is true):
  ///   - Finds the task to be edited based on the currently editing task ID.
  ///   - Populates the UI fields with the retrieved task data:
  ///     - Title, description, deadline date/time, priority, category, location, and reminder status.
  ///   - Sets the `_isInitialized` flag to true to prevent further initialization on subsequent calls.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final taskListWatcher = ref.watch(allTasksProvider);
      final currentlyEditingTaskWatcher = ref.watch(currentEditingTaskProvider);

      if (currentlyEditingTaskWatcher.keys.first == true) {
        final editingTask = taskListWatcher.firstWhere((task) {
          return task.id == currentlyEditingTaskWatcher.values.first;
        });

        _titleTextController.text = editingTask.title;
        _descriptionTextController.text = editingTask.description ?? '';
        _selectedDate = editingTask.deadlineDate;
        _dateInputController.text = Utils.formatDate(_selectedDate!);
        _selectedTime = editingTask.deadlineTime;
        _timeInputController.text = Utils.formatTime(_selectedTime);
        _selectedPriority = editingTask.priority ?? Priority.none;
        _selectedCategory = editingTask.category ?? Category.none;
        _selectedLocation = editingTask.location ?? '';
        _locationController.text = _selectedLocation;
        _isReminderSet = editingTask.isReminderActive ?? false;
        _isInitialized = true;
      }
    }
  }

  /// Disposes of resources used by this widget.
  ///
  /// This method is called when the widget is removed from the widget tree. It's
  /// crucial to dispose of any resources that the widget holds, such as text editing
  /// controllers, focus nodes, and other controllers, to prevent memory leaks.
  ///
  /// Disposes of text field controllers to release associated resources.
  ///
  /// Disposes of focus nodes to prevent memory leaks and release listeners.
  ///
  /// Disposes of UI/UX controllers, such as the scroll controller.
  ///
  /// Calls the superclass's dispose method to ensure proper cleanup.
  @override
  void dispose() {
    ///Dispose TextField controllers.
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _dateInputController.dispose();
    _timeInputController.dispose();
    _locationController.dispose();

    ///Dispose FocusNodes.
    _titleFieldFocusNode.dispose();
    _descriptionFieldFocusNode.dispose();

    ///Dispose UI/UX Controllers
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentlyEditingTaskWatcher = ref.watch(currentEditingTaskProvider);
    return GestureDetector(
      onTap: () {
        _prepareButtonTap();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            currentlyEditingTaskWatcher.keys.first
                ? 'Editing Task'
                : 'Add Task',
          ),
          centerTitle: true,
          actions: [
            /// Conditionally displays a delete button if a task is being edited.
            ///
            /// If a task is being edited:
            ///   - Creates a delete button.
            ///   - On button tap:
            ///     - Calls `_prepareButtonTap()` to unfocus any active text fields.
            ///     - Calls `_onDeleteTap()` to handle the task deletion process.
            if (currentlyEditingTaskWatcher.keys.first) ...[
              TodooButton(
                onButtonTap: () {
                  _prepareButtonTap();
                  _onDeleteTap();
                },
                icon: Ic.delete,
              ),
            ],

            /// A button that toggles the reminder.
            ///
            /// Sets the icon based on reminder status.
            /// Sets button margins.
            /// Unfocuses fields on tap.
            /// Shows error dialog if no time set.
            /// Toggles reminder status if time is set.
            TodooButton(
              icon: _isReminderSet
                  ? Ic.notifications_active
                  : MaterialSymbols.notifications_active_outline_rounded,
              margin: kTodooButtonMargin.copyWith(left: 10, right: 10),
              onButtonTap: () {
                _prepareButtonTap();
                if (_selectedTime == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return TodooAlertDialogue(
                          title: 'Reminder Error!',
                          contentItems: [
                            Text(
                              'Time is empty! Can\'t set reminder without setting time!',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          ],
                        );
                      });
                } else {
                  _toggleReminder();
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: kScaffoldBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// A text field for entering the task title.
                ///
                /// Sets the field's title label and associates the focus node.
                /// Configures text capitalization to capitalize each word.
                /// Updates the `_titleTracker` string on every text change for icon updates.
                /// Provides a reset action icon to clear the text field.
                /// Handles the reset action: unfocuses fields, resets tracker and controller.
                /// Sets the maximum character limit, displays dynamic icon based on input,
                /// and uses the provided controller.
                TodooTextField(
                  textFieldTitle: 'Title:',
                  focusNode: _titleFieldFocusNode,
                  textFieldCapitalization: TextCapitalization.words,
                  onTextChanged: (newValue) {
                    setState(() {
                      _titleTracker = newValue;
                    });
                  },
                  textFieldActionIcon: Bx.reset,
                  onActionIconTap: () {
                    setState(() {
                      _prepareButtonTap();
                      _titleTracker = '';
                      _titleTextController.text = '';
                    });
                  },
                  textFieldMaxLength: 50,
                  textFieldIcon: Iconify(
                    _titleTracker.isNotEmpty
                        ? Ri.quill_pen_fill
                        : Ri.quill_pen_line,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textFieldController: _titleTextController,
                ),

                /// A text field for entering the task description.
                /// Sets the field's title label and associates the focus node.
                /// Configures text capitalization for sentences.
                /// Uses the provided text editing controller.
                /// Updates the `_descriptionTracker` on every text change for icon updates.
                /// Provides a reset action icon to clear the text field.
                /// Handles the reset action: unfocuses fields, resets tracker and controller.
                /// Sets maximum character limit to 150 and allows up to 3 lines.
                /// Configures keyboard for multiline input and newline action.
                /// Displays dynamic icon based on input using `_descriptionTracker`.
                TodooTextField(
                  textFieldTitle: 'Description:',
                  focusNode: _descriptionFieldFocusNode,
                  textFieldCapitalization: TextCapitalization.sentences,
                  textFieldController: _descriptionTextController,
                  onTextChanged: (newValue) {
                    setState(() {
                      _descriptionTracker = newValue;
                    });
                  },
                  textFieldActionIcon: Bx.reset,
                  onActionIconTap: () {
                    setState(() {
                      _prepareButtonTap();
                      _descriptionTracker = '';
                      _descriptionTextController.text = '';
                    });
                  },
                  textFieldMaxLength: 150,
                  textFieldMaxLines: 3,
                  textFieldKeyboardType: TextInputType.multiline,
                  textFieldKeyboardInputAction: TextInputAction.newline,
                  textFieldIcon: Iconify(
                    _descriptionTracker.isNotEmpty
                        ? Ic.round_article
                        : Ic.outline_article,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    /// A custom read-only field for date selection.

                    /// Expands the text field to fill available space.
                    /// Sets the field to read-only and marks it as an input picker.
                    /// Calls `_pickDate` on tap to open the date picker.
                    /// Uses the provided text editing controller.
                    /// Provides a reset icon to clear the selected date.
                    /// Handles the reset action: clears the selected date and updates the text field.
                    /// Displays dynamic icon based on whether a date is selected.
                    Expanded(
                      child: TodooTextField(
                        isReadOnly: true,
                        isInputPicker: true,
                        onTextFieldTap: _pickDate,
                        textFieldController: _dateInputController,
                        onTextChanged: (newValue) {},
                        textFieldTitle: 'Pick Date:',
                        textFieldActionIcon: Bx.reset,
                        onActionIconTap: () {
                          if (_selectedDate != null) {
                            setState(() {
                              _selectedDate = null;
                              _dateInputController.text = 'Date Cleared';
                            });
                          }
                        },
                        textFieldIcon: Iconify(
                          _selectedDate != null
                              ? Ph.calendar_fill
                              : Pixelarticons.calendar_plus,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    /// A custom read-only field for time selection.
                    ///
                    /// Expands the text field to fill available space.
                    /// Sets the field to read-only and marks it as an input picker.
                    /// Calls `_pickTime` on tap to open the time picker.
                    /// Uses the provided text editing controller.
                    /// Provides a reset icon to clear the selected time.
                    /// Handles the reset action: clears the selected time and updates the text field.
                    /// Displays dynamic icon based on whether a time is selected.
                    Expanded(
                      child: TodooTextField(
                        isReadOnly: true,
                        isInputPicker: true,
                        onTextFieldTap: _pickTime,
                        textFieldController: _timeInputController,
                        onTextChanged: (newValue) {},
                        textFieldTitle: 'Pick Time:',
                        textFieldActionIcon: Bx.reset,
                        onActionIconTap: () {
                          if (_selectedTime != null) {
                            setState(() {
                              _selectedTime = null;
                              _timeInputController.text = 'Time Cleared';
                            });
                          }
                        },
                        textFieldIcon: Iconify(
                          _selectedTime != null
                              ? Mdi.clock
                              : Mdi.clock_plus_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Choose Options:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: [
                      /// A button to select the task priority.
                      ///
                      /// Handles the button tap: unfocuses fields, updates state, shows priority selection dialog.
                      /// Builds the priority selection dialog:
                      ///   - Iterates through priority options (excluding 'none').
                      ///   - Creates a button for each priority with icon, color, and label.
                      ///   - Calls `_pickPriority` and closes the dialog on priority selection.
                      /// Sets button padding.
                      /// Sets button height.
                      /// Sets dynamic icon and text based on selected priority and initial state.
                      TodooButton(
                        onButtonTap: () {
                          _prepareButtonTap();
                          setState(() {
                            isPriorityFirstTap = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => TodooAlertDialogue(
                              title: 'Select Task Priority:',
                              contentItems: priorityIconMap.entries
                                  .where((entry) => entry.key != Priority.none)
                                  .map((entry) {
                                return Center(
                                  child: SizedBox(
                                    width: 200,
                                    child: TodooButton(
                                      onButtonTap: () {
                                        _pickPriority(entry.key);

                                        Navigator.of(context).pop();
                                      },
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.all(6),
                                      buttonHeight: 38,
                                      icon: priorityIconMap[entry.key]!
                                          .keys
                                          .first,
                                      iconColour: priorityIconMap[entry.key]!
                                          .values
                                          .first,
                                      buttonColour: priorityIconMap[entry.key]!
                                          .values
                                          .first
                                          .withOpacity(0.2),
                                      buttonText:
                                          Utils.getPriorityLabel(entry.key),
                                      textColour: priorityIconMap[entry.key]!
                                          .values
                                          .first,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                        padding:
                            kTodooButtonPadding.copyWith(left: 10, right: 10),
                        buttonHeight: 38,
                        icon: _selectedPriority == Priority.none &&
                                isPriorityFirstTap
                            ? MaterialSymbols.arrow_circle_up
                            : priorityIconMap[_selectedPriority]!.keys.first,
                        buttonText: _selectedPriority == Priority.none
                            ? 'Set Priority'
                            : Utils.getPriorityLabel(_selectedPriority),
                      ),

                      /// A button to select the task category.
                      ///
                      /// Handles the button tap: unfocuses fields, updates state, shows category selection dialog.
                      /// Builds the category selection dialog:
                      ///   - Iterates through category options (excluding 'none').
                      ///   - Creates a button for each category with icon, color, and label.
                      ///   - Calls `_pickCategory` and closes the dialog on selection.
                      /// Sets button padding.
                      /// Sets button height.
                      /// Sets dynamic icon and text based on selected category and initial state.
                      TodooButton(
                        onButtonTap: () {
                          _prepareButtonTap();
                          setState(() {
                            isCategoryFirstTap = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return TodooAlertDialogue(
                                  title: 'Choose Category:',
                                  contentItems: categoryIconMap.entries
                                      .where(
                                          (entry) => entry.key != Category.none)
                                      .map((entry) {
                                    return Center(
                                      child: SizedBox(
                                        width: 200,
                                        child: TodooButton(
                                          onButtonTap: () {
                                            _pickCategory(entry.key);
                                            Navigator.of(context).pop();
                                          },
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.all(4),
                                          buttonHeight: 38,
                                          icon: categoryIconMap[entry.key]!
                                              .keys
                                              .first,
                                          iconColour:
                                              categoryIconMap[entry.key]!
                                                  .values
                                                  .first,
                                          buttonColour:
                                              categoryIconMap[entry.key]!
                                                  .values
                                                  .first
                                                  .withOpacity(0.2),
                                          buttonText:
                                              Utils.getCategoryLabel(entry.key),
                                          textColour:
                                              categoryIconMap[entry.key]!
                                                  .values
                                                  .first,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              });
                        },
                        padding:
                            kTodooButtonPadding.copyWith(left: 10, right: 10),
                        buttonHeight: 38,
                        icon: _selectedCategory == Category.none &&
                                isCategoryFirstTap
                            ? Ic.round_category
                            : categoryIconMap[_selectedCategory]!.keys.first,
                        buttonText: _selectedCategory == Category.none
                            ? 'Set Category'
                            : Utils.getCategoryLabel(_selectedCategory),
                      ),

                      /// A button to set the task location.

                      /// Handles the button tap: unfocuses fields, updates state, shows location selection dialog.
                      /// Builds the location selection dialog:
                      ///   - Uses StatefulBuilder for local state management within the dialog.
                      ///   - Contains a text field for location input, updating `_selectedLocation` on text change.
                      ///   - Displays a "Coming Soon" message about map integration.
                      ///   - Provides "Clear" and "Confirm" buttons.
                      ///   - "Clear" button resets location and closes the dialog.
                      ///   - "Confirm" button calls `_pickLocation` and closes the dialog.
                      /// Sets button padding.
                      /// Sets button height.
                      /// Sets dynamic icon and text based on initial state and location input.
                      TodooButton(
                        onButtonTap: () {
                          _prepareButtonTap();
                          setState(() {
                            isLocationFirstTap = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return TodooAlertDialogue(
                                    title: 'Choose Location:',
                                    contentItems: [
                                      TodooTextField(
                                        textFieldCapitalization:
                                            TextCapitalization.characters,
                                        textFieldController:
                                            _locationController,
                                        textFieldMaxLength: 15,
                                        onTextChanged: (newValue) {
                                          setState(() {
                                            _selectedLocation = newValue;
                                          });
                                        },
                                        textFieldIcon: Iconify(
                                          _selectedLocation.isNotEmpty
                                              ? Ic.round_location_on
                                              : MaterialSymbols
                                                  .location_on_outline,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'Coming Soon: You can pick location coordinates from map!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(fontSize: 10),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TodooButton(
                                            onButtonTap: () {
                                              setState(() {
                                                _selectedLocation = '';
                                                _locationController.text = '';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            buttonHeight: 38,
                                            buttonText: 'Clear',
                                            buttonColour: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.06),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          TodooButton(
                                            onButtonTap: () {
                                              _pickLocation();
                                              Navigator.of(context).pop();
                                            },
                                            buttonHeight: 38,
                                            buttonWidth: 80,
                                            buttonText: 'Confirm',
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                              });
                        },
                        padding:
                            kTodooButtonPadding.copyWith(left: 10, right: 10),
                        buttonHeight: 38,
                        icon: isLocationFirstTap
                            ? Ic.round_location_on
                            : _locationController.text.isEmpty
                                ? Uil.location_pin_alt
                                : Ic.round_location_on,
                        buttonText: _locationController.text == ''
                            ? 'Set Location'
                            : 'Location Set',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// A button to cancel the task creation/editing process.
                    ///
                    /// Handles the button tap:
                    ///   - Calls `_prepareButtonTap()` to unfocus any active text fields, dismissing the keyboard.
                    ///   - Calls `_onCancelTap()` to handle the cancellation logic, which may include:
                    ///     - Resetting the task creation/editing state.
                    ///     - Navigating the user back to the previous screen.
                    TodooButton(
                      onButtonTap: () {
                        _prepareButtonTap();
                        _onCancelTap();
                      },
                      padding:
                          kTodooButtonPadding.copyWith(left: 10, right: 10),
                      margin: EdgeInsets.zero,
                      buttonHeight: 38,
                      icon: Ic.cancel,
                      buttonText: 'Cancel',
                      buttonColour: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.06),
                    ),
                    const SizedBox(
                      width: 6,
                    ),

                    /// A button to save the task or save edits.
                    ///
                    /// Handles the button tap:
                    ///   - Calls `_prepareButtonTap()` to unfocus any active text fields.
                    ///   - Validates user input: checks if title is not empty, date is selected,
                    ///     and time is not in the past.
                    ///   - If input is valid:
                    ///     - Calls `_prepareInputsForSave()` to trim input strings.
                    ///     - Creates a `TodooTask` object with the input data.
                    ///     - Calls `_onSaveTap()` to save the new or edited task.
                    ///   - If input is invalid: shows a dialog with error messages from
                    ///     `_buildValidatorErrorMessages()`.
                    TodooButton(
                      onButtonTap: () {
                        _prepareButtonTap();
                        if (_titleTextController.text.isNotEmpty &&
                            _selectedDate != null &&
                            (_selectedTime == null ||
                                _selectedDate!.isAfter(_todayDate) ||
                                _selectedTime!.isAfter(_todayDate))) {
                          _prepareInputsForSave();
                          _onSaveTap(
                            TodooTask(
                              title: _titleTextController.text,
                              description: _descriptionTextController.text,
                              deadlineDate: _selectedDate!,
                              deadlineTime: _selectedTime,
                              category: _selectedCategory,
                              priority: _selectedPriority,
                              location: _selectedLocation,
                              isReminderActive: _isReminderSet,
                            ),
                            currentlyEditingTaskWatcher.keys.first,
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return TodooAlertDialogue(
                                  title: 'Check Your Inputs',
                                  contentItems: [
                                    _buildValidatorErrorMessages(),
                                  ],
                                );
                              });
                        }
                      },
                      padding:
                          kTodooButtonPadding.copyWith(left: 10, right: 10),
                      margin: EdgeInsets.zero,
                      buttonHeight: 38,
                      icon: Ic.save,
                      buttonText: currentlyEditingTaskWatcher.keys.first
                          ? 'Save Edits'
                          : 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
