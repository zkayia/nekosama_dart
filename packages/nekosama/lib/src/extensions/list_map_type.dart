

extension ListWithMapType on List {

	List<T> mapType<T>(T? Function(dynamic e) toElement) => [
		for (final e in this)
			toElement(e),
	].whereType<T>().toList();
}
