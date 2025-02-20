import 'package:flutter/material.dart';

class ReceiversScreen extends StatelessWidget {
  const ReceiversScreen({super.key});

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
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blood Receivers',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  semanticsLabel: 'Blood Receivers Page Title',
                ),
                const SizedBox(height: 24),
                _buildSearchBar(theme),
                const SizedBox(height: 24),
                Expanded(
                  child: _buildReceiverList(isLargeScreen),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search receivers...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.red[700]),
          suffixIcon: IconButton(
            icon: Icon(Icons.tune, color: Colors.red[700]),
            onPressed: () {},
            tooltip: 'Filter search results',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildReceiverList(bool isLargeScreen) {
    final bloodTypes = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
    final urgencyLabels = ['Urgent', 'Critical', 'Standard'];
    final urgencyColors = [
      Colors.red[700],
      Colors.orange[700],
      Colors.green[700]
    ];

    return ListView.builder(
      itemCount: 10,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final urgencyIndex = index % 3;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(
            bottom: 16,
            left: isLargeScreen ? 32 : 0,
            right: isLargeScreen ? 32 : 0,
          ),
          child: Card(
            elevation: 4,
            shadowColor: Colors.red.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: urgencyColors[urgencyIndex]!,
                      width: 6,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: 'receiver_$index',
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red[50],
                              child: Icon(
                                Icons.person,
                                size: 32,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Blood Type: ${bloodTypes[index % 8]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  urgencyColors[urgencyIndex]?.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              urgencyLabels[urgencyIndex],
                              style: TextStyle(
                                color: urgencyColors[urgencyIndex],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        Icons.location_on,
                        'City Hospital, Ward ${index + 1}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.bloodtype,
                        'Required: ${index + 1} units',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.info_outline,
                              color: Colors.red[700],
                            ),
                            label: Text(
                              'Details',
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.message),
                            label: const Text(
                              'Contact',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
