import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive booking updates and reminders'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive notifications via email'),
              value: _emailNotifications,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() => _emailNotifications = value);
                    }
                  : null,
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications on your device'),
              value: _pushNotifications,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() => _pushNotifications = value);
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch to dark theme'),
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dark mode feature coming soon!')),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
              trailing: const Icon(Icons.info_outline),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms & Conditions page coming soon!')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy Policy page coming soon!')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

