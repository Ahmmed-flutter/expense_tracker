import 'package:flutter/material.dart';
import 'package:ecommerce_mart/core/theme/app_colors.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSecurityOption(
            context,
            Icons.lock_outline,
            'Change Password',
            'Update your login password',
            () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset link sent to your email')),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSecurityOption(
            context,
            Icons.fingerprint,
            'Biometric Authentication',
            'Use fingerprint or face ID',
            () {},
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          const SizedBox(height: 16),
          _buildSecurityOption(
            context,
            Icons.devices,
            'Connected Devices',
            'Manage your active sessions',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.security, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
    );
  }
}
