import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bmi.dart';
import '../maps.dart';
import '../pulse.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Use SystemChrome within initState for StatefulWidget or in the app's initialization
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorScheme.surface,
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildProfileSection(context),
                    const SizedBox(height: 24),
                    _buildDonationMetrics(context),
                    const SizedBox(height: 24),
                    _buildHealthMetrics(context),
                    const SizedBox(height: 24),
                    _buildNearbyFacilities(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: colorScheme.onPrimary,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: colorScheme.primary,
                  semanticLabel: 'Profile picture',
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    'John Anderson',
                    style: textTheme.displayMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.water_drop,
                          color: colorScheme.onPrimary,
                          size: 16,
                          semanticLabel: 'Blood type',
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'A+ Blood Type',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationMetrics(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donation Timeline',
          style: textTheme.titleLarge,
          semanticsLabel: 'Donation Timeline section',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              TimelineCard(
                title: 'Last Donation',
                value: '15',
                unit: 'Days Ago',
                icon: Icons.calendar_today,
                colorType: TimelineCardColor.success,
              ),
              SizedBox(width: 16),
              TimelineCard(
                title: 'Next Eligible',
                value: '75',
                unit: 'Days',
                icon: Icons.update,
                colorType: TimelineCardColor.info,
              ),
              SizedBox(width: 16),
              TimelineCard(
                title: 'Streak',
                value: '3',
                unit: 'Months',
                icon: Icons.local_fire_department,
                colorType: TimelineCardColor.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetrics(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Metrics',
          style: textTheme.titleLarge,
          semanticsLabel: 'Health Metrics section',
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            HealthMetricCard(
              title: 'Blood Pressure',
              value: '120/80',
              unit: 'mmHg',
              icon: Icons.speed,
              colorType: HealthMetricCardColor.info,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PulseMonitorScreen(),
                  ),
                );
              },
            ),
            HealthMetricCard(
              title: 'BMI',
              value: '22.5',
              unit: '',
              icon: Icons.health_and_safety,
              colorType: HealthMetricCardColor.secondary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BMICalculator(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbyFacilities(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Facilities',
          style: textTheme.titleLarge,
          semanticsLabel: 'Nearby Facilities section',
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            NearbyFacilityCard(
              title: 'Hospitals',
              icon: Icons.local_hospital,
              colorType: FacilityCardColor.primary,
              onTap: () {
                MapLauncher.launchMapWithSearch("nearby hospitals");
              },
            ),
            const NearbyFacilityCard(
              title: 'Pharmacy',
              icon: Icons.medical_information,
              colorType: FacilityCardColor.info,
            ),
            const NearbyFacilityCard(
              title: 'Blood Banks',
              icon: Icons.health_and_safety,
              colorType: FacilityCardColor.secondary,
            ),
          ],
        ),
      ],
    );
  }
}

// Color enums for consistent styling
enum TimelineCardColor { primary, info, success, warning }
enum HealthMetricCardColor { primary, secondary, info, success }
enum FacilityCardColor { primary, secondary, info, success }

class TimelineCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final TimelineCardColor colorType;

  const TimelineCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.colorType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Get color based on type
    Color color;
    switch (colorType) {
      case TimelineCardColor.primary:
        color = colorScheme.primary;
        break;
      case TimelineCardColor.info:
        color = colorScheme.tertiary;
        break;
      case TimelineCardColor.success:
        color = colorScheme.secondary;
        break;
      case TimelineCardColor.warning:
        color = colorScheme.error;
        break;
    }

    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon, 
              color: color, 
              size: 20,
              semanticLabel: title,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class HealthMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final HealthMetricCardColor colorType;
  final VoidCallback? onTap;

  const HealthMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.colorType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Get color based on type
    Color color;
    switch (colorType) {
      case HealthMetricCardColor.primary:
        color = colorScheme.primary;
        break;
      case HealthMetricCardColor.secondary:
        color = colorScheme.secondary;
        break;
      case HealthMetricCardColor.info:
        color = colorScheme.tertiary;
        break;
      case HealthMetricCardColor.success:
        color = colorScheme.error;
        break;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon, 
                  color: color, 
                  size: 20,
                  semanticLabel: title,
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (unit.isNotEmpty)
                    Text(
                      unit,
                      style: textTheme.bodySmall?.copyWith(
                        color: color.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NearbyFacilityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final FacilityCardColor colorType;
  final VoidCallback? onTap;

  const NearbyFacilityCard({
    super.key,
    required this.title,
    required this.icon,
    required this.colorType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Get color based on type
    Color color;
    switch (colorType) {
      case FacilityCardColor.primary:
        color = colorScheme.primary;
        break;
      case FacilityCardColor.secondary:
        color = colorScheme.secondary;
        break;
      case FacilityCardColor.info:
        color = colorScheme.tertiary;
        break;
      case FacilityCardColor.success:
        color = colorScheme.error;
        break;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                  semanticLabel: title,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
