import 'package:flutter/material.dart';
import 'package:ecommerce_mart/core/theme/app_colors.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _transactionAlerts = true;
  bool _marketingEmails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSwitchTile(
            'Push Notifications',
            'Receive alerts on your device',
            _pushNotifications,
            (val) => setState(() => _pushNotifications = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Email Notifications',
            'Receive updates via email',
            _emailNotifications,
            (val) => setState(() => _emailNotifications = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Transaction Alerts',
            'Get notified for every spend',
            _transactionAlerts,
            (val) => setState(() => _transactionAlerts = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Marketing Emails',
            'Newsletter and promo offers',
            _marketingEmails,
            (val) => setState(() => _marketingEmails = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
