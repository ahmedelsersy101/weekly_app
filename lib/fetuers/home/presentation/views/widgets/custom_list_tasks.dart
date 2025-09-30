import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/utils/app_style.dart';
import 'package:weekly_dash_board/core/utils/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/data/models/task_model.dart' hide TaskPriority;
import 'package:weekly_dash_board/fetuers/home/data/models/category_model.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/enhanced_task_item.dart';

class CustomListTasks extends StatefulWidget {
  final int dayIndex;

  const CustomListTasks({super.key, required this.dayIndex});

  @override
  State<CustomListTasks> createState() => _CustomListTasksState();
}

class _CustomListTasksState extends State<CustomListTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is WeeklySuccess) {
          final tasks = context.read<WeeklyCubit>().getTasksForDay(widget.dayIndex);
          if (tasks.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context).tr('more.no_tasks_for_this_day'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          final tasksByCategory = <String, List<TaskModel>>{};
          for (final task in tasks) {
            if (!tasksByCategory.containsKey(task.categoryId)) {
              tasksByCategory[task.categoryId] = [];
            }
            tasksByCategory[task.categoryId]!.add(task);
          }

          final sortedCategories = tasksByCategory.keys.toList()
            ..sort((a, b) => getCategoryPriority(a).index.compareTo(getCategoryPriority(b).index));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...sortedCategories.map((categoryId) {
                final categoryTasks = tasksByCategory[categoryId]!;
                final category = TaskCategoryModel.getDefaultCategories().firstWhere(
                  (cat) => cat.id == categoryId,
                  orElse: () => TaskCategoryModel.getDefaultCategories().last,
                );
                final importantTasks = categoryTasks.where((t) => t.isImportant).toList();
                final regularTasks = categoryTasks.where((t) => !t.isImportant).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: category.color.withOpacity(0.3)),
                            ),
                            child: Icon(
                              IconData(category.iconCodePoint, fontFamily: category.iconFontFamily),
                              color: category.color,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.nameAr,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${categoryTasks.length}',
                              style: TextStyle(
                                color: category.color,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (importantTasks.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context).tr('settings.Important'),

                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...importantTasks.map(
                        (task) => EnhancedTaskItem(
                          task: task,
                          onEdit: () => _showEditTaskDialog(context, task),
                          onDelete: () => _deleteTask(context, task),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (regularTasks.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.list,
                              color: Theme.of(context).colorScheme.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context).tr('settings.AsRegular'),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...regularTasks.map(
                        (task) => EnhancedTaskItem(
                          task: task,
                          onEdit: () => _showEditTaskDialog(context, task),
                          onDelete: () => _deleteTask(context, task),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                  ],
                );
              }),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    final TextEditingController titleController = TextEditingController(text: task.title);
    final categories = TaskCategoryModel.getDefaultCategories();
    TaskCategoryModel selectedCategory = categories.first;
    bool isImportant = task.isImportant;
    TimeOfDay? reminderTime = task.reminderTime;
    String? selectedCategoryId = task.categoryId; // التصنيف الحالي

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// العنوان
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).tr('settings.enterTaskTitle'),
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      border: customOutlineInputBorder(),
                      enabledBorder: customOutlineInputBorder(),
                      focusedBorder: customOutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),

                  /// مهم
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      value: isImportant,
                      onChanged: (value) {
                        setState(() {
                          isImportant = value ?? false;
                        });
                      },
                      title: Text(
                        AppLocalizations.of(context).tr('settings.markAsImportant'),
                        style: AppStyles.styleSemiBold20(
                          context,
                        ).copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      activeColor: Theme.of(context).colorScheme.onPrimary,
                      checkColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
                      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// اختيار التصنيف
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: DropdownButton<TaskCategoryModel>(
                      value: selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: categories.map((category) {
                        return DropdownMenuItem<TaskCategoryModel>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                IconData(
                                  category.iconCodePoint,
                                  fontFamily: category.iconFontFamily,
                                ),
                                color: category.color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Localizations.localeOf(context).languageCode == 'ar'
                                    ? category.nameAr
                                    : category.name,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// وقت التذكير
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.notifications,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                AppLocalizations.of(context).tr('settings.reminderTime'),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.access_time,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
                                  );
                                  if (selectedTime != null) {
                                    setState(() => reminderTime = selectedTime);
                                  }
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32, bottom: 8),
                            child: Text(
                              reminderTime != null
                                  ? '${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}'
                                  : AppLocalizations.of(context).tr('settings.noReminder'),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// الأزرار
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          AppLocalizations.of(context).tr('settings.cancel'),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (titleController.text.trim().isNotEmpty) {
                            context.read<WeeklyCubit>().editTask(
                              task.id,
                              titleController.text.trim(),
                              isImportant: isImportant,
                              reminderTime: reminderTime,
                              categoryId: selectedCategoryId,
                            );

                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(AppLocalizations.of(context).tr('settings.save')),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  OutlineInputBorder customOutlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  void _deleteTask(BuildContext context, TaskModel task) {
    context.read<WeeklyCubit>().deleteTask(task.id);
  }
}
