import '/database/database.dart';
import '/database/month_view_model.dart';
import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(BuildContext context, Month month, Function() onMonthUpdated){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('About to delete entry for ${month.month} ${month.year}.'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              // Delete the entry from the database
              final db = await DatabaseHelper.instance.database;
              await db.delete(
                'months',
                where: 'months_id = ?',
                whereArgs: [month.monthsId],
              );
              onMonthUpdated();
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