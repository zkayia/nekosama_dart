
import 'package:nekosama/nekosama.dart' as base;
import 'package:nekosama_hive/src/ns_hive_search_db.dart';


/// The main api for the `nekosama` library.
class NekoSama extends base.NekoSama {

	/// The Hive search database handler.
	late NSHiveSearchDb hiveSearchDb;

	NekoSama({super.httpClient}) {
		hiveSearchDb = NSHiveSearchDb(this);
	}
}
