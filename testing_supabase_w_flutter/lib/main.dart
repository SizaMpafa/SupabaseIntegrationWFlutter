import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/test_screen.dart'; // adjust path if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who Are You?',
      theme: ThemeData(
        fontFamily: 'Poppins', // optional
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C),
        ),
        useMaterial3: true,
      ),
      home: const TestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}