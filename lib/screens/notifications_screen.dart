import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/providers/auth_provider.dart';
import 'package:parking_app/providers/notification_provider.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      if (authProvider.userId != null) {
        notificationProvider.loadNotifications(authProvider.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
    if (authProvider.userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const Center(child: Text('Please login to view notifications')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notificationProvider.unreadCount > 0)
            TextButton(
              onPressed: () async {
                await notificationProvider.markAllAsRead(authProvider.userId!);
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notificationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationProvider.notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => notificationProvider.refreshNotifications(authProvider.userId!),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notificationProvider.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notificationProvider.notifications[index];
                      return _NotificationCard(
                        notification: notification,
                        onTap: () async {
                          final isRead = (notification['is_read'] as int) == 0;
                          if (isRead) {
                            await notificationProvider.markAsRead(notification['id'] as String);
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = (notification['is_read'] as int) == 0;
    final type = notification['type'] as String;
    
    IconData icon;
    Color iconColor;
    switch (type) {
      case 'booking':
        icon = Icons.local_parking;
        iconColor = Colors.green;
        break;
      case 'reminder':
        icon = Icons.access_time;
        iconColor = Colors.orange;
        break;
      case 'payment':
        icon = Icons.payment;
        iconColor = Colors.blue;
        break;
      case 'offer':
        icon = Icons.local_offer;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    final createdAt = DateTime.parse(notification['created_at'] as String);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isRead ? null : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          notification['title'] as String,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification['body'] as String),
            const SizedBox(height: 4),
            Text(
              _formatTime(createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(time);
    }
  }
}


