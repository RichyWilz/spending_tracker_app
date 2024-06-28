// class MonthsScreen extends StatefulWidget {
//   @override
//   _MonthsScreenState createState() => _MonthsScreenState();
// }
//
// class _MonthsScreenState extends State<MonthsScreen> {
//   late Future<List<Month>> months;
//
//   @override
//   void initState() {
//     super.initState();
//     months = DatabaseHelper.instance.getMonths();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Months')),
//       body: FutureBuilder<List<Month>>(
//         future: months,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final month = snapshot.data![index];
//                 return Card(
//                   child: ListTile(
//                     title: Text('${month.month} ${month.year}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ExpensesScreen(monthId: month.monthsId),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           }
//           return CircularProgressIndicator();
//         },
//       ),
//     );
//   }
// }