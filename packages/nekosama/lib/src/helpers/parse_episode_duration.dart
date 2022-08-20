

Duration? parseEpisodeDuration(String duration) {
  final match = int.tryParse(
    RegExp(r"\d+").firstMatch(duration)?.group(0) ?? "",
  );
  return match == null ? null : Duration(minutes: match);
}
