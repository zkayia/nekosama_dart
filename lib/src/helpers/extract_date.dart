
import 'package:nekosama_dart/src/models/neko_sama_exception.dart';


const _months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];

DateTime? extractDate(String date) {
	try {
		final dateFormatted = date.trim().toLowerCase();
		for (int i = 0; i < _months.length; i++) {
			if (dateFormatted.contains(_months.elementAt(i))) {
				final match = RegExp(r"\d+").firstMatch(dateFormatted)?.group(0);
				return match == null
					? null
					: DateTime(int.parse(match), i+1);
			}
		}
	} catch (e) {
		throw NekoSamaException("Failed to extract date from String '$date', $e");
	}
}
