import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:objetos_perdidos_usm1/page/home_page.dart';
import 'package:objetos_perdidos_usm1/page/login_page.dart';

class VerificacionSesionPage extends StatelessWidget {
  const VerificacionSesionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }
        else{
          return const LoginPage();
        }
        
      },
    );
  }
}