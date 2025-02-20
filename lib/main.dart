import 'package:flutter/material.dart';

void main() {
  runApp(const LifeDropApp());
}

class LifeDropApp extends StatelessWidget {
  const LifeDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Drop',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.red[700]!,
          secondary: Colors.red[500]!,
          surface: Colors.white,
          background: Colors.grey[50]!,
          error: Colors.red[900]!,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Colors.red[900],
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Colors.red[800],
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Colors.red[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shadowColor: Colors.red.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            foregroundColor: Colors.white,
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LifeDropHome(),
    );
  }
}

class LifeDropHome extends StatefulWidget {
  const LifeDropHome({super.key});

  @override
  _LifeDropHomeState createState() => _LifeDropHomeState();
}

class _LifeDropHomeState extends State<LifeDropHome> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const BloodRequestScreen(),
    const ReceiversScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.bloodtype, color: Colors.red[700]),
            const SizedBox(width: 8),
            Text(
              'Life Drop',
              style: TextStyle(
                color: Colors.red[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.red[700],
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  color: _selectedIndex == 0 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.home,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bloodtype_outlined,
                  color: _selectedIndex == 1 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.bloodtype,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline,
                  color: _selectedIndex == 2 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.people,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Receivers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline,
                  color: _selectedIndex == 3 ? Colors.red[700] : Colors.grey),
              activeIcon: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context),
          const SizedBox(height: 24),
          _buildDonationStats(context),
          const SizedBox(height: 24),
          _buildHealthSection(context),
          const SizedBox(height: 24),
          _buildUpcomingDrives(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[700]!,
              Colors.red[500]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.red[700], size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back, John!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Blood Type: A+',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '12',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Donations',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '6L',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Blood Given',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '36',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Lives Saved',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Impact',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildStatCard(
                context,
                'Last Donation',
                '15 Days Ago',
                Icons.calendar_today,
              ),
              _buildStatCard(
                context,
                'Next Eligible',
                '75 Days',
                Icons.update,
              ),
              _buildStatCard(
                context,
                'Donation Streak',
                '3 Months',
                Icons.local_fire_department,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red[700]),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Metrics',
          style: Theme.of(context).textTheme.headlineMedium,
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
            _buildHealthCard(
              context,
              'Hemoglobin',
              '14.5 g/dL',
              Icons.favorite,
              Colors.green,
            ),
            _buildHealthCard(
              context,
              'Blood Pressure',
              '120/80',
              Icons.speed,
              Colors.blue,
            ),
            _buildHealthCard(
              context,
              'Weight',
              '75 kg',
              Icons.monitor_weight,
              Colors.orange,
            ),
            _buildHealthCard(
              context,
              'BMI',
              '22.5',
              Icons.health_and_safety,
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDrives(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Blood Drives',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.event, color: Colors.red[700]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Blood Drive',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'March ${index + 1}, 2025 • Central Park',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class BloodRequestScreen extends StatelessWidget {
  const BloodRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Request',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          _buildRequestForm(context),
          const SizedBox(height: 24),
          Text(
            'Active Requests',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _buildActiveRequests(context),
        ],
      ),
    );
  }

  Widget _buildRequestForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Request',
            style: TextStyle(
              color: Colors.red[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildFormField(
            label: 'Blood Type Required',
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'Select blood type',
                border: OutlineInputBorder(),
              ),
              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Units Required',
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter number of units',
                border: OutlineInputBorder(),
                suffixText: 'units',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Hospital Name',
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter hospital name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            label: 'Patient Condition',
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Describe patient condition',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Submit Request',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildActiveRequests(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'A+',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Emergency Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Urgent',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'City Hospital • 2 units needed',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Posted 2 hours ago',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View Details',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Respond'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReceiversScreen extends StatelessWidget {
  const ReceiversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Receivers',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search receivers...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.red[700]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red[50],
                            child: Icon(
                              Icons.person,
                              color: Colors.red[700],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Blood Type: ${[
                                    'A+',
                                    'B+',
                                    'O+',
                                    'AB+'
                                  ][index % 4]}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Urgent',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Location: City Hospital, Ward ${index + 1}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Required: 2 units',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View Details',
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Contact'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildStatsSection(),
          const SizedBox(height: 24),
          _buildProfileSection(
            title: 'Personal Information',
            children: [
              _buildInfoRow('Blood Type', 'A+'),
              _buildInfoRow('Age', '28'),
              _buildInfoRow('Gender', 'Male'),
              _buildInfoRow('Weight', '75 kg'),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileSection(
            title: 'Contact Information',
            children: [
              _buildInfoRow('Phone', '+1 234 567 8900'),
              _buildInfoRow('Email', 'john.doe@example.com'),
              _buildInfoRow('Address', '123 Main St, City'),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileSection(
            title: 'Settings',
            children: [
              _buildSettingTile(
                'Notification Preferences',
                Icons.notifications_outlined,
              ),
              _buildSettingTile('Privacy Settings', Icons.security_outlined),
              _buildSettingTile('Language', Icons.language_outlined),
              _buildSettingTile('Help & Support', Icons.help_outline),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red[50],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.red[700],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Regular Donor • 10 donations',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red[700]!,
            Colors.red[500]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total\nDonations', '10'),
          _buildStatItem('Lives\nSaved', '30'),
          _buildStatItem('Donation\nStreak', '3'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.red[900],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(String title, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.red[700]),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: () {},
    );
  }
}
