// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  // static const String dbName = "app_database.db";
  static const String dbName = "rental_bikes.db";

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), dbName);

    // Uncomment the line below ONLY once to delete the existing DB
    // await deleteDatabase(path); // ⚠️ Use with caution in production

    return await openDatabase(
      path,
      version: 2, // 🔼 Bumped version from 1 → 2
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // 🔄 Added upgrade callback
      singleInstance: true,
    );
  }

  // 🔧 This function adds new columns if DB is upgrading
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // 🚀 Add the missing userId column with default 0
      await db.execute(
        "ALTER TABLE Bookings ADD COLUMN userId INTEGER NOT NULL DEFAULT 0",
      );
    }
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE Users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fullname TEXT NOT NULL,
          userId TEXT NOT NULL,
          mobileNumber TEXT NOT NULL,
          emailId TEXT NOT NULL,
          password TEXT NOT NULL,
          role TEXT NOT NULL
        );
      ''');

    await db.execute('''
        CREATE TABLE LoginUsers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          fullname TEXT NOT NULL
        );
      ''');

    await db.execute('''
      CREATE TABLE Bikes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brandName TEXT NOT NULL,  
        model TEXT,
        numberPlate TEXT,
        location TEXT,
        fuelType TEXT,
        engineCC INTEGER,
        description TEXT,
        isAvailable INTEGER DEFAULT 1, 
        mileage REAL DEFAULT 0,
        imageUrl TEXT,
        userId INTEGER NOT NULL,
        createdAt TEXT,
        kmLimit REAL,
        makeYear INTEGER,
        transmission TEXT,
        seater INTEGER,
        fuelIncluded TEXT,
        FOREIGN KEY (userId) REFERENCES LoginUsers(id)
      );
    ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS Bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bikeId INTEGER NOT NULL,
    userId INTEGER NOT NULL,
    bikeName TEXT NOT NULL,
    bikeModel TEXT NOT NULL,
    userFullName TEXT NOT NULL,
    userPhone TEXT NOT NULL,
    userEmail TEXT NOT NULL,
    pickupDate TEXT NOT NULL,
    dropoffDate TEXT NOT NULL,
    pickupTime TEXT NOT NULL,
    dropoffTime TEXT NOT NULL,
    typeOfPayment TEXT NOT NULL,
    rentPerDay REAL NOT NULL,
    mileage REAL DEFAULT 0,
    extraPerKm REAL DEFAULT 0,
    securityDeposit REAL DEFAULT 0,
    subtotal REAL DEFAULT 0,
    balance REAL DEFAULT 0,
    durationInHours REAL NOT NULL,
    totalRent REAL NOT NULL,
    finalAmountPayable REAL NOT NULL,
    discount REAL DEFAULT 0,
    tax REAL DEFAULT 0,
    prepayment REAL DEFAULT 0,
    isConfirmed INTEGER NOT NULL DEFAULT 0,
    bikes TEXT NOT NULL,
    createdAt TEXT NOT NULL
  );
''');
  }

  static Future<List<Map<String, dynamic>>> getLoginUsers() async {
    final db = await database;
    return await db.query('LoginUsers');
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    log('db---->${db.query('Users')}');
    return await db.query('Users');
  }

  static Future<int> updateUser(Map<String, dynamic> user, int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.update('Users', user, where: 'id = ?', whereArgs: [id]);
    });
  }

  static Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawDelete("DELETE FROM Users WHERE id = ?", [id]);
    });
  }

  // CRUD Operations for Bikes
  static Future<int> insertBike(Map<String, dynamic> bike) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.insert('Bikes', bike);
    });
  }

  static Future<List<Map<String, dynamic>>> getBikes() async {
    final db = await database;
    final result = await db.query('Bikes');
    for (var row in result) {
      logs("SQLite Bike: ${row['name']}, Image URL: ${row['imageUrl']}");
    }

    log('DB Query Result: ${result.length}'); // ✅ Debugging log
    return result;
  }

  static Future<int> updateBike(Map<String, dynamic> bike, int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.update('Bikes', bike, where: 'id = ?', whereArgs: [id]);
    });
  }

  static Future<int> deleteBike(int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawDelete("DELETE FROM Bikes WHERE id = ?", [id]);
    });
  }

  // CRUD Operations for Bike Bookings
  static Future<int> insertBooking(Map<String, dynamic> booking) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.insert('Bookings', booking);
    });
  }

  static Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return await db.query('Bookings');
  }

  static Future<int> updateBooking(Map<String, dynamic> booking, int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.update(
        'Bookings',
        booking,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  static Future<int> deleteBooking(int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawDelete("DELETE FROM Bookings WHERE id = ?", [id]);
    });
  }
}
