import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:objetos_perdidos_usm1/page/crear_publicacion_page.dart';
import 'package:objetos_perdidos_usm1/models/datos_obj.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? usuario;
  int indexNavegacion = 0;

  @override
  void initState() {
    super.initState();
    usuario = FirebaseAuth.instance.currentUser;
  }

  Future<void> cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text(
          '¿Estás seguro de que deseas cerrar la sesión?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Widget navegacion() {
    switch (indexNavegacion) {
      case 0:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 80,
              color: Colors.indigo,
            ),
            SizedBox(height: 15),
            Text(
              'Inicio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );

      default:
        return const Center(
          child: Text('Página no encontrada'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetos Perdidos USM'),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                usuario?.displayName ?? 'Usuario',
              ),
              accountEmail: Text(
                usuario?.email ?? '',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: usuario?.photoURL != null
                    ? NetworkImage(usuario!.photoURL!)
                    : null,
                child: usuario?.photoURL == null
                    ? const Icon(
                        Icons.person,
                        size: 40,
                      )
                    : null,
              ),
              decoration: const BoxDecoration(
                color: Colors.indigo,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  indexNavegacion = 0;
                });
              },
            ),

            const Spacer(),

            const Divider(),

            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: cerrarSesion,
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: navegacion(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexNavegacion,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrearPublicacionPage(
                  currentUser: usuario!,
                  onSave: (DatosObj nuevaPublicacion) {
                    print(
                      'Publicación creada: ${nuevaPublicacion.title}',
                    );
                  },
                ),
              ),
            );

            return;
          }

          setState(() {
            indexNavegacion = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Publicar',
          ),
        ],
      ),
    );
  }
}