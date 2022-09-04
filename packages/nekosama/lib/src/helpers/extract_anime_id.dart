
import 'package:nekosama/src/models/neko_sama_exception.dart';


int extractAnimeId(Uri url) {
  final err = NekoSamaException("Unable to extract anime id from link $url");
  for (var i = 2; i < url.pathSegments.length; i++) {
    if (
      url.pathSegments[i-2] == "anime"
      && url.pathSegments[i-1] == "info"
    ) {
      return int.tryParse(
        RegExp(r"^(\d+)-").firstMatch(
          url.pathSegments[i],
        )?.group(1) ?? "",
      ) ?? (throw err);
    }
  }
  throw err;
}
