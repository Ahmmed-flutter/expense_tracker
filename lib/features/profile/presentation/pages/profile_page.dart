import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce_mart/core/theme/app_colors.dart';
import 'package:ecommerce_mart/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecommerce_mart/features/auth/presentation/pages/login_page.dart';
import 'personal_info_page.dart';
import 'security_page.dart';
import 'notifications_settings_page.dart';
import 'settings_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _pickImage(WidgetRef ref, BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final authState = ref.read(authProvider);
      
      await ref.read(authProvider.notifier).updateProfile(
        authState.name ?? '',
        authState.email ?? '',
        base64Image,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: ClipOval(
                      child: authState.imagePath != null
                          ? Image.memory(
                              base64Decode(authState.imagePath!),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : Image.network(
                              'https://api.dicebear.com/7.x/avataaars/png?seed=${authState.name ?? 'User'}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  (authState.name ?? 'U').substring(0, 1).toUpperCase(),
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _pickImage(ref, context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              authState.name ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              authState.email ?? 'user@example.com',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            _buildProfileOption(
              Icons.person_outline,
              'Personal Info',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalInfoPage()),
              ),
            ),
            _buildProfileOption(
              Icons.notifications_outlined,
              'Notifications',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsSettingsPage()),
              ),
            ),
            _buildProfileOption(
              Icons.security_outlined,
              'Security',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityPage()),
              ),
            ),
            _buildProfileOption(
              Icons.settings_outlined,
              'Settings',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
            ),
            _buildProfileOption(Icons.help_outline, 'Help Center', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help Center is coming soon!')),
              );
            }),
            _buildProfileOption(
              Icons.logout,
              'Logout',
              () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive ? Colors.red : AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
