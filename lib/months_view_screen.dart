import 'package:flutter/material.dart';
// import '/database/expense_model.dart';
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
      appBar: AppBar(title: const Text('Months'),
          actions: <Widget>[
          IconButton(
          icon: Icon(Icons.sort),
      onPressed: () {
        showSortDialog(context);
      },
    ),
            IconButton(
                onPressed: refreshMonths,
                icon: Icon(Icons.refresh)),
    ],),
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
                    title: Text('${month.month}, ${month.year}'),
                    subtitle: Text('Initial Deposit: UGX ${month.deposit} \nOverall Balance: UGX ${month.finalBalance}'),
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
                        ).then((_) {
                          // This block is executed when you come back to the months screen.
                          // Call a method to refresh the months screen here.
                          refreshMonths(); // Assuming refreshMonths() is your method to refresh the data.
                        });
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

  void showSortDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      // Variables to hold user input
      String monthInput = '';
      String yearInput = '';

      return AlertDialog(
          title: Text("Sort by Month and/or Year"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  monthInput = value;
                },
                decoration: InputDecoration(hintText: "Month (e.g., January)"),
              ),
              TextField(
                keyboardType: TextInputType.number, // Set the keyboard type to numeric
                onChanged: (value) {
                  // Assuming yearInput is a String. Convert only when needed.
                  yearInput = value;
                },
                decoration: InputDecoration(hintText: "Year (e.g., 2023)"),
              ),
            ],
          ),
          actions: <Widget>[
      TextButton(
      child: Text("Submit"),
    onPressed: () {
      // Step 4: Handle Form Submission
      Navigator.of(context).pop(); // Close the dialog
      queryAndDisplayMonths(monthInput.trim(), yearInput, context);
    },
      ),],); },); }

  // Step 4 & 5: Query Database and Display Results
  void queryAndDisplayMonths(String month, String year, BuildContext context) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      // String s_year = year.toString();
      // Fetch the sorted/filtered list of months from the database
      List<Month> sortedMonths = await dbHelper.getMonthsByMonthAndYear(month, year);
      // Update the state with the new list of months
      setState(() {
        months = Future.value(sortedMonths); // Correctly update the 'months' future
      });
    } catch (e) {
      // Handle errors, e.g., show an error message
      print("Error fetching sorted months: $e");
    }
  }
}
