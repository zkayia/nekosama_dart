import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:nekosama/src/extensions/uri.dart';

class NSEpisode extends Equatable {
  final int episodeNumber;
  final Uri url;

  const NSEpisode({
    required this.episodeNumber,
    required this.url,
  });

  @override
  List<Object?> get props => [episodeNumber, url];

  NSEpisode copyWith({
    int? episodeNumber,
    Uri? url,
  }) =>
      NSEpisode(
        episodeNumber: episodeNumber ?? this.episodeNumber,
        url: url ?? this.url,
      );

  Map<String, dynamic> toMap() => {
        "episodeNumber": episodeNumber,
        "url": url.toString(),
      };

  factory NSEpisode.fromMap(Map<String, dynamic> map) => NSEpisode(
        episodeNumber: map["episodeNumber"] ?? 0,
        url: UriX.tryParseNull(map["url"]) ?? Uri(),
      );

  String toJson() => json.encode(toMap());

  factory NSEpisode.fromJson(String source) => NSEpisode.fromMap(json.decode(source));
}
