import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/pepicons.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:todoo_app/enums.dart';
import 'package:uuid/uuid.dart';

/// Maps a `Category` enum to a map containing the corresponding icon and its color.
/// Used for dynamic icon & colour assignment based on task category.
Map<Category, Map<String, Color>> categoryIconMap = {
  Category.none: {Ic.outline_category: Colors.grey},
  Category.personal: {MaterialSymbols.person: Colors.pink.withOpacity(0.8)},
  Category.work: {MaterialSymbols.work: Colors.blue.withOpacity(0.8)},
  Category.shopping: {
    MaterialSymbols.shopping_cart_rounded: Colors.teal.withOpacity(0.8)
  },
  Category.focus: {Ri.focus_2_fill: Colors.purple.withOpacity(0.8)},
  Category.social: {Ion.md_people: Colors.lightGreen.withOpacity(0.8)},
  Category.recreation: {
    Ic.twotone_nature_people: Colors.deepPurple.withOpacity(0.8)
  }
};

/// Maps a `Priority` enum to a map containing the corresponding icon and its color.
/// Used for dynamic icon and colour assignment based on task priority.
Map<Priority, Map<String, Color>> priorityIconMap = {
  Priority.none: {Ic.outline_arrow_circle_up: Colors.grey},
  Priority.high: {Pepicons.exclamation_filled: Colors.red},
  Priority.medium: {IconParkOutline.menu_fold_one: Colors.orange},
  Priority.low: {Ic.round_low_priority: Colors.lightGreen},
};

/// A model class representing a task within the Todoo application.
///
/// This class encapsulates all relevant data for a task, including its:
///   - Unique identifier (`id`)
///   - Mandatory title (`title`)
///   - Optional description (`description`)
///   - Mandatory deadline date (`deadlineDate`)
///   - Optional deadline time (`deadlineTime`)
///   - Optional priority (`priority`)
///   - Optional category (`category`)
///   - Optional location (`location`)
///   - Flag indicating if a reminder is set (`isReminderActive`)
///   - Completion status (`isCompleted`)
///
/// The class provides constructors for creating new tasks with or without an existing ID,
/// as well as methods for converting a task object to a map suitable for storage
/// (e.g., in a database) and vice versa.
///
/// This structured representation facilitates efficient task management within
/// the application.
class TodooTask {
  TodooTask({
    required this.title,
    this.description,
    required this.deadlineDate,
    this.deadlineTime,
    this.category,
    this.priority,
    this.location,
    this.isReminderActive,
    this.isCompleted = false,
  }) : id = const Uuid().v4();

  TodooTask.withID({
    required this.id,
    required this.title,
    this.description,
    required this.deadlineDate,
    this.deadlineTime,
    this.category,
    this.priority,
    this.location,
    this.isReminderActive,
    this.isCompleted = false,
  });

  String id;
  String title;
  String? description;
  DateTime deadlineDate;
  DateTime? deadlineTime;
  Priority? priority;
  Category? category;
  String? location;
  bool? isReminderActive;
  bool isCompleted;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadlineDate': deadlineDate.toIso8601String(),
      'deadlineTime': deadlineTime?.toIso8601String(),
      'priority': priority?.toString().split('.').last,
      'category': category?.toString().split('.').last,
      'location': location,
      'isReminderActive': isReminderActive == true ? 1 : 0,
      'isCompleted': isCompleted == true ? 1 : 0,
    };
  }

  static TodooTask fromMap(Map<String, dynamic> map) {
    return TodooTask.withID(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      deadlineDate: DateTime.parse(map['deadlineDate']),
      deadlineTime: map['deadlineTime'] != null
          ? DateTime.parse(map['deadlineTime'])
          : null,
      priority: map['priority'] != null
          ? Priority.values.firstWhere(
              (e) => e.toString().split('.').last == map['priority'])
          : null,
      category: map['category'] != null
          ? Category.values.firstWhere(
              (e) => e.toString().split('.').last == map['category'])
          : null,
      location: map['location'],
      isReminderActive: map['isReminderActive'] == 1,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
