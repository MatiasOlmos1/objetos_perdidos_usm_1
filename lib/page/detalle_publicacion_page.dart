import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:objetos_perdidos_usm1/models/datos_obj.dart';
import 'package:objetos_perdidos_usm1/widget/colors.dart';


class DetallePublicacionPage extends StatelessWidget {
  final DatosObj object;

  const DetallePublicacionPage({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    final bool devuelto = object.status == "Devuelto";
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        iconTheme: IconThemeData(
          color: kTextColor,
        ),
        title: const Text("Detalle de publicación", style: TextStyle(color: kTextColor),)),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        
            children: [
              Image.memory(
                object.photo,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
        
              Padding(
                padding: const EdgeInsets.all(16),
        
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
        
                  children: [
                    Text(
                      object.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
        
                    const SizedBox(height: 16),
        
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
        
                      children: [
                        Chip(label: Text(object.type)),
        
                        Chip(label: Text(object.categoryName)),
        
                        Chip(
                          label: Text(object.status),
                          backgroundColor: devuelto
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 20),
        
                    const Text(
                      "Descripción",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
        
                    const SizedBox(height: 6),
        
                    Text(
                      object.description,
                      style: const TextStyle(fontSize: 16),
                    ),
        
                    const Divider(height: 30),
        
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_on),
                      title: const Text("Lugar"),
                      subtitle: Text(object.place),
                    ),
        
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time),
                      title: const Text("Fecha"),
                      subtitle: Text(object.dateTime.toString()),
                    ),
        
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person),
                      title: const Text("Autor"),
                      subtitle: Text(object.authorName),
                    ),
        
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.email),
                      title: const Text("Correo"),
                      subtitle: Text(object.authorEmail),
                    ),
                    const SizedBox(height: 20),

                    if (user?.uid == object.authorId)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: devuelto?null:()async{
                            final confirmar = await showDialog<bool>(
                              context:context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Confirmar'
                                ),
                                content: Text(
                                  '¿Desea marcar este objeto como devuelto?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(
                                        context, false,
                                      );
                                    }, 
                                    child: Text(
                                      'Cancelar'
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context, true,);
                                    }, 
                                    child: Text('Aceptar',)
                                  )
                                ],
                              ),
                            );
                            if(confirmar == true){
                              await FirebaseFirestore.instance.collection(
                                'publicaciones',
                              ).doc(object.id).update({
                                'status':'Devuelto',
                              });
                              if(context.mounted){
                                Navigator.pop(context);
                              }
                            }
                          },
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          label: Text(
                            devuelto? 'Objeto ya devuelto': 'Marcar como devuelto',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: kTextColor,
                          ),
                        ),
                      )


                    /*SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: devuelto? null: ()async {
                          await FirebaseFirestore.instance.collection('publicaciones').doc(object.id).update({'status': 'Devuelto',});
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.check_circle),
                        label: Text(
                          devuelto? 'Objeto ya devuelto' : 'Marcar como devuelto',
                        ),
                        style:  ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: kTextColor,
                        ),
                      ),
                    )*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}