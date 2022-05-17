

/// A `String` query model.
class NSStringQuery {

	/// The operation corresponding to this query.
	/// 
	/// Used internally by the search method.
	final bool Function(String other) operation;

	/// A `String` query that validates text containing [string].
	/// 
	/// Uses `String.contains()`.
	NSStringQuery.contains(String string) : 
		operation = ((String other) => other.contains(string));

	/// A `String` query that validates text identical to [string].
	/// 
	/// Uses the `==` operator.
	NSStringQuery.equals(String string) : 
		operation = ((String other) => other == string);

	/// A `String` query that validates text matching [pattern].
	/// 
	/// Uses `RegExp.hasMatch()`.
	NSStringQuery.match(RegExp pattern) : 
		operation = ((String other) => pattern.hasMatch(other));
}
