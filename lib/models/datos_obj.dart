import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  factory DatosObj.fromFirestore(
    DocumentSnapshot doc,
  ){
    final data = doc.data() as Map<String, dynamic>;
    return DatosObj(
      id: doc.id, 
      title: data['title'], 
      description: data['description'], 
      type: data['type'], 
      categoryId: data['categoryId'], 
      categoryName: data['categoryName'], 
      place: data['place'], 
      dateTime: (data['dateTime']as Timestamp).toDate(), 
      photo: (data['photo'] as Blob).bytes, 
      status: data['status'], 
      authorName: data['authorName'], 
      authorEmail:data['authorEmail']
    );
  }
}