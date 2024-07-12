import 'package:flutter/material.dart';
import '/database/expense_model.dart';

class ExpenseDetailScreen extends StatefulWidget {
  Expense selectedExpense;

  ExpenseDetailScreen({Key? key, required this.selectedExpense}) : super(key: key);
  // const ExpensesWidget({Key? key, required this.selectedMonth}) : super(key: key);

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  // late Future<List<Expense>> expensesFuture;
  // late Future<int> totalExpensesFuture;
  // late Future<List<Month>> monthsFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Detail'),
      ),
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            children: <Widget>[
              Text(
                "UGX ${widget.selectedExpense.amount} spent",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Balance: ${widget.selectedExpense.balance}"),
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Date: ${widget.selectedExpense.date}"),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Week: ${widget.selectedExpense.week}"),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Reason: \n${widget.selectedExpense.reason}"),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),);
  }
}