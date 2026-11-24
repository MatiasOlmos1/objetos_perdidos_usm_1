import 'package:flutter/material.dart';
import 'package:objetos_perdidos_usm1/models/datos_obj.dart';
import 'package:objetos_perdidos_usm1/page/detalle_publicacion_page.dart';

class ObjectCard extends StatelessWidget {
  final DatosObj object;

  const ObjectCard({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    final bool devuelto = object.status == "Devuelto";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetallePublicacionPage(object: object),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  object.photo,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // titulo
                    Text(
                      object.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // descripcion publicacion
                    Text(
                      object.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 8),

                    // lugar publicacion
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            object.place,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // CHIPS
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        // Perdido / Encontrado
                        Chip(
                          label: Text(object.type),
                          backgroundColor: object.type == "Perdido"
                              ? Colors.red.shade100
                              : Colors.blue.shade100,
                        ),

                        // CategorÃa
                        Chip(
                          label: Text(object.categoryName),
                          backgroundColor: Colors.grey.shade200,
                        ),

                        // Estado
                        Chip(
                          label: Text(
                            object.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: devuelto
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ],
                    ),
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