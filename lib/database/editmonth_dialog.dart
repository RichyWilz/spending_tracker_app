import '/database/database.dart';
import '/database/month_view_model.dart';
import 'package:flutter/material.dart';

final List<String> months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];
String? selectedMonth;

void showEditMonthDialog(BuildContext context, Month month, Function() onMonthUpdated) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController monthController = TextEditingController(text: month.month);
  TextEditingController yearController = TextEditingController(text: month.year.toString());
  TextEditingController initialBalanceController = TextEditingController(text: month.deposit.toString());

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
              DropdownButtonFormField<String>(
                value: selectedMonth,
                decoration: InputDecoration(labelText: 'Month'),
                onChanged: (String? newValue) {
                  // Update the selectedMonth with the new value
                  selectedMonth = newValue;
                },
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                    'month': selectedMonth ?? 'Default Month',
                    'year': int.parse(yearController.text),
                    'deposit': double.parse(initialBalanceController.text),
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