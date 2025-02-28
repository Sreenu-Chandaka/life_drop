import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/receivers_bloc.dart';

class ReceiversScreen extends StatefulWidget {
  const ReceiversScreen({super.key});

  @override
  State<ReceiversScreen> createState() => _ReceiversScreenState();
}

class _ReceiversScreenState extends State<ReceiversScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Load receivers when screen initializes
    context.read<ReceiversBloc>().add(LoadReceiversEvent());
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 16),
                _buildFilters(),
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
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: () {
          context.read<ReceiversBloc>().add(LoadReceiversEvent());
        },
        tooltip: 'Refresh Receivers',
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
        controller: _searchController,
        style: theme.textTheme.bodyLarge,
        onChanged: (value) {
          // Debounce could be added here
          context.read<ReceiversBloc>().add(SearchReceiversEvent(value));
        },
        decoration: InputDecoration(
          hintText: 'Search receivers...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.red[700]),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.red[700]),
            onPressed: () {
              _searchController.clear();
              context.read<ReceiversBloc>().add(ClearFiltersEvent());
            },
            tooltip: 'Clear search',
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

  Widget _buildFilters() {
    return BlocBuilder<ReceiversBloc, ReceiversState>(
      builder: (context, state) {
        if (state is ReceiversLoaded) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Urgent',
                  state.activeUrgencyFilter == UrgencyLevel.urgent,
                  () {
                    context.read<ReceiversBloc>().add(
                          FilterByUrgencyEvent(UrgencyLevel.urgent),
                        );
                  },
                  Colors.red[700]!,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Critical',
                  state.activeUrgencyFilter == UrgencyLevel.critical,
                  () {
                    context.read<ReceiversBloc>().add(
                          FilterByUrgencyEvent(UrgencyLevel.critical),
                        );
                  },
                  Colors.orange[700]!,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Standard',
                  state.activeUrgencyFilter == UrgencyLevel.standard,
                  () {
                    context.read<ReceiversBloc>().add(
                          FilterByUrgencyEvent(UrgencyLevel.standard),
                        );
                  },
                  Colors.green[700]!,
                ),
                const SizedBox(width: 8),
                ...['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'].map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      type,
                      state.activeBloodTypeFilter == type,
                      () {
                        context.read<ReceiversBloc>().add(
                              FilterByBloodTypeEvent(type),
                            );
                      },
                      Colors.red[700]!,
                    ),
                  );
                }).toList(),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Clear All',
                  false,
                  () {
                    context.read<ReceiversBloc>().add(ClearFiltersEvent());
                  },
                  Colors.grey[700]!,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    Color color,
  ) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: color,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color),
      ),
    );
  }

  Widget _buildReceiverList(bool isLargeScreen) {
    return BlocBuilder<ReceiversBloc, ReceiversState>(
      builder: (context, state) {
        if (state is ReceiversInitial) {
          return const Center(
            child: Text('Please wait while we load blood receivers...'),
          );
        } else if (state is ReceiversLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]!),
            ),
          );
        } else if (state is ReceiversLoaded) {
          final receivers = state.receivers;
          
          if (receivers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No receivers found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (state.activeSearch != null && state.activeSearch!.isNotEmpty)
                    Text(
                      'No results for "${state.activeSearch}"',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<ReceiversBloc>().add(ClearFiltersEvent());
                      _searchController.clear();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.red[700],
                    ),
                    label: Text(
                      'Clear Filters',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: receivers.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final receiver = receivers[index];
              return _buildReceiverCard(receiver, isLargeScreen);
            },
          );
        } else if (state is ReceiversError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading receivers',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ReceiversBloc>().add(LoadReceiversEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReceiverCard(BloodReceiver receiver, bool isLargeScreen) {
    Color urgencyColor;
    switch (receiver.urgency) {
      case UrgencyLevel.urgent:
        urgencyColor = Colors.red[700]!;
        break;
      case UrgencyLevel.critical:
        urgencyColor = Colors.orange[700]!;
        break;
      case UrgencyLevel.standard:
        urgencyColor = Colors.green[700]!;
        break;
    }

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
                  color: urgencyColor,
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
                        tag: 'receiver_${receiver.id}',
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
                              receiver.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Blood Type: ${receiver.bloodType}',
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
                          color: urgencyColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          receiver.urgency.label,
                          style: TextStyle(
                            color: urgencyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.location_on,
                    receiver.location,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.bloodtype,
                    'Required: ${receiver.requiredUnits} units',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Navigate to details page
                        },
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
                        onPressed: () {
                          // Contact functionality
                        },
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
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
