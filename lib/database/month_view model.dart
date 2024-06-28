import '/database/database.dart';

class Month {
  final int monthsId;
  final String month;
  final int year;
  final int initialBalance;
  final int finalBalance;

  Month({required this.monthsId, required this.month, required this.year, required this.initialBalance, required this.finalBalance});

  factory Month.fromMap(Map<String, dynamic> map) {
    return Month(
      monthsId: map['months_id'],
      month: map['month'],
      year: map['year'],
      initialBalance: map['initial_balance'],
      finalBalance: map['final_balance'],
    );
  }
}