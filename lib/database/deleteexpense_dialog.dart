import '/database/database.dart';
import '/database/expense_model.dart';
import 'package:flutter/material.dart';
import 'month_view_model.dart';

void showDeleteExpenseDialog(BuildContext context,Month month, Expense expense, Function() refreshExpenses){
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
              // onMonthUpdated();
              // onExpenseUpdated();
              refreshExpenses();

              double fbalance = await DatabaseHelper.instance.calculateTotalExpenses(month.monthsId!);
              await db.update(
                'months',
                {
                  'finalBalance': month.deposit-fbalance,
                },
                where: 'months_id = ?',
                whereArgs: [month.monthsId],
              );
              await DatabaseHelper.instance.getMonths();
              // refreshMonths(); // Refresh the list of months
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