
import 'dart:convert';

import 'package:nekosama/src/helpers/extract_episode_int.dart';
import 'package:nekosama/src/helpers/extract_anime_id.dart';
import 'package:nekosama/src/models/get_url_response.dart';
import 'package:nekosama/src/models/ns_dated_episode.dart';


List<NSNewEpisode> extractNewEpisodes(GetUrlResponse homePageResponse) {
	final reg = RegExp(r"(?<=var\slastEpisodes\s=\s)\[.+\](?=;)");
	final rawLastEps = reg.firstMatch(homePageResponse.body)?.group(0);
	return [
		if (rawLastEps != null)
			for (final Map<String, dynamic> episode in jsonDecode(rawLastEps))
				NSNewEpisode(
					animeId: extractAnimeIdFromLink(episode["anime_url"]!),
					animeUrl: Uri.parse("https://neko-sama.fr${episode["anime_url"]}"),
					episodeNumber: extractEpisodeInt(episode["episode"] ?? "0"),
					thumbnail: Uri.tryParse(episode["url_bg"] ?? "") ?? Uri(),
					url: Uri.parse("https://neko-sama.fr${episode["url"] ?? ""}"),
					addedAt: _parseNewEpisodeTime(
						homePageResponse.timestamp,
						episode["time"] ?? "",
					),
					episodeTitle: episode["title"] ?? "",
				),
	];
}

DateTime _parseNewEpisodeTime(DateTime responseTime, String time) {
	final match = RegExp(r"(\d+)\s(\w+)").firstMatch(time);
	final amount = int.tryParse(match?.group(1) ?? "") ?? 0;
	final unit = match?.group(2) ?? "";
	return responseTime.subtract(
		Duration(
			days: RegExp(r"^jours?$").hasMatch(unit) ? amount : 0,
			hours: RegExp(r"^heures?$").hasMatch(unit) ? amount : 0,
			minutes: RegExp(r"^minutes?$").hasMatch(unit) ? amount : 0,
			seconds: RegExp(r"^secondes?$").hasMatch(unit) ? amount : 0,
		),
	);
}
