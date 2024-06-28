import '/database/database.dart';

class Expense {
  final int dayId;
  final int monthsId;
  final String date;
  final int amount;
  final String reason;
  final int balance;

  Expense({required this.dayId, required this.monthsId, required this.date, required this.amount, required this.reason, required this.balance});

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      dayId: map['day_id'],
      monthsId: map['months_id'],
      date: map['date'],
      amount: map['amount'],
      reason: map['reason'],
      balance: map['balance'],
    );
  }
}