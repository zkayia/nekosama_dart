
import 'package:nekosama/src/enums/ns_sources.dart';


abstract class NSAnimeBase {

  final int id;
  final String title;
  final Uri url;
  final NSSources source;
  final Uri thumbnail;
  final int episodeCount;

  NSAnimeBase({
    required this.id,
    required this.title,
    required this.url,
    required this.source,
    required this.thumbnail,
    required this.episodeCount,
  });
}
