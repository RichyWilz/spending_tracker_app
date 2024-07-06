import '/database/database.dart';
import '/database/month_view_model.dart';
import '/database/expense_model.dart';

import 'package:flutter/material.dart';

final List<String> weeklist = [
  'Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5'
];
String? selectedWeek;

void showEditExpenseDialog(BuildContext context,Month month, Expense expense, Function() refreshExpenses) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController monthController = TextEditingController(text: month.month);
  // TextEditingController yearController = TextEditingController(text: month.year.toString());
  // TextEditingController initialBalanceController = TextEditingController(text: month.initialBalance.toString());

  TextEditingController amountController = TextEditingController(text: expense.amount.toString());
  TextEditingController reasonController = TextEditingController(text: expense.reason);
  // TextEditingController balanceController = TextEditingController(text: expense.balance.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Expense'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: selectedWeek,
                decoration: InputDecoration(labelText: 'Week'),
                onChanged: (String? newValue) {
                  // Update the selectedMonth with the new value
                  selectedWeek = newValue;
                },
                items: weeklist.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount spent';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(labelText: 'Reason for Spending'),
                // keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please give a reason why you spent that money';
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
                  'expense',
                  {
                    'week': selectedWeek ?? 'Default Week',
                    'amount': double.parse(amountController.text),
                    'reason': reasonController.text,
                    'balance': month.finalBalance - double.parse(amountController.text),
                  },
                  where: 'day_id = ?',
                  whereArgs: [expense.dayId],
                );
                await DatabaseHelper.instance.calculateAdjustedBalanceForExpense(expense.dayId!, month.monthsId!, month.deposit);
                refreshExpenses(); // Call the callback to refresh the month list

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