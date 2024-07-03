import '/database/database.dart';
// created question mark at end of both ints for dayID and monthsId
class Expense {
  final int? dayId;
  final int? monthsId;
  final String date;
  final int amount;
  final String reason;
  final int balance;

  Expense({this.dayId, this.monthsId, required this.date, required this.amount, required this.reason, required this.balance});

  Map<String, dynamic> toMap() {
    return {
      'day_id':dayId,
      'months_id': monthsId,
      'date': date,
      'amount': amount,
      'reason': reason,
      'balance': balance,
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
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