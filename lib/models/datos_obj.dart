import 'dart:typed_data';

class DatosObj {
  final String id;

  final String title;
  final String description;
  final String type;

  final String categoryId;
  final String categoryName;

  final String place;

  final DateTime dateTime;

  final Uint8List photo;

  final String status;

  final String authorName;
  final String authorEmail;

  DatosObj({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.place,
    required this.dateTime,
    required this.photo,
    required this.status,
    required this.authorName,
    required this.authorEmail,
  });
}