import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'welcome_page.dart';

void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SmartEggTrayApp());
}

class SmartEggTrayApp extends StatelessWidget 
{
  const SmartEggTrayApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Smart Egg Tray',
      theme: ThemeData
      (
        primarySwatch: Colors.lightBlue,
      ),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}