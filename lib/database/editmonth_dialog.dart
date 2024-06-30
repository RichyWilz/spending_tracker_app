import '/database/database.dart';
import '/database/month_view_model.dart';
import 'package:flutter/material.dart';

void showEditMonthDialog(BuildContext context, Month month, Function() onMonthUpdated) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController monthController = TextEditingController(text: month.month);
  TextEditingController yearController = TextEditingController(text: month.year.toString());
  TextEditingController initialBalanceController = TextEditingController(text: month.initialBalance.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Month'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: monthController,
                decoration: InputDecoration(labelText: 'Month'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a month';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a year';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: initialBalanceController,
                decoration: InputDecoration(labelText: 'Initial Balance'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your original balance';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Update the month entry in the database
                final db = await DatabaseHelper.instance.database;
                await db.update(
                  'months',
                  {
                    'month': monthController.text,
                    'year': int.parse(yearController.text),
                    'initial_balance': int.parse(initialBalanceController.text),
                  },
                  where: 'months_id = ?',
                  whereArgs: [month.monthsId],
                );
                onMonthUpdated(); // Call the callback to refresh the month list
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without saving
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}