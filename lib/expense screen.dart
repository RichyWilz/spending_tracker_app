// class ExpensesScreen extends StatefulWidget {
//   final int monthId;
//
//   ExpensesScreen({required this.monthId});
//
//   @override
//   _ExpensesScreenState createState() => _ExpensesScreenState();
// }
//
// class _ExpensesScreenState extends State<ExpensesScreen> {
//   late Future<List<Expense>> expensesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // Assuming getExpensesByMonthId is a method in your DatabaseHelper class
//     expensesFuture = DatabaseHelper.instance.getExpensesByMonthId(widget.monthId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Expenses')),
//       body: FutureBuilder<List<Expense>>(
//         future: expensesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final expenses = snapshot.data!;
//             return ListView.builder(
//               itemCount: expenses.length,
//               itemBuilder: (context, index) {
//                 final expense = expenses[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text(expense.reason),
//                     subtitle: Text('Amount: \$${expense.amount.toString()}'),
//                     // Add more details or actions for each expense item if needed
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No expenses found'));
//           }
//         },
//       ),
//     );
//   }
// }