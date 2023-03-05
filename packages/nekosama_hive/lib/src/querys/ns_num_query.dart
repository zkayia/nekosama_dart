

abstract class NSnumQuery<T extends num> {

  final bool Function(T other) operation;

  NSnumQuery.equals(T number) :
    operation = ((T other) => other == number);
  
  NSnumQuery.equalsAny(Iterable<T> numbers) :
    operation = ((T other) => numbers.contains(other));
  
  NSnumQuery.between(T start, T stop) :
    operation = ((T other) => start <= other && other <= stop);
  
  NSnumQuery.above(T floor) :
    operation = ((T other) => floor <= other);

  NSnumQuery.under(T ceiling) :
    operation = ((T other) => ceiling >= other);
}
