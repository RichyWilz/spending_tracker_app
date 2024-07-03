import '/database/database.dart';
import '/database/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_app/expense_screen.dart';

void showAddExpenseDialog(BuildContext context,monthId, Function refreshExpenses) {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  // Assuming you have a method to get the current date in the desired format
  _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

  showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add New Expense'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: "Date (YYYY-MM-DD)",
                ),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: "Amount",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: "Reason",
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              final expense = Expense(
                monthsId: monthId,
                date: _dateController.text,
                amount: int.parse(_amountController.text),
                reason: _reasonController.text,
                balance: 0,
              );
              await DatabaseHelper.instance.createExpense(expense.toMap());
              refreshExpenses();
              Navigator.of(context).pop();
              },
              // Here, you would collect the data from the controllers
              // and use your method to insert it into the database.
              // For example:
              // DatabaseHelper.instance.createExpense({
              //   'date': _dateController.text,
              //   'amount': int.parse(_amountController.text),
              //   'reason': _reasonController.text,
              //   // You might need to add 'months_id' or other fields as required
              // });
            //   refreshExpenses();
            //   Navigator.of(context).pop();
            // },
          ),
        ],
      );
    },
  );
}