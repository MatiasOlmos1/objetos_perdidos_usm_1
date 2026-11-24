import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:objetos_perdidos_usm1/page/home_page.dart';
import 'package:objetos_perdidos_usm1/page/login_page.dart';
import 'package:objetos_perdidos_usm1/widget/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
      ),
      home: const LoginPage(),

      routes: {
        '/login':(context) => const LoginPage(),
        '/home':(context) => const HomePage()
      },
    );
  }
}

