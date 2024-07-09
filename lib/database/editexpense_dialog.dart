import '/database/database.dart';
import '/database/month_view_model.dart';
import '/database/expense_model.dart';

import 'package:flutter/material.dart';

final List<String> weeklist = [
  'Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5'
];
String? selectedWeek;

void showEditExpenseDialog(BuildContext context,Month month, Expense expense, Function() refreshData) {
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
                double expenseBalance = await DatabaseHelper.instance.calculateAdjustedBalanceForExpense(expense.dayId, month.monthsId, month.deposit);

                // Update the final balance of the month
                // await DatabaseHelper.instance.updateMonthFinalBalance(month.monthsId);
                await db.update(
                  'expense',
                  {
                    'week': selectedWeek ?? 'Default Week',
                    'amount': double.parse(amountController.text),
                    'reason': reasonController.text,
                    'balance': expenseBalance,
                  },
                  where: 'day_id = ?',
                  whereArgs: [expense.dayId],
                );
                // Update the final balance of the month
                await DatabaseHelper.instance.updateMonthFinalBalance(month.monthsId);
                refreshData(); // Call the callback to refresh the month list
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