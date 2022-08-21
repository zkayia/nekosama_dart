

class NSProgress {

	final int total;
	final int progress;
	
	NSProgress({
		required this.total,
		required this.progress,
	});

	bool get isDone => progress >= total;

	NSProgress copyWith({
		int? total,
		int? progress,
	}) => NSProgress(
		total: total ?? this.total,
		progress: progress ?? this.progress,
	);

	@override
	String toString() => "NSProgress(total: $total, progress: $progress)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {
      return true;
    }
		return other is NSProgress && other.total == total && other.progress == progress;
	}

	@override
	int get hashCode => total.hashCode ^ progress.hashCode;
}
