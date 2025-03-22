import 'package:equatable/equatable.dart';
import 'package:nekosama/src/enums/ns_sources.dart';

abstract class NSAnimeBase extends Equatable {
  final int id;
  final String title;
  final Uri url;
  final NSSources source;
  final Uri thumbnail;
  final int? episodeCount;

  const NSAnimeBase({
    required this.id,
    required this.title,
    required this.url,
    required this.source,
    required this.thumbnail,
    required this.episodeCount,
  });

  @override
  List<Object?> get props => [id, title, url, source, thumbnail, episodeCount];
}
