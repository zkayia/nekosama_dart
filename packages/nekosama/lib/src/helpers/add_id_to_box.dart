
import 'package:hive/hive.dart';


void addIdToBox(Box box, dynamic key, int toAdd) {
	final currentIds = box.get(key);
	if (!(currentIds?.contains(toAdd) ?? false)) {
		box.put(key, <int>[...currentIds ?? [], toAdd]);
	}
}
