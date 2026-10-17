import 'package:flutter/material.dart';
import '../../models/schedule_item.dart';
import 'add_schedule_screen.dart';

/// Screen for editing an existing course schedule based on Figma 'Edit Course' specs.
/// Reuses identical fields from [AddScheduleScreen] with pre-filled schedule values.
class EditScheduleScreen extends StatelessWidget {
  final ScheduleItem scheduleToEdit;
  final List<ScheduleItem>? existingSchedules;

  const EditScheduleScreen({
    super.key,
    required this.scheduleToEdit,
    this.existingSchedules,
  });

  @override
  Widget build(BuildContext context) {
    return AddScheduleScreen(
      scheduleToEdit: scheduleToEdit,
      existingSchedules: existingSchedules,
    );
  }
}
