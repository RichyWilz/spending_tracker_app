import '/database/database.dart';
import '/database/month_view_model.dart';
import '/database/expense_model.dart';
import 'package:flutter/material.dart';

void sortWeekly(BuildContext context,monthId, String value, Function() refreshData) async {
  // final db = await DatabaseHelper.instance.database;
  await DatabaseHelper.instance.sortByWeek(monthId, value);
  refreshData();
  // Navigator.of(context).pop();
}