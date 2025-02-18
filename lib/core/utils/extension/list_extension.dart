import 'dart:math' as math;

extension ListExtension<T> on List<T> {
  List<T> addBetweenEvery(T value) {
    List<T> r = [];
    asMap().forEach((i, e) => i < length - 1 ? r.addAll([e, value]) : r.add(e));
    return r;
  }

  // interleave merge list function
  List<T> interleave(List<T> other) {
    final result = <T>[];
    final length = math.max(this.length, other.length);
    for (var i = 0; i < length; i++) {
      if (i < this.length) {
        result.add(this[i]);
      }
      if (i < other.length) {
        result.add(other[i]);
      }
    }
    return result;
  }

  List<T> assignAll(List<T> other) {
    clear();
    addAll(other);
    return this;
  }

  T? atOrNull(int index) {
    try {
      return this[index];
    } catch (e) {
      return null;
    }
  }

  void replaceWhere(bool Function(T item) match, T replace) {
    int index = indexWhere(match);
    if (index != -1) {
      this[index] = replace;
    }
  }

  List<T> sort2(Comparable Function(T) getSortValue, bool isAsc) {
    sort((e1, e2) => (isAsc ? 1 : -1) * getSortValue(e1).compareTo(getSortValue(e2)));
    return this;
  }

  List<T> except(Iterable<T> items) {
    return where((e) => !items.contains(e)).toList();
  }

  // [1,2,3].intersection([2,3,4]) => [2,3]
  List<T> intersection(List<T> other, [bool Function(T, T)? equals]) {
    return where(
      (a) => equals == null
          ? other.contains(a)
          : other.any(
              (b) => equals.call(a, b),
            ),
    ).toList();
  }

  // [1,2,1,4].unique() => [1,2,4]
  List<T> unique([bool Function(T, T)? equals]) {
    if (equals == null) {
      return toSet().toList();
    }
    List<T> result = [];
    for (var item in this) {
      if (result.any((e) => equals(e, item)) == false) {
        result.add(item);
      }
    }
    return result;
  }

  List<T> sublistSafe(int start, [int? end]) {
    end ??= length;
    if (start < 0) start = 0;
    if (end > length) end = length;

    if (start >= end) return [];
    return sublist(start, end);
  }
}

extension IterableExt<T> on Iterable<T> {
  T reduceSafe(T Function(T value, T element) combine, {required T defaultValue}) {
    if (isEmpty) return defaultValue;
    return reduce(combine);
  }

  T? get firstOrNull {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }

  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  T? lastWhereOrNull(bool Function(T) test) {
    try {
      return lastWhere(test);
    } catch (e) {
      return null;
    }
  }

  Map<K, List<T>> groupBy<K>(K Function(T) getKey) {
    Map<K, List<T>> result = {};
    for (var item in this) {
      K key = getKey(item);
      if (result.containsKey(key)) {
        result[key]!.add(item);
      } else {
        result[key] = [item];
      }
    }
    return result;
  }

  String joinSlash() {
    return join('/ ');
  }

  List<TMap> mapList<TMap>(TMap Function(T element) mapper) {
    return map(mapper).toList();
  }

  bool all(bool Function(T element) condition) {
    return !any((element) => !condition(element));
  }

  int sumInt(int Function(T element) getValue) {
    return fold(0, (int total, element) => (total + getValue(element)));
  }

  double sumDouble(double Function(T element) getValue) {
    return fold(0, (double total, element) => (total + getValue(element)));
  }

  T? get lastOrNull => lastWhereOrNull((p0) => true);
}

extension IterableIterableExt<T> on Iterable<Iterable<T>> {
  Iterable<T> merge() {
    return reduceSafe((value, element) => [...value, ...element], defaultValue: []);
  }
}

List<T> intersection<T>(Iterable<Iterable<T>> iterables) {
  return iterables.map((e) => e.toSet()).reduce((a, b) => a.intersection(b)).toList();
}

extension NullableListExtension<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
