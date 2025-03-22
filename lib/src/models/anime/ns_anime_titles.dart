import 'dart:convert';

import 'package:equatable/equatable.dart';

class NSAnimeTitles extends Equatable {
  final String? english;
  final String? french;
  final String? romanji;
  final String? others;

  const NSAnimeTitles({
    this.english,
    this.french,
    this.romanji,
    this.others,
  });

  @override
  List<Object?> get props => [english, french, romanji, others];

  List<String> get asList => [english, french, romanji, others].whereType<String>().toList();

  String get asString => asList.join(" ");

  NSAnimeTitles copyWith({
    int? animeId,
    String? english,
    String? french,
    String? romanji,
    String? others,
  }) =>
      NSAnimeTitles(
        english: english ?? this.english,
        french: french ?? this.french,
        romanji: romanji ?? this.romanji,
        others: others ?? this.others,
      );

  Map<String, dynamic> toMap() => {
        "english": english,
        "french": french,
        "romanji": romanji,
        "others": others,
      };

  factory NSAnimeTitles.fromMap(Map<String, dynamic> map) => NSAnimeTitles(
        english: map["english"],
        french: map["french"],
        romanji: map["romanji"],
        others: map["others"],
      );

  String toJson() => json.encode(toMap());

  factory NSAnimeTitles.fromJson(String source) => NSAnimeTitles.fromMap(json.decode(source));
}
