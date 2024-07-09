import 'package:flutter/material.dart';
import '/database/database.dart';
// Import your database helper and any other necessary packages

// Function to show the sort dialog and fetch months
void showSortDialog(BuildContext context) {
  String? selectedMonth;
  String? selectedYear;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Sort by Month and Year'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              onChanged: (value) => selectedMonth = value,
              decoration: InputDecoration(hintText: "Month (e.g., 01 for January)"),
            ),
            TextField(
              onChanged: (value) => selectedYear = value,
              decoration: InputDecoration(hintText: "Year (e.g., 2023)"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              fetchMonths(context, selectedMonth, selectedYear);
            },
          ),
        ],
      );
    },
  );
}

// Function to fetch months based on the input
void fetchMonths(BuildContext context, String? month, String? year) async {
  // Implement the logic to fetch months from the database based on month and year
  // This might involve calling a method from your DatabaseHelper class
  // For example:
  var months = await DatabaseHelper.instance.getMonthsByMonthAndYear(month: month, year: year);
  // Then, you might want to update the state in the calling widget or navigate to a new screen with the results
}