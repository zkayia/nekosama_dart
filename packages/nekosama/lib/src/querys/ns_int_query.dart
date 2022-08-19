
import 'package:nekosama/src/querys/ns_num_query.dart';


/// A `int` query model.
class NSintQuery extends NSnumQuery<int> {

	/// A `int` query that validates numbers equals to [number].
	/// 
	/// Uses the `==` operator.
	NSintQuery.equals(int number) : super.equals(number);

	/// A `int` query that validates numbers equals to any number in [numbers].
	/// 
	/// Uses `List.contains()`.
	NSintQuery.equalsAny(List<int> numbers) : super.equalsAny(numbers);

	/// A `int` query that validates numbers between [start] inclusive and
	/// [stop] inclusive.
	/// 
	/// Implemented as `start <= number && number <= stop`.
	NSintQuery.between(int start, int stop) : super.between(start, stop);

	/// A `int` query that validates numbers above [floor] inclusive.
	/// 
	/// Implemented as `floor <= number`.
	NSintQuery.above(int floor) : super.above(floor);

	/// A `int` query that validates numbers under [ceiling] inclusive.
	/// 
	/// Implemented as `ceiling >= number`.
	NSintQuery.under(int ceiling) : super.under(ceiling);
}
