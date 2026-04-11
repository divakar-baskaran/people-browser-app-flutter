import '../../data/model/person.dart';

class PeopleState {
  final bool isLoading;
  final List<Person> data;
  final List<Person> filtered;
  final String? error;

  const PeopleState({
    this.isLoading = false,
    this.data = const [],
    this.filtered = const [],
    this.error,
  });

  PeopleState copyWith({
    bool? isLoading,
    List<Person>? data,
    List<Person>? filtered,
    String? error,
  }) {
    return PeopleState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      filtered: filtered ?? this.filtered,
      error: error,
    );
  }
}