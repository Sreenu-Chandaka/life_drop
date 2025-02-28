import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_drop/widgets/receivers_bloc.dart';

import 'screens/LoginPage.dart';
import 'screens/blood_request_screen.dart';
import 'screens/lifedrophome.dart';


void main() {
  runApp(const LifeDropApp());
}

class LifeDropApp extends StatelessWidget {
  const LifeDropApp({super.key});

  

  @override
  Widget build(BuildContext context) {

      final apiService = ApiService();
    
    // Create our repository
    final receiversRepository = ReceiversRepository(apiService: apiService);
    
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BloodApi>(
          create: (context) => BloodApi(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BloodRequestBloc>(
            create: (context) => BloodRequestBloc(
              bloodApi: context.read<BloodApi>(),
            )..add(LoadBloodRequests()),
          ),
           BlocProvider<ReceiversBloc>(
          create: (context) => ReceiversBloc(apiService: apiService),
        ),
        ],
        child: MaterialApp(
          
        
      debugShowCheckedModeBanner: false,
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
      home: const PhoneLoginPage(),
        )));
  }
}
