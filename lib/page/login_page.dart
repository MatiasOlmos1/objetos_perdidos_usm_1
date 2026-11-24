import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:objetos_perdidos_usm1/widget/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool estaLogin = false;

  Future<void> singInWithGoogle() async {
    try {
      setState(() {
        estaLogin = true;
      });
      //Abre el selector de cuentas Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //Usuario canceló el login
      if (googleUser == null) {
        setState(() {
          estaLogin = false;
        });
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      //Verificacion de la existencia de la cuenta de Google
      final credencial = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //Inicio de sesion en Firebase
      await FirebaseAuth.instance.signInWithCredential(credencial);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      //Muestra error por pantalla
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
    } finally {
      setState(() {
        estaLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.find_in_page,
                    size: 80,
                    color: kPrimaryColor,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Objetos Perdidos USM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Encuentra o reporta objetos perdidos dentro del campus',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 35),

                //Boton Google Login
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: estaLogin ? null : singInWithGoogle,
                    label: Text(
                      estaLogin ? 'Iniciado sesión...' : 'Continuar con Google',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  'Utiliza tu cuenta de Google para acceder',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kText2Color),
                ),

                const SizedBox(height: 50),

                const Text(
                  'Desarrollo de Aplicaciones Móviles',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}