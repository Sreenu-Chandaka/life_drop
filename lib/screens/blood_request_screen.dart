//import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

class BloodRequest {
  final String id;
  final String bloodType;
  final int units;
  final String hospitalName;
  final String patientCondition;
  final bool isUrgent;
  final DateTime createdAt;
  final String location;
  final double distance;

  BloodRequest({
    required this.id,
    required this.bloodType,
    required this.units,
    required this.hospitalName,
    required this.patientCondition,
    this.isUrgent = false,
    required this.createdAt,
    required this.location,
    required this.distance,
  });

  factory BloodRequest.fromJson(Map<String, dynamic> json) {
    return BloodRequest(
      id: json['id'] as String,
      bloodType: json['bloodType'] as String,
      units: json['units'] as int,
      hospitalName: json['hospitalName'] as String,
      patientCondition: json['patientCondition'] as String,
      isUrgent: json['isUrgent'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      location: json['location'] as String,
      distance: json['distance'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bloodType': bloodType,
      'units': units,
      'hospitalName': hospitalName,
      'patientCondition': patientCondition,
      'isUrgent': isUrgent,
      'createdAt': createdAt.toIso8601String(),
      'location': location,
      'distance': distance,
    };
  }
}

// api/blood_api.dart


class BloodApi {
  static const String baseUrl = 'https://api.blooddonation.app/v1';
  final http.Client _client;

  BloodApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<BloodRequest>> getBloodRequests() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/requests'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => BloodRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load blood requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch blood requests: $e');
    }
  }

  Future<BloodRequest> createBloodRequest(Map<String, dynamic> requestData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/requests'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 201) {
        return BloodRequest.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create blood request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to submit blood request: $e');
    }
  }

  Future<void> donateToRequest(String requestId, Map<String, dynamic> donorData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/requests/$requestId/donate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(donorData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit donation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to submit donation: $e');
    }
  }

  // For demonstration purposes - mock data
  Future<List<BloodRequest>> getMockBloodRequests() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return [
      BloodRequest(
        id: '1',
        bloodType: 'O+',
        units: 3,
        hospitalName: 'City General Hospital',
        patientCondition: 'Accident victim with major blood loss',
        isUrgent: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        location: 'Downtown',
        distance: 1.2,
      ),
      BloodRequest(
        id: '2',
        bloodType: 'A-',
        units: 2,
        hospitalName: 'Memorial Medical Center',
        patientCondition: 'Scheduled surgery',
        isUrgent: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        location: 'North District',
        distance: 3.5,
      ),
      BloodRequest(
        id: '3',
        bloodType: 'AB+',
        units: 1,
        hospitalName: 'Children\'s Hospital',
        patientCondition: 'Pediatric emergency',
        isUrgent: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        location: 'East Side',
        distance: 2.8,
      ),
    ];
  }
}



abstract class BloodRequestEvent  {
  const BloodRequestEvent();

  @override
  List<Object> get props => [];
}

class LoadBloodRequests extends BloodRequestEvent {}

class SubmitBloodRequest extends BloodRequestEvent {
  final String bloodType;
  final int units;
  final String hospitalName;
  final String patientCondition;
  final bool isUrgent;

  const SubmitBloodRequest({
    required this.bloodType,
    required this.units,
    required this.hospitalName,
    required this.patientCondition,
    this.isUrgent = false,
  });

  @override
  List<Object> get props => [bloodType, units, hospitalName, patientCondition, isUrgent];
}

class SubmitDonation extends BloodRequestEvent {
  final String requestId;
  final Map<String, dynamic> donorData;

  const SubmitDonation({
    required this.requestId,
    required this.donorData,
  });

  @override
  List<Object> get props => [requestId, donorData];
}



abstract class BloodRequestState {
  const BloodRequestState();
  
  @override
  List<Object> get props => [];
}

class BloodRequestInitial extends BloodRequestState {}

class BloodRequestLoading extends BloodRequestState {}

class BloodRequestsLoaded extends BloodRequestState {
  final List<BloodRequest> requests;

  const BloodRequestsLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class BloodRequestSubmitting extends BloodRequestState {}

class BloodRequestSubmitSuccess extends BloodRequestState {
  final BloodRequest request;

  const BloodRequestSubmitSuccess(this.request);

  @override
  List<Object> get props => [request];
}

class DonationSubmitting extends BloodRequestState {}

class DonationSubmitSuccess extends BloodRequestState {}

class BloodRequestError extends BloodRequestState {
  final String message;

  const BloodRequestError(this.message);

  @override
  List<Object> get props => [message];
}



class BloodRequestBloc extends Bloc<BloodRequestEvent, BloodRequestState> {
  final BloodApi _bloodApi;

  BloodRequestBloc({required BloodApi bloodApi})
      : _bloodApi = bloodApi,
        super(BloodRequestInitial()) {
    on<LoadBloodRequests>(_onLoadBloodRequests);
    on<SubmitBloodRequest>(_onSubmitBloodRequest);
    on<SubmitDonation>(_onSubmitDonation);
  }

  Future<void> _onLoadBloodRequests(
    LoadBloodRequests event,
    Emitter<BloodRequestState> emit,
  ) async {
    emit(BloodRequestLoading());
    try {
      // For development/testing, using mock data
      // In production, use: final requests = await _bloodApi.getBloodRequests();
      final requests = await _bloodApi.getMockBloodRequests();
      emit(BloodRequestsLoaded(requests));
    } catch (e) {
      emit(BloodRequestError(e.toString()));
    }
  }

  Future<void> _onSubmitBloodRequest(
    SubmitBloodRequest event,
    Emitter<BloodRequestState> emit,
  ) async {
    emit(BloodRequestSubmitting());
    try {
      final requestData = {
        'bloodType': event.bloodType,
        'units': event.units,
        'hospitalName': event.hospitalName,
        'patientCondition': event.patientCondition,
        'isUrgent': event.isUrgent,
      };
      
      final request = await _bloodApi.createBloodRequest(requestData);
      emit(BloodRequestSubmitSuccess(request));
    } catch (e) {
      emit(BloodRequestError(e.toString()));
    }
  }

  Future<void> _onSubmitDonation(
    SubmitDonation event,
    Emitter<BloodRequestState> emit,
  ) async {
    emit(DonationSubmitting());
    try {
      await _bloodApi.donateToRequest(event.requestId, event.donorData);
      emit(DonationSubmitSuccess());
      add(LoadBloodRequests()); // Reload the requests after donation
    } catch (e) {
      emit(BloodRequestError(e.toString()));
    }
  }
}

// Updated blood_request_screen.dart with BLoC integration


class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBloodType;
  final _unitsController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _conditionController = TextEditingController();
  bool _isUrgent = false;

  @override
  void dispose() {
    _unitsController.dispose();
    _hospitalController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<BloodRequestBloc>().add(
            SubmitBloodRequest(
              bloodType: _selectedBloodType!,
              units: int.parse(_unitsController.text),
              hospitalName: _hospitalController.text,
              patientCondition: _conditionController.text,
              isUrgent: _isUrgent,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<BloodRequestBloc, BloodRequestState>(
        listener: (context, state) {
          if (state is BloodRequestSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Blood request submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Reset form or navigate back
            _formKey.currentState?.reset();
            _selectedBloodType = null;
            _unitsController.clear();
            _hospitalController.clear();
            _conditionController.clear();
            _isUrgent = false;
          } else if (state is BloodRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildRequestForm(context, state),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequestForm(BuildContext context, BloodRequestState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3F3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.bloodtype,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Blood Request',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Fill in the details below',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _FormField(
                    label: 'Blood Type Required',
                    isRequired: true,
                    child: _CustomDropdownField(
                      hint: 'Select blood type',
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                      value: _selectedBloodType,
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a blood type';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FormField(
                    label: 'Units Required',
                    isRequired: true,
                    child: _CustomTextField(
                      controller: _unitsController,
                      hint: 'Enter number of units',
                      suffixText: 'units',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter units required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FormField(
                    label: 'Hospital Name',
                    isRequired: true,
                    child: _CustomTextField(
                      controller: _hospitalController,
                      hint: 'Enter hospital name',
                      prefixIcon: Icons.local_hospital,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter hospital name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FormField(
                    label: 'Patient Condition',
                    child: _CustomTextField(
                      controller: _conditionController,
                      hint: 'Describe patient condition',
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(
                      'Mark as Urgent',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    subtitle: const Text(
                      'This will highlight your request to potential donors',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    value: _isUrgent,
                    onChanged: (value) {
                      setState(() {
                        _isUrgent = value;
                      });
                    },
                    activeColor: const Color(0xFFE53935),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is BloodRequestSubmitting ? null : _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: state is BloodRequestSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Request',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
}

// Utility classes improved with form validation
class _FormField extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isRequired;

  const _FormField({
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String? suffixText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;

  const _CustomTextField({
    this.controller,
    required this.hint,
    this.suffixText,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        suffixText: suffixText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey[400])
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }
}

class _CustomDropdownField extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const _CustomDropdownField({
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
      items: items
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
