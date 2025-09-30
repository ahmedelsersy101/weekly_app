import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/utils/app_localizations.dart';
import 'package:weekly_dash_board/core/utils/app_style.dart';
import 'package:weekly_dash_board/core/theme/app_theme.dart';
import 'package:weekly_dash_board/fetuers/home/data/models/category_model.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_list_tasks.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class CustomCardHomeView extends StatelessWidget {
  final int dayIndex;

  const CustomCardHomeView({super.key, required this.dayIndex});

  bool _isCurrentDay(String date) {
    final now = DateTime.now();
    final currentDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
    return date == currentDate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is WeeklySuccess) {
          final dayStats = state.weeklyState.dayStats[dayIndex];
          return ExpandableDayCard(dayIndex: dayIndex, dayStats: dayStats);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ExpandableDayCard extends StatelessWidget {
  final int dayIndex;
  final dynamic dayStats;

  const ExpandableDayCard({super.key, required this.dayIndex, required this.dayStats});

  bool _isCurrentDay(String date) {
    final today = DateTime.now();

    try {
      final parts = date.split('/'); // ["27", "9"]
      if (parts.length == 2) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);

        return today.day == day && today.month == month;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: ExpansionTileCard(
        baseColor: Theme.of(context).colorScheme.surface,
        expandedColor: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        elevation: 2,

        leading: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _isCurrentDay(dayStats.date)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            dayStats.date,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: _isCurrentDay(dayStats.date)
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 16),
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context).tr(dayStats.dayName),
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 22),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${AppLocalizations.of(context).tr('common.done')} : ${dayStats.completedTasks} / ${dayStats.totalTasks}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        children: <Widget>[
          const Divider(thickness: 1.0, height: 1.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _DayContent(dayIndex: dayIndex),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonAddTasks(dayIndex: dayIndex),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => _confirmClearDay(context, dayIndex),
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _confirmClearDay(BuildContext context, int dayIndex) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          AppLocalizations.of(ctx).tr('settings.clearDayTasksTitle'),
          style: Theme.of(ctx).textTheme.displaySmall!.copyWith(
            color: Theme.of(ctx).colorScheme.onSurface,
            fontSize: AppTheme.getResponsiveFontSize(ctx, fontSize: 24),
          ),
        ),
        content: Text(
          AppLocalizations.of(ctx).tr('settings.clearDayTasksMessage'),
          style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppLocalizations.of(ctx).tr('settings.cancel'),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ctx.read<WeeklyCubit>().clearTasksForDay(dayIndex);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(AppLocalizations.of(ctx).tr('settings.clear')),
          ),
        ],
      );
    },
  );
}

class CustomButtonAddTasks extends StatelessWidget {
  final int dayIndex;

  const CustomButtonAddTasks({super.key, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => _showAddTaskDialog(context, dayIndex),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary, size: 24),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, int dayIndex) {
    final TextEditingController titleController = TextEditingController();
    bool isImportant = false;
    TimeOfDay? reminderTime;

    // جلب الكاتيجوريز
    final categories = TaskCategoryModel.getDefaultCategories();
    TaskCategoryModel selectedCategory = categories.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    Text(
                      AppLocalizations.of(context).tr('settings.addNewTask'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // إدخال العنوان
                    TextField(
                      controller: titleController,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).tr('settings.enterTaskTitle'),
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: customOutlineInputBorder(context),
                        enabledBorder: customOutlineInputBorder(context),
                        focusedBorder: customOutlineInputBorder(context),
                      ),
                      // autofocus: true,
                    ),
                    const SizedBox(height: 12),

                    // Checkbox أهمية المهمة
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CheckboxListTile(
                        value: isImportant,
                        onChanged: (value) {
                          setState(() => isImportant = value ?? false);
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
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dropdown اختيار الكاتيجوري
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

                    // التذكير
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
                              children: [
                                Icon(
                                  Icons.notifications,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context).tr('settings.reminderTime'),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
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
                              padding: const EdgeInsets.only(left: 32, top: 4),
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
                    const SizedBox(height: 20),

                    // الأزرار
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
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.trim().isNotEmpty) {
                              // ignore: unused_local_variable
                              final priority = getCategoryPriority(selectedCategory.id);

                              context.read<WeeklyCubit>().addTask(
                                titleController.text.trim(),
                                dayIndex,
                                isImportant: isImportant,
                                reminderTime: reminderTime,
                                categoryId: selectedCategory.id,
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: Text(AppLocalizations.of(context).tr('settings.add')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getDayLabel(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return 'سبت';
      case 1:
        return 'أحد';
      case 2:
        return 'اثنين';
      case 3:
        return 'ثلاثاء';
      case 4:
        return 'أربعاء';
      case 5:
        return 'خميس';
      default:
        return '';
    }
  }

  OutlineInputBorder customOutlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    );
  }
}

class _DayContent extends StatelessWidget {
  final int dayIndex;
  const _DayContent({required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is! WeeklySuccess) return const SizedBox.shrink();
        final isCollapsed = state.weeklyState.collapsedDays.contains(dayIndex);
        if (isCollapsed) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).tr('settings.allTasksDone'),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          );
        }
        return CustomListTasks(dayIndex: dayIndex);
      },
    );
  }
}
