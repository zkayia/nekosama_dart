
import 'dart:convert';


class NSWebsiteInfo {

  final DateTime date;
  final String message;
  final String raw;
  
  const NSWebsiteInfo({
    required this.date,
    required this.message,
    required this.raw,
  });

  NSWebsiteInfo copyWith({
    DateTime? date,
    String? message,
    String? raw,
  }) => NSWebsiteInfo(
    date: date ?? this.date,
    message: message ?? this.message,
    raw: raw ?? this.raw,
  );

  Map<String, dynamic> toMap() => {
    "date": date.millisecondsSinceEpoch,
    "message": message,
    "raw": raw,
  };

  factory NSWebsiteInfo.fromMap(Map<String, dynamic> map) => NSWebsiteInfo(
    date: DateTime.fromMillisecondsSinceEpoch(map["date"]),
    message: map["message"] ?? "",
    raw: map["raw"] ?? "",
  );

  String toJson() => json.encode(toMap());

  factory NSWebsiteInfo.fromJson(String source) => NSWebsiteInfo.fromMap(json.decode(source));

  @override
  String toString() => "NSWebsiteInfo(date: $date, message: $message, raw: $raw)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is NSWebsiteInfo && other.date == date && other.message == message && other.raw == raw;
  }

  @override
  int get hashCode => date.hashCode ^ message.hashCode ^ raw.hashCode;
}
