import 'package:flutter/material.dart';
import 'package:objetos_perdidos_usm1/models/datos_obj.dart';
import 'package:objetos_perdidos_usm1/page/detalle_publicacion_page.dart';
import 'package:objetos_perdidos_usm1/widget/colors.dart';

class ObjectCard extends StatelessWidget {
  final DatosObj object;

  const ObjectCard({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    final bool devuelto = object.status == "Devuelto";
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      elevation: 8,
      shadowColor: Colors.black26,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // foto
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.memory(
              object.photo,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fecha publicacion
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${object.dateTime.day}/${object.dateTime.month}/${object.dateTime.year}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ),
                // Titulo
                Text(
                  object.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kSecondaryColor,
                  ),
                ),

                const SizedBox(height: 10),
                // descripcion
                Text(
                  object.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: kText2Color, fontSize: 15),
                ),
                const SizedBox(height: 12),
                // Ubicacion publicacion
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        object.place,

                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // chip
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // estado perdido/encontrado
                    Chip(
                      avatar: Icon(
                        object.type == "Perdido"
                            ? Icons.search
                            : Icons.check_circle,
                        size: 18,
                      ),
                      label: Text(object.type),
                      backgroundColor: object.type == "Perdido"
                          ? Colors.red.shade200
                          : Colors.green.shade200,
                    ),
                    // categoria
                    Chip(
                      avatar: const Icon(Icons.category, size: 18),

                      label: Text(object.categoryName),

                      backgroundColor: Colors.blue.shade100,
                    ),
                    // estado devuelto/vigente
                    Chip(
                      avatar: Icon(
                        devuelto ? Icons.check_circle : Icons.schedule,
                        color: Colors.white,

                        size: 18,
                      ),
                      label: Text(
                        object.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: devuelto ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 10),
                // autor publicacion
                Text(
                  "Publicado por ${object.authorName}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 45,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          DetallePublicacionPage(
                            object: object,
                          ),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.visibility_outlined,
                    ),

                    label: const Text(
                      "Ver detalle de la publicación",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      foregroundColor: Colors.white,

                      elevation: 2,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}