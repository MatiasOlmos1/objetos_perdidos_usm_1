import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:objetos_perdidos_usm1/page/crear_publicacion_page.dart';
import 'package:objetos_perdidos_usm1/models/datos_obj.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('publicaciones')
            .orderBy(
              'dateTime',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error al cargar publicaciones',
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay publicaciones disponibles',
              ),
            );
          }

          final publicaciones =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: publicaciones.length,

            itemBuilder: (context, index) {

              final publicacion =
                  DatosObj.fromFirestore(
                    publicaciones[index],
                  );

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                elevation: 4,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Image.memory(
                      publicacion.photo,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            publicacion.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            publicacion.description,
                          ),

                          const SizedBox(height: 10),

                          Chip(
                            label: Text(
                              publicacion.type,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Categoría: ${publicacion.categoryName}',
                          ),

                          Text(
                            'Lugar: ${publicacion.place}',
                          ),

                          Text(
                            'Estado: ${publicacion.status}',
                          ),

                          Text(
                            'Publicado por: ${publicacion.authorName}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

    default:
      return const Center(
        child: Text(
          'Página no encontrada',
        ),
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
      child: SafeArea(
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

            ListTile(
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
          ],
        ),
      ),
    ),

    body: SafeArea(
      child: Center(
        child: navegacion(),
      ),
    ),

    bottomNavigationBar: SafeArea(
      child: BottomNavigationBar(
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
    ),
  );
}
}