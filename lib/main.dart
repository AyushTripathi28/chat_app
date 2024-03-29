import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: const AuthGate(),
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          background: Color(0xff000000), // Colors.grey.shade900,
          primary: Colors.white,
          secondary: Color(0xff555565),
          tertiary: Color(0xff3455FF), // Colors.grey.shade800,
          inversePrimary: Color(0xff111115), // Colors.grey.shade300,
        ),
      ),
    );
  }
}
