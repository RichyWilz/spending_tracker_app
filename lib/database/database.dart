import 'package:sqflite/sqflite.dart'; // Importing the sqflite package for working with SQLite databases
import 'package:path/path.dart'; // Importing the path package for working with file paths
import 'package:flutter/material.dart';
import 'package:spend_app/database/expense model.dart';
import '/database/month_view model.dart';


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

  Future<Database> _initDB(String filePath) async {
    final dbPath =
    await getDatabasesPath(); // Get the path to the directory where databases are stored
    final path = join(dbPath,
        filePath); // Join the directory path with the file name to get the complete file path

    return await openDatabase(path,
        version: 1,
        onCreate:
        _createDB); // Open the database at the specified path, with version 1, and call the _createDB function when creating the database
  }

  Future _createDB(Database db, int version) async {
    const idType =
        'INTEGER PRIMARY KEY AUTOINCREMENT'; // Constant for defining the data type of the primary key column
    const intType =
        'INTEGER NOT NULL'; // Constant for defining the data type of integer columns
    const textType =
        'TEXT NOT NULL'; // Constant for defining the data type of text columns

    await db.execute('''
CREATE TABLE months (
  months_id $idType,
  month $textType,
  year $intType,
  initial_balance $intType,
  final_balance $intType
)
'''); // Execute a SQL statement to create a "months" table with the specified columns and data types

    await db.execute('''
CREATE TABLE expense (
  day_id $idType,
  months_id $intType,
  date $textType,
  amount $intType,
  reason $textType,
  balance $intType,
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

  Future<List<Expense>> getExpensesByMonthId(int monthId) async {
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
}