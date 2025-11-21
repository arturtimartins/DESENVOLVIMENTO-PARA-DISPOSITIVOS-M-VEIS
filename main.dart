import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/calendar_screen.dart';
import 'models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserModel? _currentUser;

  void _loginUser(String email, String password) {
    setState(() {
      _currentUser = UserModel(email: email, password: password);
    });
  }

  void _logoutUser() {
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artur Martins Silva - Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.light,
        ),
      ),
      home: _currentUser == null
          ? AuthScreen(onLogin: _loginUser)
          : CalendarScreen(
              user: _currentUser!,
              onLogout: _logoutUser,
            ),
    );
  }
}
