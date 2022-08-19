
import 'dart:convert';


class NSTitles {

	final int animeId;
	final String? english;
	final String? french;
	final String? romanji;
	final String? others;
	
	NSTitles({
		required this.animeId,
		this.english,
		this.french,
		this.romanji,
		this.others,
	});

	NSTitles copyWith({
		int? animeId,
		String? english,
		String? french,
		String? romanji,
		String? others,
	}) => NSTitles(
		animeId: animeId ?? this.animeId,
		english: english ?? this.english,
		french: french ?? this.french,
		romanji: romanji ?? this.romanji,
		others: others ?? this.others,
	);

	Map<String, dynamic> toMap() => {
		"animeId": animeId,
		"english": english,
		"french": french,
		"romanji": romanji,
		"others": others,
	};

	factory NSTitles.fromMap(Map<String, dynamic> map) => NSTitles(
		animeId: map["animeId"],
		english: map["english"],
		french: map["french"],
		romanji: map["romanji"],
		others: map["others"],
	);

	String toJson() => json.encode(toMap());

	factory NSTitles.fromJson(String source) => NSTitles.fromMap(json.decode(source));

	@override
	String toString() =>
		"NSTitles(animeId: $animeId, english: $english, french: $french, romanji: $romanji, others: $others)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is NSTitles
			&& other.animeId == animeId
			&& other.english == english
			&& other.french == french
			&& other.romanji == romanji
			&& other.others == others;
	}

	@override
	int get hashCode => animeId.hashCode
		^ english.hashCode
		^ french.hashCode
		^ romanji.hashCode
		^ others.hashCode;
}
