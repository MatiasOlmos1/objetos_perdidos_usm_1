import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:objetos_perdidos_usm1/models/datos_obj.dart';
import 'package:objetos_perdidos_usm1/widget/colors.dart';

class CrearPublicacionPage extends StatefulWidget {
  final Function(DatosObj) onSave;
  final User currentUser;

  const CrearPublicacionPage({
    super.key,
    required this.onSave,
    required this.currentUser,
  });

  @override
  State<CrearPublicacionPage> createState() => _CrearPublicacionPageState();
}

class _CrearPublicacionPageState extends State<CrearPublicacionPage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _lugarController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Uint8List? _imagenBytes;

  String? _tipoSeleccionado;

  String? _categoriaSeleccionadaId;
  String? _categoriaSeleccionadaNombre;

  final List<String> tipos = ['Perdido', 'Encontrado'];

  Future<void> seleccionarImagen(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      setState(() {
        _imagenBytes = bytes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  Future<void> guardarPublicacion() async{
    if (!_formKey.currentState!.validate()){
      return;
    }
    if(_imagenBytes == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar una fotografia')
        )
      );
      return;
    }
    final pesoKB = _imagenBytes!.lengthInBytes / 1024;

    if (pesoKB > 850){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La fotografia es muy grande. Intente con otra imagen.',
          ),
        ),
      );
      return;
    }
    final nuevaPublicacion = DatosObj(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _tituloController.text.trim(),
      description: _descripcionController.text.trim(),
      type: _tipoSeleccionado!,
      categoryId: _categoriaSeleccionadaId!,
      categoryName: _categoriaSeleccionadaNombre!,
      place: _lugarController.text.trim(),
      dateTime: DateTime.now(),
      photo: _imagenBytes!,
      status: 'Vigente',
      authorName: widget.currentUser.displayName ?? 'Usuario',
      authorEmail: widget.currentUser.email ?? '',
      authorId: widget.currentUser.uid,
    ); 

    try {
      await FirebaseFirestore.instance.collection('publicaciones').add({
        'title': nuevaPublicacion.title,
        'description': nuevaPublicacion.description,
        'type': nuevaPublicacion.type,
        'categoryId': nuevaPublicacion.categoryId,
        'categoryName': nuevaPublicacion.categoryName,
        'place': nuevaPublicacion.place,
        'dateTime': Timestamp.fromDate(nuevaPublicacion.dateTime),
        'photo': Blob(nuevaPublicacion.photo),

        'status': nuevaPublicacion.status,

        'authorName': nuevaPublicacion.authorName,

        'authorEmail': nuevaPublicacion.authorEmail,
        'authorId' : widget.currentUser.uid,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicación creada correctamente')),
      );
      widget.onSave(nuevaPublicacion);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _lugarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        iconTheme: IconThemeData(
          color: kTextColor,
        ),
        title: const Text('Nueva Publicación', style: TextStyle(color: kTextColor),)),

      body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,

                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese un título';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _descripcionController,

                  maxLines: 4,

                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese una descripción';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _tipoSeleccionado,

                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),

                  items: tipos.map((tipo) {
                    return DropdownMenuItem(value: tipo, child: Text(tipo));
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      _tipoSeleccionado = value;
                    });
                  },

                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione un tipo';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categorias')
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return const Text('No hay categorías');
                    }

                    final categorias = snapshot.data!.docs;

                    return DropdownButtonFormField<String>(
                      value: _categoriaSeleccionadaId,

                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),

                      items: categorias.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc['nombre']),
                        );
                      }).toList(),

                      onChanged: (value) {
                        final categoria = categorias.firstWhere(
                          (doc) => doc.id == value,
                        );

                        setState(() {
                          _categoriaSeleccionadaId = value;

                          _categoriaSeleccionadaNombre = categoria['nombre'];
                        });
                      },

                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione una categoría';
                        }

                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _lugarController,

                  decoration: const InputDecoration(
                    labelText: 'Lugar donde se perdió o encontró',

                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese un lugar';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                if (_imagenBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: Image.memory(
                      _imagenBytes!,

                      height: 220,

                      width: double.infinity,

                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          seleccionarImagen(ImageSource.camera);
                        },

                        icon: const Icon(Icons.camera_alt),

                        label: const Text('Cámara'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          seleccionarImagen(ImageSource.gallery);
                        },

                        icon: const Icon(Icons.photo_library),

                        label: const Text('Galería'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: guardarPublicacion,

                    icon: const Icon(Icons.publish),

                    label: const Text('Publicar objeto'),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}