class Month {
  final int? monthsId;
  final String month;
  final int year;
  final double deposit;
  final double finalBalance;

  Month({this.monthsId, required this.month, required this.year, required this.deposit,required this.finalBalance});

  Map<String, dynamic> toMap() {
    return {
      'months_id': monthsId,
      'month': month,
      'year': year,
      'deposit': deposit,
      'finalBalance': finalBalance,
    };
  }

  static Month fromMap(Map<String, dynamic> map) {
    return Month(
      monthsId: map['months_id'],
      month: map['month'],
      year: map['year'],
      deposit: map['deposit'],
      finalBalance: map['finalBalance'],
    );
  }
}

