import 'package:flutter/material.dart';
import '/database/expense_model.dart';
import '/expense_screen.dart';
import '/database/database.dart';
import '/database/month_view_model.dart';
import '/database/months_dialog.dart';
import '/database/editmonth_dialog.dart';
import '/database/deletemonth_dialog.dart';


class MonthsScreen extends StatefulWidget {
  @override
  _MonthsScreenState createState() => _MonthsScreenState();
}

class _MonthsScreenState extends State<MonthsScreen> {
  late Future<List<Month>> months;

  @override
  void initState() {
    super.initState();
    months = DatabaseHelper.instance.getMonths();
  }

  Future<void> refreshMonths() async {
    setState(() {
      months = DatabaseHelper.instance.getMonths();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Months')),
      body: FutureBuilder<List<Month>>(
        future: months,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final month = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('${month.month} ${month.year} ${month.monthsId} ${month.deposit} ${month.finalBalance}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showEditMonthDialog(context, month, refreshMonths);
                        } else if (value == 'delete') {
                          showDeleteConfirmationDialog(context, month, refreshMonths);
                          // Handle delete operation
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (month.monthsId != null) { // Ensure monthId is not null
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => ExpensesScreen(monthId: month.monthsId!, month: month),
                            builder: (context) => ExpensesWidget(selectedMonth: month),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('Hello, get started by clicking the button below to fill in a new monthly budget.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddMonthDialog(context, refreshMonths);
        },
        label: Text('New Monthly Budget'),
        icon: Icon(Icons.add),
      ),
    );
  }
}