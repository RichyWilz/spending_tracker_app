import 'package:flutter/material.dart';
import '/database/expense_model.dart';
import 'package:spend_app/months_view_screen.dart';
import '/database/month_view_model.dart';
import '/database/database.dart';
import '/database/expenses_dialog.dart';
import '/database/deleteexpense_dialog.dart';
import '/database/editexpense_dialog.dart';


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
      // calculateTotalExpenses();
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

  // void calculateTotalExpenses() {
  //   totalExpensesFuture = DatabaseHelper.instance.calculateTotalExpenses(widget.selectedMonth.monthsId!);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses for ${widget.selectedMonth.month},${widget.selectedMonth.year}'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle your action on selection here
              print(value); // For example, print the selected week
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Week 1',
                  child: Text('Week 1'),
                ),
                PopupMenuItem<String>(
                  value: 'Week 2',
                  child: Text('Week 2'),
                ),
                PopupMenuItem<String>(
                  value: 'Week 3',
                  child: Text('Week 3'),
                ),
                PopupMenuItem<String>(
                  value: 'Week 4',
                  child: Text('Week 4'),
                ),
                PopupMenuItem<String>(
                  value: 'Week 5',
                  child: Text('Week 5'),
                ),
              ];
            },
            icon: Icon(Icons.sort),
          ),
        ],
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
                          "Initial Deposit: UGX ${widget.selectedMonth.deposit}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Overall Balance: UGX  ${widget.selectedMonth.finalBalance}"),
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Monthly Expense of ${widget.selectedMonth.month} of ${widget.selectedMonth.year}"),
                        ),
                        // SizedBox(height: 4.0),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text("rilli"),
                        // ),
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
                      return  Card(
                        child: ListTile(
                          title: Text(expense.date),
                          subtitle: Text('Spent: UGX ${expense.amount}\nBalance: UGX ${expense.balance}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showEditExpenseDialog(context, widget.selectedMonth ,expense, refreshExpenses);
                                  // Implement edit functionality
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Implement delete functionality
                                  showDeleteExpenseDialog(context,widget.selectedMonth, expense, refreshExpenses);
                                },
                              ),
                            ],
                          ),
                          // onTap: ,
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
          showAddExpenseDialog(context, widget.selectedMonth, refreshExpenses);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Expense'),
      ),
    );
  }
}