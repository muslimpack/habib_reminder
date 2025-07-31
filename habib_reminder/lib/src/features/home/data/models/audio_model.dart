// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AudioModel extends Equatable {
  final int id;
  final String name;
  final String author;
  final String path;
  final bool play;
  final double volume;

  const AudioModel({
    required this.id,
    required this.name,
    required this.author,
    required this.path,
    this.play = true,
    this.volume = 1,
  });

  @override
  List<Object> get props {
    return [id, name, author, path, play, volume];
  }

  AudioModel copyWith({
    int? id,
    String? name,
    String? author,
    String? path,
    bool? play,
    double? volume,
  }) {
    return AudioModel(
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      path: path ?? this.path,
      play: play ?? this.play,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'author': author,
      'path': path,
      'play': play,
      'volume': volume,
    };
  }

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    return AudioModel(
      id: map['id'] as int,
      name: map['name'] as String,
      author: map['author'] as String,
      path: map['path'] as String,
      play: map['play'] as bool,
      volume: map['volume'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioModel.fromJson(String source) =>
      AudioModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
