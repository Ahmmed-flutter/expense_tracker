import 'package:flutter/material.dart';
import 'package:ecommerce_mart/core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  String _selectedCurrency = 'USD (\$)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingItem(
            'Dark Mode',
            'Switch between light and dark themes',
            trailing: Switch(
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Currency',
            'Select your preferred currency',
            onTap: () => _showCurrencyPicker(),
            trailing: Text(
              _selectedCurrency,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Language',
            'Select application language',
            trailing: const Text('English', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: trailing,
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final currencies = ['USD (\$)', 'EUR (€)', 'GBP (£)', 'BDT (৳)', 'INR (₹)'];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ...currencies.map((c) => ListTile(
                title: Text(c),
                onTap: () {
                  setState(() => _selectedCurrency = c);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }
}
