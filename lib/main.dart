import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:laundryonapp_laundromat/Screens/dashboard_screen.dart';
import 'package:laundryonapp_laundromat/Screens/active_order_details_screen.dart';
import 'package:laundryonapp_laundromat/Screens/AuthScreen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaundryonApp Laundromat',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFF1C2649),
                displayColor: const Color(0xFF1C2649),
              ),
        ).copyWith(
          bodyMedium: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
