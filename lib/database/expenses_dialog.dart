import 'package:sqflite/sqflite.dart';

import '/database/database.dart';
import '/database/expense_model.dart';
import '/database/month_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_app/expense_screen.dart';

final List<String> weeklist = [
  'Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5'
];
String? selectedWeek;

// void showAddExpenseDialog(BuildContext context,monthId, Function refreshExpenses) {
void showAddExpenseDialog(BuildContext context,Month month, Function refreshData) {
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
                monthsId: month.monthsId,
                week: selectedWeek ?? 'Default Week',
                date: _dateController.text,
                amount: double.parse(_amountController.text),
                reason: _reasonController.text,
                balance: month.finalBalance - double.parse(_amountController.text),
              );
              await DatabaseHelper.instance.createExpense(expense.toMap());
              double expenseBalance = await DatabaseHelper.instance.calculateAdjustedBalanceForExpense(expense.dayId, month.monthsId, month.deposit);

              final db = await DatabaseHelper.instance.database;
              await db.update(
                'expense',
                {
                  'balance': expenseBalance,
                },
                where: 'day_id = ?',
                whereArgs: [expense.dayId],
              );
              // Update the final balance of the month
              await DatabaseHelper.instance.updateMonthFinalBalance(month.monthsId);
              refreshData();
              Navigator.of(context).pop();

              },
          ),
        ],
      );
    },
  );
}