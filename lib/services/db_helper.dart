// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:berry_happy/cubit/cart/cart_item.dart' as CartItem;

// class DatabaseHelper {
//   static Database? _database;
//   static const String _dbName = 'checkout_history.db';
//   static const String _tableName = 'checkout_history';

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     // Get directory path for both Android and iOS to store database.
//     final documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, _dbName);

//     // Open/create the database at a given path
//     return await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute('''
//           CREATE TABLE $_tableName(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             index INTEGER NOT NULL,
//             items TEXT NOT NULL,
//             checkout_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
//           )
//           ''');
//     });
//   }

//   Future<int> insertCheckoutHistory(int index, List<CartItem.CartItem> items) async {
//     final db = await database;
//     final Map<String, dynamic> row = {
//       'index': index,
//       'items': items.map((item) => item.toJson).toList(),
//     };
//     return await db.insert(_tableName, row);
//   }

//   Future<List<Map<String, dynamic>>> retrieveCheckoutHistory() async {
//     final db = await database;
//     return await db.query(_tableName, orderBy: 'checkout_time DESC');
//   }
// }
