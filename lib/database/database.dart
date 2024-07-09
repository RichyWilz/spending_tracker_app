import 'package:sqflite/sqflite.dart'; // Importing the sqflite package for working with SQLite databases
import 'package:path/path.dart'; // Importing the path package for working with file paths
import 'package:flutter/material.dart';
import 'package:spend_app/database/expense_model.dart';
import '/database/month_view_model.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper
      ._init(); // Creating a singleton instance of the DatabaseHelper class
  static Database?
  _database; // Declaring a nullable static variable to hold the database instance

  DatabaseHelper._init(); // Private constructor for initializing the DatabaseHelper instance

  Future<Database> get database async {
    if (_database != null)
      return _database!; // If the database instance is already initialized, return it
    _database = await _initDB(
        'expenses.db'); // Otherwise, initialize the database and assign it to the _database variable
    return _database!; // Return the initialized database instance
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath =
    await getDatabasesPath(); // Get the path to the directory where databases are stored
    final path = join(dbPath,
        filePath); // Join the directory path with the file name to get the complete file path

    return await openDatabase(path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure, //line i added
    ); // Open the database at the specified path, with version 1, and call the _createDB function when creating the database
  }

  Future _createDB(Database db, int version) async {
    const idType =
        'INTEGER PRIMARY KEY AUTOINCREMENT'; // Constant for defining the data type of the primary key column
    const intType =
        'INTEGER NOT NULL'; // Constant for defining the data type of integer columns
    const floatType =
        'REAL NOT NULL';
    const textType =
        'TEXT NOT NULL'; // Constant for defining the data type of text columns

    await db.execute('''
CREATE TABLE months (
  months_id $idType,
  month $textType,
  year $intType,
  deposit $floatType,
  finalBalance $floatType
)
'''); // Execute a SQL statement to create a "months" table with the specified columns and data types

    await db.execute('''
CREATE TABLE expense (
  day_id $idType,
  months_id $intType,
  week $textType,
  date $textType,
  amount $floatType,
  reason $textType,
  balance $floatType,
  FOREIGN KEY (months_id) REFERENCES months (months_id) ON DELETE CASCADE
)
'''); // Execute a SQL statement to create an "expense" table with the specified columns and data types, and a foreign key constraint
  }

  Future close() async {
    final db = await instance.database; // Get the database instance
    db.close(); // Close the database connection
  }

  Future<int> createMonth(Map<String, dynamic> values) async {
    final db = await instance.database;
    return await db.insert('months', values);
  }

  Future<int> createExpense(Map<String, dynamic> values) async {
    final db = await instance.database;
    return await db.insert('expense', values);
  }

  Future<List<Month>> getMonths() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> monthMaps = await db.query('months');
    return List.generate(monthMaps.length, (i) {
      return Month.fromMap(monthMaps[i]);
    });
  }

  Future<Month> getMonthById(monthId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> monthMaps = await db.query(
        'months', where: 'months_id = ?', whereArgs: [monthId]);

    if (monthMaps.isNotEmpty) {
      // Assuming monthId is unique, there should only be one matching record
      return Month.fromMap(monthMaps.first);
    } else {
      // Handle the case where no month is found for the given monthId
      throw Exception('Month not found for id $monthId');
    }
  }

  Future<List<Expense>> getExpensesByMonthId(monthId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> expenseMaps = await db.query(
      'expense',
      where: 'months_id = ?',
      whereArgs: [monthId],
    );
    return List.generate(expenseMaps.length, (i) {
      return Expense.fromMap(expenseMaps[i]);
    });
  }


  Future<double> calculateTotalExpenses(monthId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> sums = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expense WHERE months_id = ?',
      [monthId],
    );

    // if (sums.isNotEmpty && sums[0]['total'] != null) {
    //   return sums[0]['total'] as double;
    // } else {
    //   return 0;
    // }
    if (sums[0]['total'] != null) {
      return sums[0]['total'] as double;
    } else {
      return 0;
    }
  }

  Future<void> updateMonthFinalBalance(monthId) async {
    final db = await instance.database;

    // Calculate the total expenses for the month
    double totalExpenses = await calculateTotalExpenses(monthId);

    // Retrieve the initial deposit for the month
    final List<Map<String, dynamic>> monthData = await db.query(
      'months',
      columns: ['deposit'],
      where: 'months_id = ?',
      whereArgs: [monthId],
    );

    if (monthData.isNotEmpty) {
      double deposit = monthData[0]['deposit'] as double;
      double finalBalance = deposit - totalExpenses;

      // Update the finalBalance in the months table
      await db.update(
        'months',
        {'finalBalance': finalBalance},
        where: 'months_id = ?',
        whereArgs: [monthId],
      );
    }
  }

  Future<double> calculateAdjustedBalanceForExpense(dayId, monthId,
      monthDeposit) async {
    final db = await instance.database;

    // Adjust the query to select expenses with day_id less than or equal to the specified dayId
    final List<Map<String, dynamic>> expenseSum = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expense WHERE day_id <= ? AND months_id = ?',
      [dayId, monthId],
    );

    double totalExpenses = 0.0;
    if (expenseSum.isNotEmpty && expenseSum[0]['total'] != null) {
      totalExpenses = (expenseSum[0]['total'] as num).toDouble();
    }

    // Subtract the total expenses from the month's deposit
    return monthDeposit - totalExpenses;
  }

  Future<List<Expense>> sortByWeek(monthId, String value) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> expenseMaps = await db.query(
      'expense',
      where: 'week= ? AND months_id = ?',
      whereArgs: [value, monthId],
    );
    return List.generate(expenseMaps.length, (i) {
      return Expense.fromMap(expenseMaps[i]);
    });
  }

  Future<List<Month>> getMonthsByMonthAndYear({String? month, String? year}) async {
    final db = await instance.database;
    List<String> whereClauses = [];
    List<dynamic> whereArguments = [];

    if (month != null) {
      whereClauses.add('month = ?');
      whereArguments.add(month);
    }
    if (year != null) {
      whereClauses.add('year = ?');
      whereArguments.add(year);
    }

    String whereString = whereClauses.join(' AND ');

    final List<Map<String, dynamic>> monthMaps = await db.query(
      'months',
      where: whereClauses.isNotEmpty ? whereString : null,
      whereArgs: whereArguments.isNotEmpty ? whereArguments : null,
    );

    return monthMaps.map((map) => Month.fromMap(map)).toList();
  }
}

