import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _initialized = false;

  DatabaseHelper._init();

  Future<void> _initialize() async {
    if (_initialized) return;
    
    // Initialize FFI for desktop platforms
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // For web, sqflite doesn't work - we'll handle this differently
    // For mobile (Android/iOS), use default sqflite
    
    _initialized = true;
  }

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on web. Please use mobile or desktop platform.');
    }
    
    await _initialize();
    if (_database != null) return _database!;
    _database = await _initDB('parking_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Parking spots table
    await db.execute('''
      CREATE TABLE parking_spots (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        building_type TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        address TEXT NOT NULL,
        price_per_hour_car REAL NOT NULL,
        price_per_hour_bike REAL NOT NULL,
        total_car_spots INTEGER NOT NULL,
        available_car_spots INTEGER NOT NULL,
        total_bike_spots INTEGER NOT NULL,
        available_bike_spots INTEGER NOT NULL,
        rating REAL NOT NULL,
        image_url TEXT,
        amenities TEXT,
        is_available INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Bookings table
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        booking_number TEXT UNIQUE NOT NULL,
        user_id TEXT NOT NULL,
        parking_spot_id TEXT NOT NULL,
        vehicle_type TEXT NOT NULL,
        vehicle_number TEXT,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        total_price REAL NOT NULL,
        status TEXT NOT NULL,
        payment_id TEXT,
        payment_method TEXT,
        event_name TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (parking_spot_id) REFERENCES parking_spots(id)
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        type TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Payment methods table
    await db.execute('''
      CREATE TABLE payment_methods (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        method_type TEXT NOT NULL,
        details TEXT,
        is_default INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Insert default parking spots
    await _insertDefaultParkingSpots(db);
  }

  Future<void> _insertDefaultParkingSpots(Database db) async {
    final spots = [
      {
        'id': '1',
        'name': 'City Center Mall',
        'building_type': 'Mall',
        'latitude': 19.9975,
        'longitude': 73.7898,
        'address': 'City Center, Nashik Road, Nashik, Maharashtra 422101',
        'price_per_hour_car': 50.00,
        'price_per_hour_bike': 20.00,
        'total_car_spots': 200,
        'available_car_spots': 65,
        'total_bike_spots': 120,
        'available_bike_spots': 48,
        'rating': 4.6,
        'image_url': '',
        'amenities': 'Security,EV Charging,Covered,Cinema,Food Court,Shopping',
        'is_available': 1,
      },
      {
        'id': '2',
        'name': 'Nashik Central Mall',
        'building_type': 'Mall',
        'latitude': 19.9950,
        'longitude': 73.7920,
        'address': 'Central Mall, College Road, Nashik, Maharashtra 422005',
        'price_per_hour_car': 60.00,
        'price_per_hour_bike': 25.00,
        'total_car_spots': 180,
        'available_car_spots': 52,
        'total_bike_spots': 100,
        'available_bike_spots': 38,
        'rating': 4.7,
        'image_url': '',
        'amenities': 'Security,24/7 Access,Valet,Cinema,Shopping,Restaurants',
        'is_available': 1,
      },
      {
        'id': '3',
        'name': 'PVR Cinemas Parking',
        'building_type': 'Cinema',
        'latitude': 19.9980,
        'longitude': 73.7900,
        'address': 'PVR Cinemas, Trimbak Road, Nashik, Maharashtra 422002',
        'price_per_hour_car': 40.00,
        'price_per_hour_bike': 15.00,
        'total_car_spots': 100,
        'available_car_spots': 32,
        'total_bike_spots': 80,
        'available_bike_spots': 25,
        'rating': 4.4,
        'image_url': '',
        'amenities': 'Security,Covered,Movie Theater,Food Court',
        'is_available': 1,
      },
      {
        'id': '4',
        'name': 'IT Park Nashik',
        'building_type': 'Building',
        'latitude': 19.9930,
        'longitude': 73.7950,
        'address': 'IT Park, Satpur, Nashik, Maharashtra 422007',
        'price_per_hour_car': 45.00,
        'price_per_hour_bike': 18.00,
        'total_car_spots': 150,
        'available_car_spots': 58,
        'total_bike_spots': 90,
        'available_bike_spots': 42,
        'rating': 4.5,
        'image_url': '',
        'amenities': 'Security,EV Charging,Covered,24/7 Access',
        'is_available': 1,
      },
      {
        'id': '5',
        'name': 'Big Bazaar Parking',
        'building_type': 'Mall',
        'latitude': 19.9960,
        'longitude': 73.7880,
        'address': 'Big Bazaar, Old Agra Road, Nashik, Maharashtra 422001',
        'price_per_hour_car': 35.00,
        'price_per_hour_bike': 15.00,
        'total_car_spots': 250,
        'available_car_spots': 125,
        'total_bike_spots': 150,
        'available_bike_spots': 88,
        'rating': 4.3,
        'image_url': '',
        'amenities': 'Security,Covered,24/7 Access,Food Court,Shopping',
        'is_available': 1,
      },
      {
        'id': '6',
        'name': 'Inox Cinemas Parking',
        'building_type': 'Cinema',
        'latitude': 19.9990,
        'longitude': 73.7910,
        'address': 'Inox Cinemas, Gangapur Road, Nashik, Maharashtra 422013',
        'price_per_hour_car': 45.00,
        'price_per_hour_bike': 18.00,
        'total_car_spots': 120,
        'available_car_spots': 45,
        'total_bike_spots': 70,
        'available_bike_spots': 28,
        'rating': 4.6,
        'image_url': '',
        'amenities': 'Security,Covered,Cinema,Food Court,Restaurants',
        'is_available': 1,
      },
      {
        'id': '7',
        'name': 'Nashik Railway Station Parking',
        'building_type': 'Building',
        'latitude': 19.9630,
        'longitude': 73.8290,
        'address': 'Nashik Road Railway Station, Nashik, Maharashtra 422101',
        'price_per_hour_car': 30.00,
        'price_per_hour_bike': 12.00,
        'total_car_spots': 300,
        'available_car_spots': 145,
        'total_bike_spots': 200,
        'available_bike_spots': 95,
        'rating': 4.2,
        'image_url': '',
        'amenities': 'Security,24/7 Access,Covered',
        'is_available': 1,
      },
      {
        'id': '8',
        'name': 'Shalimar Mall Parking',
        'building_type': 'Mall',
        'latitude': 19.9940,
        'longitude': 73.7930,
        'address': 'Shalimar Mall, College Road, Nashik, Maharashtra 422005',
        'price_per_hour_car': 55.00,
        'price_per_hour_bike': 22.00,
        'total_car_spots': 160,
        'available_car_spots': 48,
        'total_bike_spots': 95,
        'available_bike_spots': 35,
        'rating': 4.5,
        'image_url': '',
        'amenities': 'Security,Covered,Cinema,Gaming Zone,Restaurants,Shopping',
        'is_available': 1,
      },
    ];

    final batch = db.batch();
    for (var spot in spots) {
      batch.insert('parking_spots', spot);
    }
    await batch.commit(noResult: true);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

