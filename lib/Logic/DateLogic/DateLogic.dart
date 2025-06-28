import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> selectDate(BuildContext context, WidgetRef ref) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    locale: const Locale('ja'), // 必要に応じて
  );

  if (picked != null) {
    ref.read(selectedDateProvider.notifier).state = picked;
  }
}


final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
