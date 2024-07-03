import '/database/database.dart';
import '/database/month_view_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Importing the sqflite package for working with SQLite databases
import 'package:path/path.dart'; // Importing the path package for working with file paths

// add_month_dialog.dart

// Define TextEditingControllers
final TextEditingController _monthController = TextEditingController();
final TextEditingController _yearController = TextEditingController();
final TextEditingController _initialBalanceController = TextEditingController();
final TextEditingController _finalBalanceController = TextEditingController();

void showAddMonthDialog(BuildContext context, Function refreshMonths) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Month'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _monthController,
                decoration: InputDecoration(labelText: 'Month'),
              ),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _initialBalanceController,
                decoration: InputDecoration(labelText: 'Initial Balance'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
              onPressed: () async {
                final month = Month(
                  month: _monthController.text,
                  year: int.parse(_yearController.text),
                  initialBalance: int.parse(_initialBalanceController.text),
                  finalBalance: 0,
                );
                await DatabaseHelper.instance.createMonth(month.toMap());
                refreshMonths();
                Navigator.of(context).pop();
              },
          ),
        ],
      );
    },
  );
}