import 'dart:convert';

import 'package:equatable/equatable.dart';

class NSWebsiteInfo extends Equatable {
  final DateTime date;
  final String message;
  final String raw;

  const NSWebsiteInfo({
    required this.date,
    required this.message,
    required this.raw,
  });

  @override
  List<Object?> get props => [date, message, raw];

  NSWebsiteInfo copyWith({
    DateTime? date,
    String? message,
    String? raw,
  }) =>
      NSWebsiteInfo(
        date: date ?? this.date,
        message: message ?? this.message,
        raw: raw ?? this.raw,
      );

  Map<String, dynamic> toMap() => {
        "date": date.toIso8601String(),
        "message": message,
        "raw": raw,
      };

  factory NSWebsiteInfo.fromMap(Map<String, dynamic> map) => NSWebsiteInfo(
        date: DateTime.parse(map["date"]),
        message: map["message"] ?? "",
        raw: map["raw"] ?? "",
      );

  String toJson() => json.encode(toMap());

  factory NSWebsiteInfo.fromJson(String source) => NSWebsiteInfo.fromMap(json.decode(source));
}
