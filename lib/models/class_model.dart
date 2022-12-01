import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profinder_app_flutter/models/profesor_model.dart';
import 'package:profinder_app_flutter/models/user_model.dart';

class ClassModel {
  String? name;
  String? description;
  DateTime? date;
  int? duration;
  String? modality;
  List? tags;
  String? picture_tutor;
  String? level;
  //final DocumentReference tutor;

  ClassModel({
    this.name,
    this.description,
    this.date,
    this.duration,
    this.modality,
    this.tags,
    this.picture_tutor,
    this.level,
    //required this.tutor,
  });

  static ClassModel fromJson(Map<String, dynamic> json) => ClassModel(
        name: json['name'],
        description: json['description'],
        date: (json['date'] as Timestamp).toDate(),
        duration: json['duration'],
        modality: json['modality'],
        tags: json['tags'],
        picture_tutor: json['picture_tutor'],
        level: json['level'],
        //tutor: json['tutor'],
      );
}
