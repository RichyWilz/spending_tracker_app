import '/database/database.dart';
import '/database/expense_model.dart';
import 'package:flutter/material.dart';
import 'month_view_model.dart';

void showDeleteExpenseDialog(BuildContext context,Month month, Expense expense, Function() refreshData){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('About to delete the UGX ${expense.amount} Expense entry created on  ${expense.date}.'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              // Delete the entry from the database
              final db = await DatabaseHelper.instance.database;
              await db.delete(
                'expense',
                where: 'day_id = ?',
                whereArgs: [expense.dayId],
              );
              await DatabaseHelper.instance.updateMonthFinalBalance(month.monthsId);
              refreshData();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without deleting
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}