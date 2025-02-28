// models/receiver.dart
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class BloodReceiver {
  final int id;
  final String name;
  final String bloodType;
  final String location;
  final int requiredUnits;
  final UrgencyLevel urgency;
  final String avatarUrl;

  BloodReceiver({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.location,
    required this.requiredUnits,
    required this.urgency,
    this.avatarUrl = '',
  });

  factory BloodReceiver.fromJson(Map<String, dynamic> json) {
    return BloodReceiver(
      id: json['id'],
      name: json['name'],
      bloodType: json['bloodType'],
      location: json['location'],
      requiredUnits: json['requiredUnits'],
      urgency: UrgencyLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['urgency'],
        orElse: () => UrgencyLevel.standard,
      ),
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bloodType': bloodType,
      'location': location,
      'requiredUnits': requiredUnits,
      'urgency': urgency.toString().split('.').last,
      'avatarUrl': avatarUrl,
    };
  }
}

enum UrgencyLevel {
  urgent,   // High priority
  critical, // Medium priority
  standard  // Normal priority
}

extension UrgencyLevelExtension on UrgencyLevel {
  String get label {
    switch (this) {
      case UrgencyLevel.urgent:
        return 'Urgent';
      case UrgencyLevel.critical:
        return 'Critical';
      case UrgencyLevel.standard:
        return 'Standard';
    }
  }
}

// services/api_service.dart

class ApiService {
  final Random _random = Random();
  final List<String> _bloodTypes = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  final List<String> _hospitals = ['City Hospital', 'General Medical Center', 'Regional Hospital', 'St. Mary\'s Clinic', 'University Hospital'];

  // Simulate API delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));
  }

  // Get all receivers
  Future<List<BloodReceiver>> getReceivers() async {
    await _simulateNetworkDelay();
    
    // Generate 15 random receivers
    return List.generate(15, (index) => _generateReceiver(index));
  }

  // Search receivers
  Future<List<BloodReceiver>> searchReceivers(String query) async {
    await _simulateNetworkDelay();
    
    // Get all receivers then filter
    final allReceivers = await getReceivers();
    
    if (query.isEmpty) return allReceivers;
    
    query = query.toLowerCase();
    
    return allReceivers.where((receiver) {
      return receiver.name.toLowerCase().contains(query) ||
             receiver.bloodType.toLowerCase().contains(query) ||
             receiver.location.toLowerCase().contains(query) ||
             receiver.urgency.label.toLowerCase().contains(query);
    }).toList();
  }

  // Filter receivers by blood type
  Future<List<BloodReceiver>> filterByBloodType(String bloodType) async {
    await _simulateNetworkDelay();
    
    final allReceivers = await getReceivers();
    
    if (bloodType.isEmpty) return allReceivers;
    
    return allReceivers.where((receiver) => 
      receiver.bloodType.toLowerCase() == bloodType.toLowerCase()
    ).toList();
  }

  // Filter receivers by urgency
  Future<List<BloodReceiver>> filterByUrgency(UrgencyLevel urgency) async {
    await _simulateNetworkDelay();
    
    final allReceivers = await getReceivers();
    return allReceivers.where((receiver) => receiver.urgency == urgency).toList();
  }

  // Get receiver details
  Future<BloodReceiver> getReceiverDetails(int id) async {
    await _simulateNetworkDelay();
    
    // In a real app, we would fetch from API
    // Here we just generate a receiver with the given ID
    return _generateReceiver(id);
  }

  // Helper to generate a random receiver
  BloodReceiver _generateReceiver(int index) {
    final urgencies = UrgencyLevel.values;
    
    return BloodReceiver(
      id: index + 1,
      name: 'Patient ${index + 1}',
      bloodType: _bloodTypes[_random.nextInt(_bloodTypes.length)],
      location: '${_hospitals[_random.nextInt(_hospitals.length)]}, Ward ${_random.nextInt(20) + 1}',
      requiredUnits: _random.nextInt(5) + 1,
      urgency: urgencies[_random.nextInt(urgencies.length)],
    );
  }
}

// bloc/receivers_event.dart


abstract class ReceiversEvent {
  const ReceiversEvent();

  @override
  List<Object> get props => [];
}

class LoadReceiversEvent extends ReceiversEvent {}

class SearchReceiversEvent extends ReceiversEvent {
  final String query;

  const SearchReceiversEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByBloodTypeEvent extends ReceiversEvent {
  final String bloodType;

  const FilterByBloodTypeEvent(this.bloodType);

  @override
  List<Object> get props => [bloodType];
}

class FilterByUrgencyEvent extends ReceiversEvent {
  final UrgencyLevel urgency;

  const FilterByUrgencyEvent(this.urgency);

  @override
  List<Object> get props => [urgency];
}

class ClearFiltersEvent extends ReceiversEvent {}

// bloc/receivers_state.dart

abstract class ReceiversState {
  const ReceiversState();
  
  @override
  List<Object> get props => [];
}

class ReceiversInitial extends ReceiversState {}

class ReceiversLoading extends ReceiversState {}

class ReceiversLoaded extends ReceiversState {
  final List<BloodReceiver> receivers;
  final String? activeSearch;
  final String? activeBloodTypeFilter;
  final UrgencyLevel? activeUrgencyFilter;

  const ReceiversLoaded({
    required this.receivers,
    this.activeSearch,
    this.activeBloodTypeFilter,
    this.activeUrgencyFilter,
  });

  @override
  List<Object> get props => [
    receivers, 
    activeSearch ?? '', 
    activeBloodTypeFilter ?? '', 
    activeUrgencyFilter ?? UrgencyLevel.standard
  ];

  ReceiversLoaded copyWith({
    List<BloodReceiver>? receivers,
    String? activeSearch,
    String? activeBloodTypeFilter,
    UrgencyLevel? activeUrgencyFilter,
  }) {
    return ReceiversLoaded(
      receivers: receivers ?? this.receivers,
      activeSearch: activeSearch ?? this.activeSearch,
      activeBloodTypeFilter: activeBloodTypeFilter ?? this.activeBloodTypeFilter,
      activeUrgencyFilter: activeUrgencyFilter ?? this.activeUrgencyFilter,
    );
  }
}

class ReceiversError extends ReceiversState {
  final String message;

  const ReceiversError(this.message);

  @override
  List<Object> get props => [message];
}

// bloc/receivers_bloc.dart


class ReceiversBloc extends Bloc<ReceiversEvent, ReceiversState> {
  final ApiService apiService;

  ReceiversBloc({required this.apiService}) : super(ReceiversInitial()) {
    on<LoadReceiversEvent>(_onLoadReceivers);
    on<SearchReceiversEvent>(_onSearchReceivers);
    on<FilterByBloodTypeEvent>(_onFilterByBloodType);
    on<FilterByUrgencyEvent>(_onFilterByUrgency);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  Future<void> _onLoadReceivers(
    LoadReceiversEvent event,
    Emitter<ReceiversState> emit,
  ) async {
    emit(ReceiversLoading());
    try {
      final receivers = await apiService.getReceivers();
      emit(ReceiversLoaded(receivers: receivers));
    } catch (e) {
      emit(ReceiversError('Failed to load blood receivers: ${e.toString()}'));
    }
  }

  Future<void> _onSearchReceivers(
    SearchReceiversEvent event,
    Emitter<ReceiversState> emit,
  ) async {
    emit(ReceiversLoading());
    try {
      final receivers = await apiService.searchReceivers(event.query);
      
      if (state is ReceiversLoaded) {
        final loadedState = state as ReceiversLoaded;
        emit(loadedState.copyWith(
          receivers: receivers,
          activeSearch: event.query,
        ));
      } else {
        emit(ReceiversLoaded(
          receivers: receivers,
          activeSearch: event.query,
        ));
      }
    } catch (e) {
      emit(ReceiversError('Failed to search receivers: ${e.toString()}'));
    }
  }

  Future<void> _onFilterByBloodType(
    FilterByBloodTypeEvent event,
    Emitter<ReceiversState> emit,
  ) async {
    emit(ReceiversLoading());
    try {
      final receivers = await apiService.filterByBloodType(event.bloodType);
      
      if (state is ReceiversLoaded) {
        final loadedState = state as ReceiversLoaded;
        emit(loadedState.copyWith(
          receivers: receivers,
          activeBloodTypeFilter: event.bloodType,
        ));
      } else {
        emit(ReceiversLoaded(
          receivers: receivers,
          activeBloodTypeFilter: event.bloodType,
        ));
      }
    } catch (e) {
      emit(ReceiversError('Failed to filter receivers: ${e.toString()}'));
    }
  }

  Future<void> _onFilterByUrgency(
    FilterByUrgencyEvent event,
    Emitter<ReceiversState> emit,
  ) async {
    emit(ReceiversLoading());
    try {
      final receivers = await apiService.filterByUrgency(event.urgency);
      
      if (state is ReceiversLoaded) {
        final loadedState = state as ReceiversLoaded;
        emit(loadedState.copyWith(
          receivers: receivers,
          activeUrgencyFilter: event.urgency,
        ));
      } else {
        emit(ReceiversLoaded(
          receivers: receivers,
          activeUrgencyFilter: event.urgency,
        ));
      }
    } catch (e) {
      emit(ReceiversError('Failed to filter receivers: ${e.toString()}'));
    }
  }

  Future<void> _onClearFilters(
    ClearFiltersEvent event,
    Emitter<ReceiversState> emit,
  ) async {
    emit(ReceiversLoading());
    try {
      final receivers = await apiService.getReceivers();
      emit(ReceiversLoaded(receivers: receivers));
    } catch (e) {
      emit(ReceiversError('Failed to clear filters: ${e.toString()}'));
    }
  }
}

// repository/receivers_repository.dart


class ReceiversRepository {
  final ApiService apiService;

  ReceiversRepository({required this.apiService});

  Future<List<BloodReceiver>> getReceivers() async {
    return await apiService.getReceivers();
  }

  Future<List<BloodReceiver>> searchReceivers(String query) async {
    return await apiService.searchReceivers(query);
  }

  Future<List<BloodReceiver>> filterByBloodType(String bloodType) async {
    return await apiService.filterByBloodType(bloodType);
  }

  Future<List<BloodReceiver>> filterByUrgency(UrgencyLevel urgency) async {
    return await apiService.filterByUrgency(urgency);
  }

  Future<BloodReceiver> getReceiverDetails(int id) async {
    return await apiService.getReceiverDetails(id);
  }
}
