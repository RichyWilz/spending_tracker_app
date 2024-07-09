import '/database/database.dart';
import '/database/month_view_model.dart';
import '/database/expense_model.dart';
import 'package:flutter/material.dart';

Future<void> getExpensesByWeek(BuildContext context, int monthId, String week) async {
  try {
    List<Expense> expenses = await DatabaseHelper.instance.sortByWeek(monthId, week);
    // Update your UI with the retrieved expenses
    // This might involve calling setState to update the list of expenses displayed
  } catch (e) {
    // Handle any errors, possibly by showing an error message
    print("Error fetching expenses for week $week: $e");
  }
}