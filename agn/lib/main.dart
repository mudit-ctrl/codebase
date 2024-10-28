import 'package:agn/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GameApp())); // Wrap with ProviderScope
}

class GameApp extends StatelessWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set background to white
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
              bodyColor: Colors.black), // Change body text color to black
        ),
      ),
      home: HomeScreen(),
    );
  }
}
