
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:nekosama/nekosama.dart';


class NSSearchDbStats {

  final int totalAnimes;
  final Map<NSGenres, int> totalPerGenre;
  final Map<NSStatuses, int> totalPerStatus;
  final Map<NSTypes, int> totalPerType;
  final Map<int, int> totalPerYear;
  
  NSSearchDbStats({
    required this.totalAnimes,
    required this.totalPerGenre,
    required this.totalPerStatus,
    required this.totalPerType,
    required this.totalPerYear,
  });

  NSSearchDbStats copyWith({
    int? totalAnimes,
    Map<NSGenres, int>? totalPerGenre,
    Map<NSStatuses, int>? totalPerStatus,
    Map<NSTypes, int>? totalPerType,
    Map<int, int>? totalPerYear,
  }) => NSSearchDbStats(
    totalAnimes: totalAnimes ?? this.totalAnimes,
    totalPerGenre: totalPerGenre ?? this.totalPerGenre,
    totalPerStatus: totalPerStatus ?? this.totalPerStatus,
    totalPerType: totalPerType ?? this.totalPerType,
    totalPerYear: totalPerYear ?? this.totalPerYear,
  );

  Map<String, dynamic> toMap() => {
    "totalAnimes": totalAnimes,
    "totalPerGenre": totalPerGenre,
    "totalPerStatus": totalPerStatus,
    "totalPerType": totalPerType,
    "totalPerYear": totalPerYear,
  };

  factory NSSearchDbStats.fromMap(Map<String, dynamic> map) => NSSearchDbStats(
    totalAnimes: map["totalAnimes"] ?? 0,
    totalPerGenre: Map<NSGenres, int>.from(map["totalPerGenre"]),
    totalPerStatus: Map<NSStatuses, int>.from(map["totalPerStatus"]),
    totalPerType: Map<NSTypes, int>.from(map["totalPerType"]),
    totalPerYear: Map<int, int>.from(map["totalPerYear"]),
  );

  String toJson() => json.encode(toMap());

  factory NSSearchDbStats.fromJson(String source) => NSSearchDbStats.fromMap(json.decode(source));

  @override
  String toString() =>
    "SearchDBStats(totalAnimes: $totalAnimes, totalPerGenre: $totalPerGenre, totalPerStatus: $totalPerStatus, totalPerType: $totalPerType, totalPerYear: $totalPerYear)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    final mapEquals = const DeepCollectionEquality().equals;
    return other is NSSearchDbStats
      && other.totalAnimes == totalAnimes
      && mapEquals(other.totalPerGenre, totalPerGenre)
      && mapEquals(other.totalPerStatus, totalPerStatus)
      && mapEquals(other.totalPerType, totalPerType)
      && mapEquals(other.totalPerYear, totalPerYear);
  }

  @override
  int get hashCode => totalAnimes.hashCode
    ^ totalPerGenre.hashCode
    ^ totalPerStatus.hashCode
    ^ totalPerType.hashCode
    ^ totalPerYear.hashCode;
}
