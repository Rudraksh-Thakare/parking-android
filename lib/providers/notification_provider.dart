import 'package:flutter/foundation.dart';
import 'package:parking_app/database/notification_dao.dart';
import 'package:parking_app/database/booking_dao.dart';
import 'package:parking_app/models/booking.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationDao _notificationDao = NotificationDao();
  final BookingDao _bookingDao = BookingDao();
  
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _currentUserId;

  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications(String userId) async {
    _currentUserId = userId;
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _notificationDao.getNotificationsByUserId(userId);
      _unreadCount = await _notificationDao.getUnreadCount(userId);
      
      // Check for upcoming bookings and create reminders
      await _checkAndCreateReminders(userId);
      
      // Reload to get any new notifications
      _notifications = await _notificationDao.getNotificationsByUserId(userId);
      _unreadCount = await _notificationDao.getUnreadCount(userId);
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      // On web or database error, use empty list
      if (e.toString().contains('UnsupportedError') || 
          e.toString().contains('web') ||
          e.toString().contains('SQLite')) {
        _notifications = [];
        _unreadCount = 0;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkAndCreateReminders(String userId) async {
    try {
      final bookings = await _bookingDao.getBookingsByUserId(userId);
      final now = DateTime.now();
      
      for (final booking in bookings) {
        if (booking.status != BookingStatus.confirmed) continue;
        
        // Check if booking starts in 30 minutes
        final timeUntilStart = booking.startTime.difference(now);
        if (timeUntilStart.inMinutes >= 25 && timeUntilStart.inMinutes <= 35) {
          // Check if reminder already exists
          final existingReminder = _notifications.firstWhere(
            (n) => n['type'] == 'reminder' && 
                   n['body'].toString().contains(booking.bookingNumber),
            orElse: () => {},
          );
          
          if (existingReminder.isEmpty) {
            try {
              await _notificationDao.createNotification(
                userId: userId,
                title: 'Reminder: Parking Booking',
                body: 'Your parking booking at ${booking.parkingSpot.name} starts in ${timeUntilStart.inMinutes} minutes. Booking Number: ${booking.bookingNumber}',
                type: 'reminder',
              );
            } catch (e) {
              // Ignore database errors on web
              if (!e.toString().contains('UnsupportedError') && 
                  !e.toString().contains('web') &&
                  !e.toString().contains('SQLite')) {
                rethrow;
              }
            }
          }
        }
        
        // Check if booking is about to end
        final timeUntilEnd = booking.endTime.difference(now);
        if (timeUntilEnd.inMinutes >= 0 && timeUntilEnd.inMinutes <= 10 && booking.status == BookingStatus.active) {
          final existingReminder = _notifications.firstWhere(
            (n) => n['type'] == 'reminder' && 
                   n['body'].toString().contains('ending soon'),
            orElse: () => {},
          );
          
          if (existingReminder.isEmpty) {
            try {
              await _notificationDao.createNotification(
                userId: userId,
                title: 'Parking Ending Soon',
                body: 'Your parking booking at ${booking.parkingSpot.name} ends in ${timeUntilEnd.inMinutes} minutes',
                type: 'reminder',
              );
            } catch (e) {
              // Ignore database errors on web
              if (!e.toString().contains('UnsupportedError') && 
                  !e.toString().contains('web') &&
                  !e.toString().contains('SQLite')) {
                rethrow;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking reminders: $e');
      // On web, just ignore the error
      if (e.toString().contains('UnsupportedError') || 
          e.toString().contains('web') ||
          e.toString().contains('SQLite')) {
        return;
      }
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationDao.markAsRead(notificationId);
      await loadNotifications(_currentUserId ?? '');
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      // On web, just update local state
      if (e.toString().contains('UnsupportedError') || 
          e.toString().contains('web') ||
          e.toString().contains('SQLite')) {
        final index = _notifications.indexWhere((n) => n['id'] == notificationId);
        if (index != -1) {
          _notifications[index]['is_read'] = 1;
          _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
          notifyListeners();
        }
      }
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      await _notificationDao.markAllAsRead(userId);
      await loadNotifications(userId);
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      // On web, just update local state
      if (e.toString().contains('UnsupportedError') || 
          e.toString().contains('web') ||
          e.toString().contains('SQLite')) {
        for (var notification in _notifications) {
          notification['is_read'] = 1;
        }
        _unreadCount = 0;
        notifyListeners();
      }
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationDao.deleteNotification(notificationId);
      await loadNotifications(_currentUserId ?? '');
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      // On web, just update local state
      if (e.toString().contains('UnsupportedError') || 
          e.toString().contains('web') ||
          e.toString().contains('SQLite')) {
        _notifications.removeWhere((n) => n['id'] == notificationId);
        notifyListeners();
      }
    }
  }

  Future<void> refreshNotifications(String userId) async {
    await loadNotifications(userId);
  }
}

