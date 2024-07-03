import 'package:flutter/material.dart';
import '/database/expense_model.dart';
import 'package:spend_app/months_view_screen.dart';
import '/database/month_view_model.dart';
import '/database/database.dart';
import '/database/expenses_dialog.dart';

class ExpensesWidget extends StatefulWidget {
  final Month selectedMonth;

  const ExpensesWidget({Key? key, required this.selectedMonth}) : super(key: key);

  @override
  _ExpensesWidgetState createState() => _ExpensesWidgetState();
}

class _ExpensesWidgetState extends State<ExpensesWidget> {
  late Future<List<Expense>> expensesFuture;
  late Future<int> totalExpensesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.selectedMonth.monthsId != null) {
      fetchExpensesForMonth();
      calculateTotalExpenses();
    }
  }

  Future<void> refreshExpenses() async {
    setState(() {
      expensesFuture = DatabaseHelper.instance.getExpensesByMonthId(widget.selectedMonth.monthsId!);
    });
  }

  void fetchExpensesForMonth() {
    expensesFuture = DatabaseHelper.instance.getExpensesByMonthId(widget.selectedMonth.monthsId!);
  }

  void calculateTotalExpenses() {
    totalExpensesFuture = DatabaseHelper.instance.calculateTotalExpenses(widget.selectedMonth.monthsId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses for ${widget.selectedMonth.month},${widget.selectedMonth.year}'),
      ),
      body: FutureBuilder<List<Expense>>(
        future: expensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "hello",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("rororr"),
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("hehe"),
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("rilli"),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Implement delete functionality
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Implement edit functionality
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Expense expense = snapshot.data![index];
                      return ListTile(
                        title: Text(expense.reason),
                        subtitle: Text('${expense.date} - \$${expense.amount}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Implement edit functionality
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Implement delete functionality
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No expenses found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle "New Expense" action
          showAddExpenseDialog(context, widget.selectedMonth.monthsId, refreshExpenses);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Expense'),
      ),
    );
  }
}