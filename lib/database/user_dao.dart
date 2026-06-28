import 'package:sqflite/sqflite.dart';
import 'package:parking_app/database/database_helper.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<String> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await _dbHelper.database;
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    
    await db.insert(
      'users',
      {
        'id': userId,
        'name': name,
        'email': email,
        'password': password, // In production, hash this!
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return userId;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    
    return result.isEmpty ? null : result.first;
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    
    return result.isEmpty ? null : result.first;
  }

  Future<void> updateUser({
    required String userId,
    String? name,
    String? email,
  }) async {
    final db = await _dbHelper.database;
    final data = <String, dynamic>{};
    
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    
    if (data.isNotEmpty) {
      await db.update(
        'users',
        data,
        where: 'id = ?',
        whereArgs: [userId],
      );
    }
  }
}

