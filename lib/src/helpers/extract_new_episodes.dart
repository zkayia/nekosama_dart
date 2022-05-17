
import 'dart:convert';

import 'package:nekosama_dart/src/helpers/extract_episode_int.dart';
import 'package:nekosama_dart/src/helpers/extract_anime_id.dart';
import 'package:nekosama_dart/src/models/get_url_response.dart';
import 'package:nekosama_dart/src/models/ns_dated_episode.dart';


List<NSDatedEpisode> extractNewEpisodes(GetUrlResponse homePageResponse) {
	final reg = RegExp(r"(?<=var\slastEpisodes\s=\s)\[.+\](?=;)");
	final rawLastEps = reg.firstMatch(homePageResponse.body)?.group(0);
	return [
		if (rawLastEps != null)
			for (final Map<String, dynamic> episode in jsonDecode(rawLastEps))
				NSDatedEpisode(
					addedAt: _parseNewEpisodeTime(
						homePageResponse.timestamp,
						episode["time"] ?? "",
					),
					animeId: extractAnimeIdFromLink(episode["anime_url"]!),
					episodeNumber: extractEpisodeInt(episode["episode"] ?? "0"),
					thumbnail: episode["url_bg"] ?? "",
					url: "https://neko-sama.fr${episode["url"] ?? ""}",
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
