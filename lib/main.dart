import 'package:consume_api/Onboarding/onboarding.dart';
import 'package:consume_api/layout/mainlayout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';  

void main() async {
    // Initialize date formatting for the 'id_ID' (Indonesian) locale.
    await initializeDateFormatting('id_ID', null);
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Token = prefs.getString('token');

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key,  this.hasSeenOnboarding = false});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Some error has Occurred');
            } else if (snapshot.hasData) {
              final token = snapshot.data!.getString('token'); 
              if (token != null) { // Validate is user has logged in
                return const MainLayout(initialIndex: 0,);
              } else {
                return const OnBoardingScreens();
              }
          }else{
            return const Text('Some Error');
          }}),
      );
    }
  }