import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkModeEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoDownloadWifi = true;
  String _downloadQuality = '1080p Full HD';
  double _cacheSizeMb = 142.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Profile & Settings', style: AppTypography.heading2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 36.r,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          'AM',
                          style: AppTypography.heading1.copyWith(color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex Mercer', style: AppTypography.heading3),
                        SizedBox(height: 4.h),
                        Text('alex.mercer@mdiscover.app', style: AppTypography.bodySmall),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'PRO VIP MEMBER',
                            style: AppTypography.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            _buildSectionHeader('Preferences'),
            _buildSwitchTile(
              icon: Icons.dark_mode_rounded,
              title: 'Dark Mode Theme',
              subtitle: 'Keep cinema dark aesthetic enabled',
              value: _darkModeEnabled,
              onChanged: (val) => setState(() => _darkModeEnabled = val),
            ),
            _buildSwitchTile(
              icon: Icons.notifications_active_rounded,
              title: 'Push Notifications',
              subtitle: 'Get alerts for new upcoming releases',
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            _buildSwitchTile(
              icon: Icons.wifi_rounded,
              title: 'Download via Wi-Fi Only',
              subtitle: 'Prevent cellular data usage',
              value: _autoDownloadWifi,
              onChanged: (val) => setState(() => _autoDownloadWifi = val),
            ),
            SizedBox(height: 20.h),
            _buildSectionHeader('Media & Downloads'),
            _buildListTile(
              icon: Icons.hd_rounded,
              title: 'Download Quality',
              trailingText: _downloadQuality,
              onTap: () {
                _showQualityDialog();
              },
            ),
            _buildListTile(
              icon: Icons.cleaning_services_rounded,
              title: 'Clear Cache',
              trailingText: '${_cacheSizeMb.toStringAsFixed(1)} MB',
              onTap: () {
                setState(() {
                  _cacheSizeMb = 0.0;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App cache cleared successfully!')),
                );
              },
            ),
            SizedBox(height: 20.h),
            _buildSectionHeader('About'),
            _buildListTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy & Terms',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.info_outline_rounded,
              title: 'App Version',
              trailingText: 'v1.0.0 (Build 102)',
              onTap: () {},
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out of MDiscover session')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.error,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: Text('Log Out', style: AppTypography.button.copyWith(color: AppColors.error)),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(
          title,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.titleLarge.copyWith(fontSize: 14.sp)),
        subtitle: Text(subtitle, style: AppTypography.bodySmall),
        value: value,
        activeTrackColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.titleLarge.copyWith(fontSize: 14.sp)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Text(trailingText, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(width: 8.w),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Download Quality', style: AppTypography.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['720p Standard', '1080p Full HD', '4K Ultra HD'].map((q) {
            final isSelected = _downloadQuality == q;
            return ListTile(
              title: Text(q, style: AppTypography.bodyLarge),
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
              onTap: () {
                setState(() => _downloadQuality = q);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
