import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade50,
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 32 : 16,
              vertical: 24,
            ),
            child: Column(
              children: [
                _buildProfileHeader(theme),
                const SizedBox(height: 32),
                _buildProfileSection(
                  theme: theme,
                  title: 'Personal Information',
                  icon: Icons.person_outline,
                  children: [
                    _buildInfoRow(theme, 'Blood Type', 'A+', Icons.bloodtype),
                    _buildInfoRow(theme, 'Age', '28', Icons.cake_outlined),
                    _buildInfoRow(
                        theme, 'Gender', 'Male', Icons.people_outline),
                    _buildInfoRow(theme, 'Weight', '75 kg',
                        Icons.monitor_weight_outlined),
                  ],
                ),
                const SizedBox(height: 24),
                _buildProfileSection(
                  theme: theme,
                  title: 'Contact Information',
                  icon: Icons.contact_mail_outlined,
                  children: [
                    _buildInfoRow(theme, 'Phone', '+1 234 567 8900',
                        Icons.phone_outlined),
                    _buildInfoRow(theme, 'Email', 'john.doe@example.com',
                        Icons.email_outlined),
                    _buildInfoRow(theme, 'Address', '123 Main St, City',
                        Icons.location_on_outlined),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSettingsSection(theme),
                const SizedBox(height: 32),
                _buildLogoutButton(theme),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red.shade50,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.red.shade700,
                ),
              ),
              Material(
                shape: const CircleBorder(),
                elevation: 2,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.red.shade700,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                    onPressed: () {},
                    tooltip: 'Edit Profile Picture',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.red.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      ThemeData theme, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: Colors.red.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Settings',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingTile(
            title: 'Notification Preferences',
            icon: Icons.notifications_outlined,
            theme: theme,
            onTap: () {},
          ),
          _buildSettingTile(
            title: 'Privacy Settings',
            icon: Icons.security_outlined,
            theme: theme,
            onTap: () {},
          ),
          _buildSettingTile(
            title: 'Language',
            icon: Icons.language_outlined,
            theme: theme,
            onTap: () {},
          ),
          _buildSettingTile(
            title: 'Help & Support',
            icon: Icons.help_outline,
            theme: theme,
            onTap: () {},
          ),
          _buildSettingTile(
            title: 'Whatsapp AI Doctor',
            icon: Icons.medical_services_outlined,
            theme: theme,
            onTap: () {
              launchUrl(
                Uri.parse('https://api.whatsapp.com/send/?phone=918738030604&text=%E2%80%8B%E2%80%8CHi+August&type=phone_number&app_absent=0'),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required Function()? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.red.shade700,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade600,
        ),
      ),
      onTap: onTap!,
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.logout),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
