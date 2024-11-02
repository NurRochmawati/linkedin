import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
            title: 'LinkedIn Clone',
            home: authProvider.isLoggedIn ? HomeScreen() : AuthScreen(),
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity
                  .adaptivePlatformDensity, // Mengatur kerapatan visual
              scaffoldBackgroundColor: Colors.white, // Latar belakang putih
              appBarTheme: AppBarTheme(
                color: Colors.blue, // Warna AppBar
                elevation: 4, // Elevasi AppBar
              ),
            ),
          );
        },
      ),
    );
  }
}
