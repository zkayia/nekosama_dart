
import 'package:nekosama/src/querys/ns_num_query.dart';


/// A `double` query model.
class NSdoubleQuery extends NSnumQuery<double> {

	/// A `double` query that validates numbers equals to [number].
	/// 
	/// Uses the `==` operator.
	NSdoubleQuery.equals(double number) : super.equals(number);

	/// A `double` query that validates numbers equals to any number in [numbers].
	/// 
	/// Uses `List.contains()`.
	NSdoubleQuery.equalsAny(List<double> numbers) : super.equalsAny(numbers);

	/// A `double` query that validates numbers between [start] inclusive and
	/// [stop] inclusive.
	/// 
	/// Implemented as `start <= number && number <= stop`.
	NSdoubleQuery.between(double start, double stop) : super.between(start, stop);

	/// A `double` query that validates numbers above [floor] inclusive.
	/// 
	/// Implemented as `floor <= number`.
	NSdoubleQuery.above(double floor) : super.above(floor);

	/// A `double` query that validates numbers under [ceiling] inclusive.
	/// 
	/// Implemented as `ceiling >= number`.
	NSdoubleQuery.under(double ceiling) : super.under(ceiling);
}
