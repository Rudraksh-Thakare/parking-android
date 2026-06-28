import 'package:sqflite/sqflite.dart';
import 'package:parking_app/database/database_helper.dart';

class NotificationDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<String> createNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
  }) async {
    final db = await _dbHelper.database;
    final notificationId = 'notif_${DateTime.now().millisecondsSinceEpoch}';
    
    await db.insert(
      'notifications',
      {
        'id': notificationId,
        'user_id': userId,
        'title': title,
        'body': body,
        'type': type,
        'is_read': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
    
    return notificationId;
  }

  Future<List<Map<String, dynamic>>> getNotificationsByUserId(String userId) async {
    final db = await _dbHelper.database;
    
    return await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> getUnreadCount(String userId) async {
    final db = await _dbHelper.database;
    
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> markAsRead(String notificationId) async {
    final db = await _dbHelper.database;
    
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  Future<void> markAllAsRead(String userId) async {
    final db = await _dbHelper.database;
    
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final db = await _dbHelper.database;
    
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }
}

