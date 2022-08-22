
import 'package:nekosama/src/enums/ns_sources.dart';


NSSources extractAnimeSource(String url) => NSSources.fromString(
  RegExp(r"(?<=-)(vf|vostfr)\b").firstMatch(url)?.group(0) ?? "",
) ?? NSSources.vostfr;
