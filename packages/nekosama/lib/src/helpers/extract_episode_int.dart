
import 'package:nekosama/src/models/neko_sama_exception.dart';


int extractEpisodeInt(String episode) {
  final match = RegExp(r"\d+|film|\?").firstMatch(episode.toLowerCase())?.group(0);
  switch (match) {
    case "?":
      return 0;
    case "film":
      return 1;
    case null:
      throw NekoSamaException("Unable to extract episode number from String $episode");
    default:
      return int.parse(match!);
  }
}
